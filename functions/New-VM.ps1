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
        $MaxCpu,

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
        $Disk,

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

        [switch]
        $FullVirtualization,

        [switch]
        $ParaVirtualization,

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
}