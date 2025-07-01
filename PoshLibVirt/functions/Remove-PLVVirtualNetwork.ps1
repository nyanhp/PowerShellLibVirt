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
            
            sudo virsh net-destroy $net

            if ($LASTEXITCODE -ne 0)
            {
                Write-PSFMessage -String Error.NetworkDestructionFailed -StringValues $net, $destruction.ExitCode
            }
        }
    }
}
