$script:ModuleRoot = $PSScriptRoot
$script:ModuleVersion = (Import-PowerShellDataFile -Path "$($script:ModuleRoot)\PoshLibVirt.psd1").ModuleVersion

# Detect whether at some level dotsourcing was enforced
$script:doDotSource = Get-PSFConfigValue -FullName PoshLibVirt.Import.DoDotSource -Fallback $false
if ($PoshLibVirt_dotsourcemodule) { $script:doDotSource = $true }

<#
Note on Resolve-Path:
All paths are sent through Resolve-Path/Resolve-PSFPath in order to convert them to the correct path separator.
This allows ignoring path separators throughout the import sequence, which could otherwise cause trouble depending on OS.
Resolve-Path can only be used for paths that already exist, Resolve-PSFPath can accept that the last leaf my not exist.
This is important when testing for paths.
#>

# Detect whether at some level loading individual module files, rather than the compiled module was enforced
$importIndividualFiles = Get-PSFConfigValue -FullName PoshLibVirt.Import.IndividualFiles -Fallback $false
if ($PoshLibVirt_importIndividualFiles) { $importIndividualFiles = $true }
if (Test-Path (Resolve-PSFPath -Path "$($script:ModuleRoot)\..\.git" -SingleItem -NewChild)) { $importIndividualFiles = $true }
if ("<was compiled>" -eq '<was not compiled>') { $importIndividualFiles = $true }

function Import-ModuleFile
{
	<#
		.SYNOPSIS
			Loads files into the module on module import.

		.DESCRIPTION
			This helper function is used during module initialization.
			It should always be dotsourced itself, in order to proper function.

			This provides a central location to react to files being imported, if later desired

		.PARAMETER Path
			The path to the file to load

		.EXAMPLE
			PS C:\> . Import-ModuleFile -File $function.FullName

			Imports the file stored in $function according to import policy
	#>
	[CmdletBinding()]
	Param (
		[string]
		$Path
	)

	$resolvedPath = $ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($Path).ProviderPath
	if ($doDotSource) { . $resolvedPath }
	else { $ExecutionContext.InvokeCommand.InvokeScript($false, ([scriptblock]::Create([io.file]::ReadAllText($resolvedPath))), $null, $null) }
}

#region Load individual files
if ($importIndividualFiles)
{
	# Execute Preimport actions
	foreach ($path in (& "$ModuleRoot\internal\scripts\preimport.ps1")) {
		. Import-ModuleFile -Path $path
	}

	# Import all internal functions
	foreach ($function in (Get-ChildItem "$ModuleRoot\internal\functions" -Filter "*.ps1" -Recurse -ErrorAction Ignore))
	{
		. Import-ModuleFile -Path $function.FullName
	}

	# Import all public functions
	foreach ($function in (Get-ChildItem "$ModuleRoot\functions" -Filter "*.ps1" -Recurse -ErrorAction Ignore))
	{
		. Import-ModuleFile -Path $function.FullName
	}

	# Execute Postimport actions
	foreach ($path in (& "$ModuleRoot\internal\scripts\postimport.ps1")) {
		. Import-ModuleFile -Path $path
	}

	# End it here, do not load compiled code below
	return
}
#endregion Load individual files

#region Load compiled code
<#
This file loads the strings documents from the respective language folders.
This allows localizing messages and errors.
Load psd1 language files for each language you wish to support.
Partial translations are acceptable - when missing a current language message,
it will fallback to English or another available language.
#>
Import-PSFLocalizedString -Path "$($script:ModuleRoot)\en-us\*.psd1" -Module 'PoshLibVirt' -Language 'en-US'

<#
.SYNOPSIS
    Clear CommonParameters from Dictionary
.DESCRIPTION
    Clear CommonParameters from Dictionary
.PARAMETER ParameterDictionary
    The dictionary to clean up
.EXAMPLE
    Clear-PSBoundParameters -ParameterDictionary $PSBoundParameters

    Clears the PSBoundParameters dictionary
#>
function Clear-PSBoundParameters
{
    [CmdletBinding()]
    param
    (
        [hashtable]
        $ParameterDictionary
    )

    $newTable = $ParameterDictionary.Clone()
    'Verbose', 'Debug', 'InformationAction', 'ErrorAction', 'WarningAction', 'ErrorVariable', 'InformationVariable', 'OutVariable', 'PipelineVariable', 'OutBuffer' |
    ForEach-Object { $newTable.Remove($_) }

    $newTable
}


<#
.SYNOPSIS
    Create a VM snapshot
.DESCRIPTION
    Create a VM snapshot
.EXAMPLE
    Get-PLVVm | Checkpoint-PLVVm

    Create snapshots of all running VMs
.PARAMETER WhatIf
    Indicates that action should be simulated
.PARAMETER Confirm
    Indicates that a confirmation is requested
