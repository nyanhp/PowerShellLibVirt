function New-Vm
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $ComputerName,

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

        [LibVirtCpuConfiguration]
        $Cpu,

        [uint16[]]
        $CpuSet,

        [LibVirtDiskConfiguration[]]
        $StorageConfiguration,

        [string]
        $OsType,

        [string]
        $OsVariant,

        [LibVirtBootConfiguration]
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

        [LibVirtNetwork[]]
        $NetworkConfiguration,

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

    # AL Windows: Floppy mounten unattend druff
    # AL WIM file? Apply??
    # AL Linux: dd /if /of? oder ISO + ks.cfg/autoyast

    $commandLine = @(
        "--name=$ComputerName"
        if (-not [string]::IsNullOrWhiteSpace($Description)) { "--description=$Description" }
        "--ram=$($Memory/1MB)"
        if ($CpuSet.Count -gt 0) {"--cpuset=$($CpuSet -join ',')"}
        if (-not [string]::IsNullOrWhiteSpace($CdRom)) {"--cdrom==$CdRom"}
        if (-not [string]::IsNullOrWhiteSpace($InstallationSource)) {"--location=$InstallationSource"}
        if ($PxeBoot.IsPresent) {"--pxe"}
        if ($Import.IsPresent) {"--import"}
        if ($NoApic.IsPresent) {"--noapic"}
        if ($NoAcpi.IsPresent) {"--noacpi"}
        if ($FullVirtualization.IsPresent) {"--hvm"}
        if ($ParaVirtualization.IsPresent) {"--paravirt"}
        if ($Container.IsPresent) {"--container"}
        if (-not [string]::IsNullOrWhiteSpace($OsType)) {"--os-type=$OsType"}
        if (-not [string]::IsNullOrWhiteSpace($OsVariant)) {"--os-variant=$OsVariant"}
    )

    $cpuString = "--vcpus=$CpuCount"
    if ($MaxCpuCount -gt 0) {$cpuString += ",maxvcpus=$MaxCpuCount"}
    if ($Sockets -gt 0) {$cpuString += ",sockets=$Sockets"}
    if ($Cores -gt 0) {$cpuString += ",cores=$Cores"}
    if ($Threads -gt 0) {$cpuString += ",threads=$Threads"}
    $commandLine += $cpuString

    foreach ($disk in $StorageConfiguration)
    {
        $commandLine += $disk.ToString()
    }

    if ($StorageConfiguration.Count -eq 0)
    {
        $commandLine += '--nodisks'
    }

    foreach ($nic in $NetworkConfiguration)
    {

    }

    if ($NetworkConfiguration.Count -eq 0)
    {
        $commandLine += '--nonetworks'
    }

    Start-Process -FilePath 'virt-install' -ArgumentList $commandLine -Wait
}