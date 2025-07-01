function New-PLVVm {
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
        if (-not [string]::IsNullOrWhiteSpace($CdRom)) { "--cdrom=$CdRom" }
        if (-not [string]::IsNullOrWhiteSpace($InstallationSource)) { "--location=$InstallationSource" }
        if ($PxeBoot.IsPresent) { "--pxe" }
        if ($Import.IsPresent) { "--import" }
        if ($NoApic.IsPresent) { "--noapic" }
        if ($NoAcpi.IsPresent) { "--noacpi" }
        if ($LiveCd.IsPresent) { "--livecd" }
        if ($FullVirtualization.IsPresent) { "--hvm" }
        if ($ParaVirtualization.IsPresent) { "--paravirt" }
        if ($Container.IsPresent) { "--container" }
        if (-not [string]::IsNullOrWhiteSpace($OsVariant)) { "--os-variant=$OsVariant" }
        if (-not [string]::IsNullOrWhiteSpace($HypervisorType)) { "--virt-type=$HypervisorType" }
    )

    $cpuString = "--vcpus=$CpuCount"
    if ($MaxCpuCount -gt 0) { $cpuString += ",maxvcpus=$MaxCpuCount" }
    if ($Sockets -gt 0) { $cpuString += ",sockets=$Sockets" }
    if ($Cores -gt 0) { $cpuString += ",cores=$Cores" }
    if ($Threads -gt 0) { $cpuString += ",threads=$Threads" }
    $commandLine += $cpuString

    foreach ($disk in $StorageConfiguration) {
        $commandLine += $disk.GetCommandLine()
    }

    if ($StorageConfiguration.Count -eq 0) {
        $commandLine += '--nodisks'
    }

    if ($null -ne $Cpu) {
        $Cpu.GetCommandLine()
    }

    foreach ($nic in $NetworkAdapter) {
        if ($nic.NetworkName -and -not (Get-PLVVirtualNetwork -Name $nic.NetworkName)) {
            Write-PSFMessage -String 'Error.VmNetworkNotFound'  -StringValues $nic.NetworkName -Level Error
            return
        }

        if ($nic.BridgeName -and -not (Get-PLVNetworkBridge -Name $nic.BridgeName)) {
            Write-PSFMessage -String 'Error.VmBridgeNotFound'  -StringValues $nic.BridgeName -Level Error
            return
        }
        $commandLine += $nic.GetCommandLine()
    }

    if ($NetworkAdapter.Count -eq 0) {
        $commandLine += '--nonetworks'
    }

    if ($BootConfiguration) {
        # Do things
    }

    if (-not $PSCmdlet.ShouldProcess($VmName, (Get-PSFLocalizedString -Module PoshLibVirt -Name Verbose.CreateVm))) {
        Write-PSFMessage -Message "sudo virt-install $($commandLine -join ' ')"
        return
    }

    $null = sudo virt-install @commandLine
    if ($LASTEXITCODE -ne 0) {
        Write-PSFMessage -String Error.VMDeploymentFailed -StringValues $VmName
    }
}