#>
function Checkpoint-PLVVm
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param
    (
        # The hosts to create a snapshot of
        [Parameter(Mandatory, ParameterSetName = 'Name', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $VmName,

        # The VirtualMachine object to create a snapshot of
        [Parameter(Mandatory, ParameterSetName = 'Object', ValueFromPipeline)]
        [PoshLibVirt.VirtualMachine[]]
        $Computer,

        # The snapshot name
        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [Parameter(Mandatory, ParameterSetName = 'Object')]
        [string]
        $Name,

        # The snapshot description
        [string]
        $Description,

        # Indicates that metadata should not be included
        [switch]
        $NoMetaData,

        # Indicates that the VM should be stopped
        [switch]
        $StopVm,

        # Indicates that only a storage snapshot is created
        [switch]
        $DiskOnly,

        # Indicates something
        [switch]
        $ReuseExternal,

        # Indicates something
        [switch]
        $Atomic,

        # Indicates that snapshot is taken from a running system
        [switch]
        $Live
    )

    process
    {
        if (-not $Computer)
        {
            $Computer = foreach ($vmName in $VmName)
            {
                Get-PLVVm -ComputerName $vmName
            }
        }

        foreach ($machine in $Computer)
        {
            if (-not $PSCmdlet.ShouldProcess($machine.Name, (Get-PSFLocalizedString -Module PoshLibVirt -Name Verbose.Checkpoint)))
            {
                continue
            }

            $cmdLine = @(
                'snapshot-create-as'
                "--domain $($machine.Uuid)"
                "--name $Name"
                if (-not [string]::IsNullOrWhiteSpace($Description)) { "--description `"$Description`"" }
                if ($NoMetaData.IsPresent()) { '--no-metadata' }
                if ($StopVm.IsPresent()) { '--halt' }
                if ($DiskOnly.IsPresent()) { '--disk-only' }
                if ($ReuseExternal.IsPresent()) { '--reuse-external' }
                if ($Atomic.IsPresent()) { '--atomic' }
                if ($Live.IsPresent()) { '--live' }
            )

            Start-Process -Wait -FilePath virsh -ArgumentList $cmdLine
        }
    }
}


<#
.SYNOPSIS
    Clears the content of a storage volume
.DESCRIPTION
    Clears the content of a storage volume
.EXAMPLE
    No implemented yet
#>
function Clear-PLVStorageVolumeContent
{
    [CmdletBinding()]
    param
    (

    )

    throw [System.NotImplementedException]::new('Uh oh...')
}


<#
.SYNOPSIS
    Not implemented yet
.DESCRIPTION
    Not implemented yet
.PARAMETER WhatIf
    Indicates that action should be simulated
.PARAMETER Confirm
    Indicates that a confirmation is requested
.EXAMPLE
    No implemented yet
#>
function Copy-PLVStorageVolume
{
    [CmdletBinding()]
    param
    (

    )

    throw [System.NotImplementedException]::new('Uh oh...')
}


<#
.SYNOPSIS
    List the network bridge configuration
.DESCRIPTION
    List the network bridge configuration
.EXAMPLE
    Get-PLVNetworkBridge

    List all bridges
.PARAMETER WhatIf
    Indicates that action should be simulated
.PARAMETER Confirm
    Indicates that a confirmation is requested
#>
function Get-PLVNetworkBridge
{
    [OutputType([PoshLibVirt.NetworkBridge[]])]
    [CmdletBinding()]
    param
    (
        # Name of the bridge. Supports wilcards
        [string]
        $Name = '*'
    )

    [PoshLibVirt.NetworkBridge[]] (ip -j link show type bridge | ConvertFrom-Json | Where-Object ifname -like $Name)
}


<#
.SYNOPSIS
    List storage pools
.DESCRIPTION
    List storage pools
.PARAMETER WhatIf
    Indicates that action should be simulated
.PARAMETER Confirm
    Indicates that a confirmation is requested
.EXAMPLE
    Get-PLVStoragePool -Name PoolNoodle

    View details of the storage pool PoolNoodle
#>
function Get-PLVStoragePool
{

    [OutputType([PoshLibVirt.StoragePool])]
    [CmdletBinding()]
    param
    (
        # Name of the storage pool. Supports wildcards
        [string[]]
        $Name = '*'
    )

    foreach ($pool in (virsh pool-list --all --name))
    {
        if ([string]::IsNullOrWhiteSpace($pool)) { continue }
        $pool = $pool.Trim()
        foreach ($poolName in $Name)
        {
            if ($pool -notlike $poolName) { continue }

            [xml] $poolInfo = virsh pool-dumpxml $pool
            $poolObject = [PoshLibVirt.StoragePool]::new()
            $poolObject.Type = $poolInfo.pool.type
            $poolObject.Capacity = $poolInfo.pool.capacity.InnerText
            $poolObject.AvailableBytes = $poolInfo.pool.available.InnerText
            $poolObject.AllocatedBytes = $poolInfo.pool.allocation.InnerText
            $poolObject.TargetPath = $poolInfo.pool.target.path
            $poolObject.Name = $poolInfo.pool.name
            $poolObject.Uuid = $poolInfo.pool.uuid
            $poolObject
        }
    }
}


<#
.SYNOPSIS
    Get information about storage volumes
.DESCRIPTION
    Get information about storage volumes in a storage pool
.PARAMETER WhatIf
    Indicates that action should be simulated
.PARAMETER Confirm
    Indicates that a confirmation is requested
.EXAMPLE
    Get-PLVStoragePool *Noodle* | Get-PLVStorageVolume

    List all volumes in all pools with a name like Noodle
#>
function Get-PLVStorageVolume
{
    [OutputType([PoshLibVirt.StorageVolume])]
    [CmdletBinding(DefaultParameterSetName = 'Pool')]
    param
    (
        # Name of the storage pool
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName='PoolName')]
        [string]
        $PoolName,

        # Piped storage pool object
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName='Pool')]
        [PoshLibVirt.StoragePool]
        $Pool,

        # Name of the volume. Supports wildcards
        [string[]]
        $Name = '*'
    )

    process
    {
        if ($Pool) {$PoolName = $Pool.Name}

        if (-not (Get-PLVStoragePool -Name $PoolName))
        {
            Write-PSFMessage -String Error.PoolNotFound -StringValues $PoolName
            return
        }

        foreach ($vol in  (virsh vol-list --pool $PoolName | Select-Object -Skip 2)) # Why the flying F is this so counterintuitive?
        {
            if ([string]::IsNullOrWhiteSpace($vol)) { continue }
            $volName, $volPath = ($vol.Trim() -split '\s+').Trim()

            foreach ($volume in $Name)
            {
                if ($volName -notlike $volume) { continue }
                [xml] $volXml = virsh vol-dumpxml --pool $PoolName $volName

                $volObject = [PoshLibVirt.StorageVolume]::new()
                $volObject.Name = $volXml.volume.name
                $volObject.Key = $volXml.volume.key
                $volObject.Capacity = $volXml.volume.capacity.InnerText
                $volObject.AllocatedBytes = $volXml.volume.allocation.InnerText
                $volObject.PhysicalBytes = $volXml.volume.physical.InnerText
                $volObject.Pool = Get-PLVStoragePool -Name $PoolName
                $volObject.Path = $volXml.volume.target.path
                $volObject
            }
        }
    }
}

<#
.SYNOPSIS
    List virtual network information
.DESCRIPTION
    List virtual network information
.PARAMETER WhatIf
    Indicates that action should be simulated
.PARAMETER Confirm
    Indicates that a confirmation is requested
.EXAMPLE
    Get-PLVVirtualNetwork

    List all virtual networks
#>
function Get-PLVVirtualNetwork
{
    [OutputType([PoshLibVirt.NetworkConfiguration])]
    [CmdletBinding()]
    param
    (
        # Network name, supports wildcards
        [string[]]
        $Name = '*'
    )

    foreach ($network in (virsh net-list --all --name))
    {
        if ([string]::IsNullOrWhiteSpace($network)) { continue }
        $network = $network.Trim()
        foreach ($networkName in $Name)
        {
            if ($network -notlike $networkName) { continue }

            [xml] $networkInfo = virsh net-dumpxml $network
            $networkObject = [PoshLibVirt.NetworkConfiguration]::new()
            $networkObject.Name = $networkInfo.network.name
            $networkObject.Uuid = $networkInfo.network.uuid
            $networkObject.BridgeName = $networkInfo.network.bridge.Name
            foreach ($address in $networkInfo.network.ip)
            {
                $networkObject.IpAddresses.Add([PoshLibVirt.IpEntry]@{
                    IpAddress = $address.address
                    NetworkMask = $address.netmask
                })
            }
            $networkObject
        }
    }
}


<#
.SYNOPSIS
    List all VMs
.DESCRIPTION
    List all VMs
.PARAMETER WhatIf
    Indicates that action should be simulated
.PARAMETER Confirm
    Indicates that a confirmation is requested
.EXAMPLE
    Get-PLVVm -All

    List all VMs. Can also use Get-PLVVm without any parameters
#>
function Get-PLVVm
{
    [OutputType([PoshLibVirt.VirtualMachine])]
    [CmdletBinding(DefaultParameterSetName = 'List')]
    param
    (
        # VM names to retrieve, supports Wildcards
        [Parameter(ParameterSetName = 'List')]
        [string[]]
        $VmName = '*',

        # Indicates that all VMs should be retrieved
        [Parameter(ParameterSetName = 'All')]
        [switch]
        $All
    )

    [string[]] $allVm = virsh list --name --all | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Foreach-Object { $_.Trim() }
    [string[]] $runningVm = virsh list --name | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Foreach-Object { $_.Trim() }
    foreach ($name in $VmName)
    {
        $vm = if ($All.IsPresent) { $allVm } else { $allVm | Where-Object { $_ -like $name } }
        $vmObject = [PoshLibVirt.VirtualMachine]::new()

        if (-not $vm)
        {
            Write-PSFMessage -String Error.VmNotFound -StringValues $name
            continue
        }

        [xml] $vmInfo = virsh dumpxml $vm 2>$null
        $vmObject.Name = $vmInfo.domain.name
        $vmObject.PowerState = if ($runningVm -contains $vm) { 'Running' } else { 'Stopped' }
        $vmObject.Title = $vmInfo.domain.title
        $vmObject.Uuid = $vmInfo.domain.uuid
        $vmObject.Memory = [long]$vmInfo.domain.memory.InnerText * 1kb
        $vmObject.CurrentMemory = [long]$vmInfo.domain.currentMemory.InnerText * 1kb

        $vmObject.Storage = foreach ($disk in ($vmInfo.SelectNodes('/domain/devices/disk').Where( { $_.device -eq 'disk' })))
        {
            Get-PLVStoragePool | Get-PLVStorageVolume | Where-Object { $_.Path -eq $disk.source.file }
        }

        $vmObject.Network = foreach ($nic in ($vmInfo.SelectNodes('/domain/devices/interface')))
        {
            [PoshLibVirt.NetworkConfiguration]::new()
        }

        $vmObject
    }
}

<#
.SYNOPSIS
    List all snapshots of a VM
.DESCRIPTION
    List all snapshots of a VM
.PARAMETER WhatIf
    Indicates that action should be simulated
.PARAMETER Confirm
    Indicates that a confirmation is requested
.EXAMPLE
    Get-PLVVm | Get-PLVVmSnapshot -Name BeforeDestruction

    List all snapshots called BeforeDestruction of all VMs
#>
function Get-PLVVmSnapshot
{
    [OutputType([PoshLibVirt.Snapshot])]
    [CmdletBinding(DefaultParameterSetName='Computer')]
    param
    (
        # Name of the VM, supports wildcards
        [Parameter(Mandatory, ParameterSetName = 'Name', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $VmName,

        # Piped VM object
        [Parameter(Mandatory, ParameterSetName = 'Object', ValueFromPipeline)]
        [PoshLibVirt.VirtualMachine[]]
        $Computer,

        # Snapshot name
        [Parameter(ParameterSetName = 'Name')]
        [Parameter(ParameterSetName = 'Object')]
        [string]
        $Name = '*'
    )

    process
    {
        if (-not $Computer)
        {
            $Computer = foreach ($vmName in $VmName)
            {
                Get-PLVVm -ComputerName $vmName
            }
        }

        foreach ($machine in $Computer)
        {
            [string[]]$snappies = virsh snapshot-list --name --domain $machine.Name 2>$null | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object { $_.Trim() }
            foreach ($snap in ($snappies -like $Name))
            {
                [xml] $snapXml = virsh snapshot-dumpxml --domain $machine.Name $snap
                [PoshLibVirt.Snapshot]::new(
                    $snapXml.domainsnapshot.name,
                    $snapXml.domainsnapshot.description,
                    $snapXml.domainsnapshot.state,
                    $snapXml.domainsnapshot.creationTime
                )
            }
        }
    }
}


function New-PLVBootConfiguration
{
    [OutputType([PoshLibVirt.BootConfiguration])]
    [CmdletBinding(DefaultParameterSetName='NoKernel')]
    param
    (
        [Parameter(ParameterSetName = 'NoKernel')]
        [Parameter(ParameterSetName = 'Kernel')]
        [string[]]
        $BootDevices,

        [Parameter(Mandatory, ParameterSetName = 'Kernel')]
        [string]
        $Kernel,

        [Parameter(ParameterSetName = 'Kernel')]
        [string]
        $KernelArguments,

        [Parameter(Mandatory, ParameterSetName = 'Kernel')]
        [string]
        $InitialRamDisk,

        [Parameter(ParameterSetName = 'NoKernel')]
        [Parameter(ParameterSetName = 'Kernel')]
        [bool]
        $BiosMenuEnabled
    )

    $classParameters = Clear-PSBoundParameters -ParameterDictionary $PSBoundParameters
    [PoshLibVirt.BootConfiguration]$classParameters
}


function New-PLVCpuConfiguration
{
    [OutputType([PoshLibVirt.CpuConfiguration])]
    [CmdletBinding(DefaultParameterSetName = 'Model')]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'Model')]
        [string]
        $Model,

        [Parameter(ParameterSetName = 'Model')]
        [string[]]
        $EnabledFeature,

        [Parameter( ParameterSetName = 'Model')]
        [string[]]
        $DisabledFeature,

        [Parameter(Mandatory, ParameterSetName = 'Host')]
        [switch]
        $IsHostCpu
    )

    $classParameters = Clear-PSBoundParameters -ParameterDictionary $PSBoundParameters
    [PoshLibVirt.CpuConfiguration]$classParameters
}


function New-PLVDiskConfiguration
{
    [OutputType([PoshLibVirt.DiskConfiguration])]
    [CmdletBinding()]
    param
    (
        [string]
        $Path,

        [string]
        $StoragePoolName,

        [string]
        $Volume,

        [ValidateSet('cdrom', 'disk', 'floppy')]
        [string]
        $Device,

        [uint64]
        $Size,

        [ValidateSet('rw', 'ro', 'sh')]
        [string]
        $Permission,

        [bool]
        $Sparse = $true,

        [ValidateSet('none', 'writethrough', 'writeback')]
        [string]
        $CacheMode = 'writethrough',

        [ValidateSet('raw', 'bochs', 'cloop', 'cow', 'dmg', 'iso', 'qcow', 'qcow2', 'qed', 'vmdk', 'vpc')]
        [string]
        $Format
    )

    $classParameters = Clear-PSBoundParameters -ParameterDictionary $PSBoundParameters
    [PoshLibVirt.DiskConfiguration]$classParameters
}


<#
.SYNOPSIS
    Create new network bridge
.DESCRIPTION
    Create new network bridge
.PARAMETER WhatIf
    Indicates that action should be simulated
.PARAMETER Confirm
    Indicates that a confirmation is requested
.EXAMPLE
    New-PLVNetworkBridge -Name br01 -IpAddress 192.168.2.0/24 -AdapterName eth0,eth1

    Bridge eth0 and eth1 to a bridge device br01
#>
function New-PLVNetworkBridge
{
    [CmdletBinding()]
    param
    (
        # Name of new bridge
        [Parameter(Mandatory)]
        [string]
        $Name,

        # IP address and mask combination, e.g. 192.168.2.123/24
        [string]
        $IpAddress,

        # List of adapters to add to bridge
        [string[]]
        $AdapterName,

        # Indicates that the bridge should use STP
        [switch]
        $UseSpanningTreeProtocol
    )

    if (Get-PLVNetworkBridge -Name $Name)
    {
        Write-PSFMessage -String Error.BridgeExists -StringValues $Name
        return
    }

    $null = ip link add name $Name type bridge
    $null = ip link set $Name up

    $connections = bridge -j link | ConvertFrom-Json | Where-Object master -eq $Name
    foreach ($adapter in $AdapterName)
    {
        if ($connections | Where-Object -Property ifname -eq $adapter)
        {
            Write-PSFMessage -String Warning.BridgeConnectionExists -StringValues $Name, $adapter
            continue
        }

        $null = ip link set $adapter up
        $null = ip link set $adapter master $Name
    }

    foreach ($connection in $connections)
    {
        if ($UseSpanningTreeProtocol.IsPresent)
        {
            $null = bridge link set $connection.ifname state 3
        }
        elseif ($connections.state -ne 'disabled')
        {
            $null = bridge link set $connection.ifname state 0
        }
    }

    if ($IpAddress)
    {
        $null = ip address add dev $Name $IpAddress
    }
}


<#
.EXAMPLE
New-PLVNetworkConfiguration -Name eth0 -BridgeName virbr0 -IpAddress @(@{IpAddress = '1.2.3.4'; NetworkMask = '255.255.255.0'})
#>
function New-PLVNetworkConfiguration
{
    [OutputType([PoshLibVirt.NetworkConfiguration])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $Name,

        [Uint16]
        $MtuSizeByte,

        [string]
        $BridgeName,

        [PoshLibVirt.NetworkForwarding]
        $ForwardingConfiguration,

        [PoshLibVirt.IpEntry[]]
        $IpAddresses,

        [PoshLibVirt.NetworkServiceQuality]
        $InboundQoS,

        [PoshLibVirt.NetworkServiceQuality]
        $OutboundQoS
    )

    <#
    public string Name { get; set; }
        public Guid Uuid { get; set; }
        public UInt16? MtuSizeByte { get; set; }
        public string BridgeName { get; set; }
        public NetworkForwarding ForwardingConfiguration { get; set; }
        public List<IpEntry> IpAddresses { get; set; }
        public DnsServer Dns { get; set; }
        public NetworkServiceQuality InboundQoS { get; set; }
        public NetworkServiceQuality OutboundQoS { get; set; }
    #>
    $classParameters = Clear-PSBoundParameters -ParameterDictionary $PSBoundParameters
    [PoshLibVirt.NetworkConfiguration]$classParameters
}

function New-PLVStoragePool
{
    param
    (
        [PoshLibVirt.PoolType] $Type,
        [string] $Name,
        [Guid] $Uuid,
        [ulong] $Capacity,
        [ulong] $AllocatedBytes,
        [ulong] $AvailableBytes,
        [string] $TargetPath,
        [switch] $AutoStart
    )


    $classParameters = Clear-PSBoundParameters -ParameterDictionary $PSBoundParameters
    [PoshLibVirt.StoragePool]$classParameters
}

function New-PLVStorageVolume
{
    [CmdletBinding()]
    param
    (

    )

    throw [System.NotImplementedException]::new('Uh oh...')
}


function New-PLVVirtualNetwork
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [PoshLibVirt.NetworkConfiguration[]]
        $Network
    )

    process
    {
        foreach ($networkConfig in $Network)
        {
            if (Get-PLVVirtualNetwork -Name $networkConfig.Name)
            {
                Write-PSFMessage -String 'Error.NetworkExists' -StringValues $networkConfig.Name -Level Warning
                continue
            }

            $xml = New-TemporaryFile
            $networkConfig.ToXml().Save($xml.FullName)
            $creation = Start-Process -Wait -PassThru -FilePath virsh -ArgumentList "net-create $($xml.FullName)"

            if ($creation.ExitCode -ne 0)
            {
                Write-PSFMessage -String 'Error.NetworkCreationFailed' -StringValues $networkConfig.Name, $creation.ExitCode
            }

            $xml | Remove-Item
        }
    }
}


function New-PLVVm
{
    [CmdletBinding(SupportsShouldProcess)]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $VmName,

        [string]
        $Description,

        [Parameter(Mandatory)]
        [uint64]
        $Memory,

        [Parameter(Mandatory)]
        [uint16]
        $CpuCount,

        [uint16]
        $MaxCpuCount,

        [uint16]
        $Sockets,

        [uint16]
        $Cores,

        [uint16]
        $Threads,

        [PoshLibVirt.CpuConfiguration]
        $Cpu,

        [uint16[]]
        $CpuSet,

        [PoshLibVirt.DiskConfiguration[]]
        $StorageConfiguration,

        [string]
        $OsType,

        [string]
        $OsVariant,

        [PoshLibVirt.BootConfiguration]
        $BootConfiguration,

        [string]
        $CdRom,

        [string]
        $InstallationSource,

        [switch]
        $PxeBoot,

        [switch]
        $Import,

        [switch]
        $LiveCd,

        [PoshLibVirt.NetworkAdapter[]]
        $NetworkAdapter,

        [Parameter(ParameterSetName = 'fv')]
        [switch]
        $FullVirtualization,

        [Parameter(ParameterSetName = 'pv')]
        [switch]
        $ParaVirtualization,

        [Parameter(ParameterSetName = 'container')]
        [switch]
        $Container,

        [string]
        $HypervisorType,

        [switch]
        $NoApic,

        [switch]
        $NoAcpi
    )

    $commandLine = @(
        "--name=$VmName"
        if (-not [string]::IsNullOrWhiteSpace($Description)) { "--description=`"$Description`"" }
        "--ram=$($Memory/1MB)"
        if ($CpuSet.Count -gt 0) { "--cpuset=$($CpuSet -join ',')" }
        if (-not [string]::IsNullOrWhiteSpace($CdRom)) { "--cdrom==$CdRom" }
        if (-not [string]::IsNullOrWhiteSpace($InstallationSource)) { "--location=$InstallationSource" }
        if ($PxeBoot.IsPresent) { "--pxe" }
        if ($Import.IsPresent) { "--import" }
        if ($NoApic.IsPresent) { "--noapic" }
        if ($NoAcpi.IsPresent) { "--noacpi" }
        if ($LiveCd.IsPresent) { "--livecd" }
        if ($FullVirtualization.IsPresent) { "--hvm" }
        if ($ParaVirtualization.IsPresent) { "--paravirt" }
        if ($Container.IsPresent) { "--container" }
        if (-not [string]::IsNullOrWhiteSpace($OsType)) { "--os-type=$OsType" }
        if (-not [string]::IsNullOrWhiteSpace($OsVariant)) { "--os-variant=$OsVariant" }
        if (-not [string]::IsNullOrWhiteSpace($HypervisorType)) { "--virt-type=$HypervisorType" }
    )

    $cpuString = "--vcpus=$CpuCount"
    if ($MaxCpuCount -gt 0) { $cpuString += ",maxvcpus=$MaxCpuCount" }
    if ($Sockets -gt 0) { $cpuString += ",sockets=$Sockets" }
    if ($Cores -gt 0) { $cpuString += ",cores=$Cores" }
    if ($Threads -gt 0) { $cpuString += ",threads=$Threads" }
    $commandLine += $cpuString

    foreach ($disk in $StorageConfiguration)
    {
        $commandLine += $disk.ToString()
    }

    if ($StorageConfiguration.Count -eq 0)
    {
        $commandLine += '--nodisks'
    }

    if ($null -ne $Cpu)
    {
        $commandLine += $Cpu.ToString()
    }

    foreach ($nic in $NetworkAdapter)
    {
        if ($nic.NetworkName -and -not (Get-PLVVirtualNetwork -Name $nic.NetworkName))
        {
            Write-PSFMessage -String 'Error.VmNetworkNotFound'  -StringValues $nic.NetworkName -Level Error
            return
        }

        if ($nic.BridgeName -and -not (Get-PLVNetworkBridge -Name $nic.BridgeName))
        {
            Write-PSFMessage -String 'Error.VmBridgeNotFound'  -StringValues $nic.BridgeName -Level Error
            return
        }
        $commandLine += $nic.ToString()
    }

    if ($NetworkAdapter.Count -eq 0)
    {
        $commandLine += '--nonetworks'
    }

    if ($BootConfiguration)
    {
        # Do things
    }

    if (-not $PSCmdlet.ShouldProcess($VmName, (Get-PSFLocalizedString -Module PoshLibVirt -Name Verbose.CreateVm)))
    {
        Write-PSFMessage -Message "virt-install $($commandLine -join ' ')"
    }

    $installProcess = Start-Process -FilePath 'virt-install' -ArgumentList $commandLine -Wait -PassThru
    if ($installProcess.ExitCode -ne 0)
    {
        Write-PSFMessage -String Error.VMDeploymentFailed -StringValues $VmName
    }
}


<#
.SYNOPSIS
    Not implemented yet
.DESCRIPTION
    Not implemented yet
.PARAMETER WhatIf
    Indicates that action should be simulated
.PARAMETER Confirm
    Indicates that a confirmation is requested
#>
function Read-PLVStorageVolumeContent
{
    [CmdletBinding()]
    param
    (

    )

    throw [System.NotImplementedException]::new('Uh oh...')
}


function Remove-PLVNetworkBridge
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string[]]
        [Alias('ifname')]
        $Name
    )

    process
    {
        foreach ($bridge in $Name)
        {
            if (-not (Get-PLVNetworkBridge -Name $bridge)) { continue }

            $connections = bridge -j link | ConvertFrom-Json | Where-Object master -eq $bridge
            foreach ($connection in $connections)
            {
                $null = ip link set $connection.ifname nomaster
            }

            ip link delete $bridge type bridge
        }
    }
}


function Remove-PLVStoragePool
{
    [CmdletBinding()]
    param
    (

    )

    throw [System.NotImplementedException]::new('Uh oh...')
}


function Remove-PLVStorageVolume
{
    [CmdletBinding()]
    param
    (

    )

    throw [System.NotImplementedException]::new('Uh oh...')
}


function Remove-PLVVirtualNetwork
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $Name
    )

    process
    {
        foreach ($net in $Name)
        {
            if (-not (Get-PLVVirtualNetwork -Name $net)) { continue }
            
            $destruction = Start-Process -FilePath virsh -ArgumentList "net-destroy $net" -Wait -PassThru

            if ($destruction.ExitCode -ne 0)
            {
                Write-PSFMessage -String Error.NetworkDestructionFailed -StringValues $net, $destruction.ExitCode
            }
        }
    }
}


