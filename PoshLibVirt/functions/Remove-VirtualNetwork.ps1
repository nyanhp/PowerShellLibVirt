function Remove-VirtualNetwork
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
            if (-not (Get-VirtualNetwork -Name $net)) { continue }
            
            $destruction = Start-Process -FilePath virsh -ArgumentList "net-destroy $net" -Wait -PassThru

            if ($destruction.ExitCode -ne 0)
            {
                Write-PSFMessage -String Error.NetworkDestructionFailed -StringValues $net, $destruction.ExitCode
            }
        }
    }
}
