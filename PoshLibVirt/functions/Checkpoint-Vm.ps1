function Checkpoint-Vm
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'Name', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $ComputerName,

        [Parameter(Mandatory, ParameterSetName = 'Object', ValueFromPipeline)]
        [PoshLibVirt.VirtualMachine[]]
        $Computer,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [Parameter(Mandatory, ParameterSetName = 'Object')]
        [string]
        $Name,

        [string]
        $Description,

        [switch]
        $NoMetaData,

        [switch]
        $StopVm,

        [switch]
        $DiskOnly,

        [switch]
        $ReuseExternal,

        [switch]
        $Atomic,

        [switch]
        $Live
    )

    process
    {
        if (-not $Computer)
        {
            $Computer = foreach ($vmName in $ComputerName)
            {
                Get-Vm -ComputerName $vmName
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