function Remove-PLVVm
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'Name', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $VmName,

        [Parameter(Mandatory, ParameterSetName = 'Object', ValueFromPipeline)]
        [PoshLibVirt.VirtualMachine[]]
        $Computer,

        # --remove-all-storage - Indicate that all associated storage volumes are removed
        [switch]
        $Storage,

        [switch]
        $WipeStorage,

        [switch]
        $RemoveStorageVolumeSnapshot
    )

    process
    {
        if (-not $Computer)
        {
            $Computer = foreach ($name in $VmName)
            {
                Get-PLVVm -ComputerName $name
            }
        }

        foreach ($machine in $Computer)
        {
            if (-not $PSCmdlet.ShouldProcess($machine.Name, (Get-PSFLocalizedString -Module PoshLibVirt -Name Verbose.UndefineVm)))
            {
                continue
            }

            if ($machine.PowerState -eq 'Running') { Stop-PLVVm -ComputerName $machine -Force }
            $cmdLine = @(
                'undefine'
                "--domain $($machine.Uuid)"
                if ($RemoveStorageVolumeSnapshot.IsPresent) { 'delete-storage-volume-snapshots' }
                if ($Storage.IsPresent) { '--remove-all-storage' }
                if ($WipeStorage.IsPresent) { '--wipe-storage' }
            )

            Start-Process -FilePath virsh -ArgumentList $cmdLine -Wait
        }
    }
}

function Remove-PLVVmSnapshot
{
    [CmdletBinding(DefaultParameterSetName='ObjectCurrent', SupportsShouldProcess)]
    param
    (
        # Name of the VM, supports wildcards
        [Parameter(Mandatory, ParameterSetName = 'Name', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'NameCurrent', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $VmName,

        # Piped VM object
        [Parameter(Mandatory, ParameterSetName = 'Object', ValueFromPipeline)]
        [Parameter(Mandatory, ParameterSetName = 'ObjectCurrent', ValueFromPipeline)]
        [PoshLibVirt.VirtualMachine[]]
        $Computer,

        # Snapshot name
        [Parameter(ParameterSetName = 'Name')]
        [Parameter(ParameterSetName = 'Object')]
        [string]
        $Name = '*',

        [Parameter(ParameterSetName = 'NameCurrent')]
        [Parameter(ParameterSetName = 'ObjectCurrent')]
        [switch]
        $Current
    )

    process
    {
        if (-not $Computer)
        {
            $Computer = foreach ($vmName in $VmName)
            {
                Get-PLVVm -ComputerName $vmName
            }
        }

        foreach ($machine in $Computer)
        {
            [string[]]$snappies = virsh snapshot-list --name --domain $machine.Name 2>$null | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object { $_.Trim() }
            foreach ($snap in ($snappies -like $Name))
            {
                if (-not $PSCmdlet.ShouldProcess($machine.Name, (Get-PSFLocalizedString -Module PoshLibVirt -Name Verbose.Remove)))
                {
                    continue
                }
    
                $cmdLine = @(
                    'snapshot-delete'
                    "--domain $($machine.Name)"
                    if ($Name) { "--snapshotname $Name" }
                    if ($Current.IsPresent) { '--current' }
                )
    
                Start-Process -FilePath virsh -ArgumentList $cmdLine -Wait
            }
        }
    }
}

function Resize-PLVStorageVolume
{
    [CmdletBinding()]
    param
    (

    )

    throw [System.NotImplementedException]::new('Uh oh...')
}


function Restart-PLVVm
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'Name', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $VmName,

        [Parameter(Mandatory, ParameterSetName = 'Object', ValueFromPipeline)]
        [PoshLibVirt.VirtualMachine[]]
        $Computer,

        # Indicates reset instead of reboot.
        [switch]
        $Force
    )

    process
    {
        if (-not $Computer)
        {
            $Computer = foreach ($name in $VmName)
            {
                Get-PLVVm -ComputerName $name
            }
        }

        foreach ($machine in $Computer)
        {
            if (-not $PSCmdlet.ShouldProcess($machine.Name,(Get-PSFLocalizedString -Module PoshLibVirt -Name Verbose.RebootVm)))
            {
                continue
            }

            if ($Force.IsPresent)
            {
                virsh reset $machine.Uuid
                continue
            }

            virsh reboot $machine.Uuid
        }
    }
}

function Restore-PLVVmSnapshot
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'NameName', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'NameStart', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'NameSuspend', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'NameCurrent', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $VmName,

        [Parameter(Mandatory, ParameterSetName = 'ObjectName', ValueFromPipeline)]
        [Parameter(Mandatory, ParameterSetName = 'ObjectStart', ValueFromPipeline)]
        [Parameter(Mandatory, ParameterSetName = 'ObjectSuspend', ValueFromPipeline)]
        [Parameter(Mandatory, ParameterSetName = 'ObjectCurrent', ValueFromPipeline)]
        [PoshLibVirt.VirtualMachine[]]
        $Computer,

        [Parameter(Mandatory, ParameterSetName = 'NameName')]
        [Parameter(Mandatory, ParameterSetName = 'ObjectName')]
        [Parameter(Mandatory, ParameterSetName = 'NameStart')]
        [Parameter(Mandatory, ParameterSetName = 'ObjectStart')]
        [Parameter(Mandatory, ParameterSetName = 'NameSuspend')]
        [Parameter(Mandatory, ParameterSetName = 'ObjectSuspend')]
        [string]
        $Name,

        [Parameter(Mandatory, ParameterSetName = 'NameCurrent')]
        [Parameter(Mandatory, ParameterSetName = 'ObjectCurrent')]
        [switch]
        $Current,

        [Parameter(ParameterSetName = 'NameSuspend')]
        [Parameter(ParameterSetName = 'ObjectSuspend')]
        [switch]
        $Suspend,

        [Parameter(ParameterSetName = 'NameStart')]
        [Parameter(ParameterSetName = 'ObjectStart')]
        [switch]
        $Start,

        [Parameter(ParameterSetName = 'NameName')]
        [Parameter(ParameterSetName = 'ObjectName')]
        [Parameter(ParameterSetName = 'NameStart')]
        [Parameter(ParameterSetName = 'ObjectStart')]
        [Parameter(ParameterSetName = 'NameSuspend')]
        [Parameter(ParameterSetName = 'ObjectSuspend')]
        [Parameter(ParameterSetName = 'NameCurrent')]
        [Parameter(ParameterSetName = 'ObjectCurrent')]
        [switch]
        $Force
    )

    process
    {
        if (-not $Computer)
        {
            $Computer = foreach ($vmName in $VmName)
            {
                Get-PLVVm -ComputerName $vmName
            }
        }

        foreach ($machine in $Computer)
        {
            if (-not $PSCmdlet.ShouldProcess($machine.Name, (Get-PSFLocalizedString -Module PoshLibVirt -Name Verbose.Restore)))
            {
                continue
            }

            $cmdLine = @(
                'snapshot-revert'
                "--domain $($machine.Name)"
                if ($Name) { "--snapshotname $Name" }
                if ($Current.IsPresent) { '--current' }
                if ($Start.IsPresent) { '--running' }
                if ($Suspend.IsPresent) { '--paused' }
                if ($FOrce.IsPresent) { '--force' }
            )

            Start-Process -FilePath virsh -ArgumentList $cmdLine -Wait
        }
    }
}


function Set-PLVStoragePool
{
    [CmdletBinding()]
    param
    (

    )

    throw [System.NotImplementedException]::new('Uh oh...')
}


function Set-PLVVm
{
    [CmdletBinding()]
    param
    (

    )

    throw [System.NotImplementedException]::new('Uh oh...')
}


function Start-PLVStoragePool
{
    [CmdletBinding()]
    param
    (

    )

    throw [System.NotImplementedException]::new('Uh oh...')
}


function Start-PLVVirtualNetwork
{
    [CmdletBinding()]
    param
    (

    )

    throw [System.NotImplementedException]::new('Uh oh...')
}


function Start-PLVVm
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'Name', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $VmName,

        [Parameter(Mandatory, ParameterSetName = 'Object', ValueFromPipeline)]
        [PoshLibVirt.VirtualMachine[]]
        $Computer
    )

    process
    {
        if (-not $Computer)
        {
            $Computer = foreach ($name in $VmName)
            {
                Get-PLVVm -ComputerName $name
            }
        }

        foreach ($machine in $Computer.Where( { $_.PowerState -ne 'Running' }))
        {
            if (-not $PSCmdlet.ShouldProcess($machine.Name, (Get-PSFLocalizedString -Module PoshLibVirt -Name Verbose.StartVm)))
            {
                continue
            }

            virsh start $machine.Uuid
        }
    }
}


function Stop-PLVStoragePool
{
    [CmdletBinding()]
    param
    (

    )

    throw [System.NotImplementedException]::new('Uh oh...')
}


function Stop-PLVVirtualNetwork
{
    [CmdletBinding()]
    param
    (

    )

    throw [System.NotImplementedException]::new('Uh oh...')
}


function Stop-PLVVm
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'Name', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $VmName,

        [Parameter(Mandatory, ParameterSetName = 'Object', ValueFromPipeline)]
        [PoshLibVirt.VirtualMachine[]]
        $Computer,

        # Indicates hard shutdown instead of graceful shutdown.
        [switch]
        $Force
    )

    process
    {
        if (-not $Computer)
        {
            $Computer = foreach ($name in $VmName)
            {
                Get-PLVVm -ComputerName $name
            }
        }

        foreach ($machine in $Computer.Where( { $_.PowerState -eq 'Running' }))
        {
            if (-not $PSCmdlet.ShouldProcess($machine.Name, (Get-PSFLocalizedString -Module PoshLibVirt -Name Verbose.StopVm)))
            {
                continue
            }

            if ($Force.IsPresent)
            {
                virsh destroy $machine.Uuid
                continue
            }

            virsh shutdown $machine.Uuid
        }
    }
}

function Suspend-PLVVm
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'Name', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $VmName,

        [Parameter(Mandatory, ParameterSetName = 'Object', ValueFromPipeline)]
        [PoshLibVirt.VirtualMachine[]]
        $Computer
    )

    process
    {
        if (-not $Computer)
        {
            $Computer = foreach ($name in $VmName)
            {
                Get-PLVVm -ComputerName $name
            }
        }

        foreach ($machine in $Computer.Where( { $_.PowerState -eq 'Running' }))
        {
            if (-not $PSCmdlet.ShouldProcess($machine.Name, (Get-PSFLocalizedString -Module PoshLibVirt -Name Verbose.SaveVm)))
            {
                continue
            }

            virsh suspend $machine.Uuid
        }
    }
}


<#
.SYNOPSIS
    Not implemented yet
.DESCRIPTION
    Not implemented yet
.PARAMETER WhatIf
    Indicates that action should be simulated
.PARAMETER Confirm
    Indicates that a confirmation is requested
#>
function Write-PLVStorageVolumeContent
{
    [CmdletBinding()]
    param
    (

    )

    throw [System.NotImplementedException]::new('Uh oh...')
}


<#
This is an example configuration file

By default, it is enough to have a single one of them,
however if you have enough configuration settings to justify having multiple copies of it,
feel totally free to split them into multiple files.
#>

<#
# Example Configuration
Set-PSFConfig -Module 'PoshLibVirt' -Name 'Example.Setting' -Value 10 -Initialize -Validation 'integer' -Handler { } -Description "Example configuration setting. Your module can then use the setting using 'Get-PSFConfigValue'"
#>

Set-PSFConfig -Module 'PoshLibVirt' -Name 'Import.DoDotSource' -Value $false -Initialize -Validation 'bool' -Description "Whether the module files should be dotsourced on import. By default, the files of this module are read as string value and invoked, which is faster but worse on debugging."
Set-PSFConfig -Module 'PoshLibVirt' -Name 'Import.IndividualFiles' -Value $false -Initialize -Validation 'bool' -Description "Whether the module files should be imported individually. During the module build, all module code is compiled into few files, which are imported instead by default. Loading the compiled versions is faster, using the individual files is easier for debugging and testing out adjustments."

<#
Stored scriptblocks are available in [PsfValidateScript()] attributes.
This makes it easier to centrally provide the same scriptblock multiple times,
without having to maintain it in separate locations.

It also prevents lengthy validation scriptblocks from making your parameter block
hard to read.

Set-PSFScriptblock -Name 'PoshLibVirt.ScriptBlockName' -Scriptblock {
	
}
#>

Register-PSFTeppScriptblock -Name PoshLibVirt.OsVariant -ScriptBlock {
    osinfo-query os --fields=short-id | Select-Object -Skip 1 | % { $_.Trim() }
}

Register-PSFTeppScriptblock -Name PoshLibVirt.OsType -ScriptBlock {
    'linux', 'windows'
}

Register-PSFTeppScriptblock -Name PoshLibVirt.HyperVisorType -ScriptBlock {
    $caps = [xml](virsh capabilities)
    $caps.capabilities.guest.Where( { $_.arch.wordsize -eq 64 }).arch.domain.type
}

Register-PSFTeppScriptblock -Name PoshLibVirt.CpuModel -ScriptBlock {
    virsh cpu-models x86_64 | % { $_.Trim() }
}

Register-PSFTeppScriptblock -Name PoshLibVirt.AdapterName -ScriptBlock {
    nmcli -g DEVICE device status | % { $_.Trim() }
}

Register-PSFTeppScriptblock -Name PoshLibVirt.BridgeName -ScriptBlock {
    (bridge -j link show | ConvertFrom-Json).master
}

Register-PSFTeppScriptblock -Name PoshLibVirt.Vm -ScriptBlock {
    (Get-PLVVm -All).Name
}

Register-PSFTeppArgumentCompleter -Command New-PLVVm -Parameter OsType -Name PoshLibVirt.OsType
Register-PSFTeppArgumentCompleter -Command New-PLVVm -Parameter OsVariant -Name PoshLibVirt.OsVariant
Register-PSFTeppArgumentCompleter -Command New-PLVVm -Parameter HypervisorType -Name PoshLibVirt.HyperVisorType
Register-PSFTeppArgumentCompleter -Command New-PLVCpuConfiguration -Parameter Model -Name PoshLibVirt.CpuModel
Register-PSFTeppArgumentCompleter -Command New-PLVNetworkBridge -Parameter AdapterName -Name PoshLibVirt.AdapterName
Register-PSFTeppArgumentCompleter -Command New-PLVNetworkBridge,Get-PLVNetworkBridge,Remove-PLVNetworkBridge -Parameter Name -Name PoshLibVirt.BridgeName
Register-PSFTeppArgumentCompleter -Command Start-PLVVm, Stop-PLVVm, Suspend-PLVVm, Restart-PLVVm,Checkpoint-PLVVm,Remove-PLVVm, Restore-PLVVmSnapshot, Get-PLVVmSnapshot -Parameter ComputerName -Name PoshLibVirt.Vm

New-PSFLicense -Product 'PoshLibVirt' -Manufacturer 'jhp' -ProductVersion $script:ModuleVersion -ProductType Module -Name MIT -Version "1.0.0.0" -Date (Get-Date "2020-10-20") -Text @"
Copyright (c) 2020 jhp

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"@
#endregion Load compiled code