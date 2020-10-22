function Remove-NetworkBridge
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
            if (-not (Get-NetworkBridge -Name $bridge)) { continue }

            $connections = bridge -j link | ConvertFrom-Json | Where-Object master -eq $bridge
            foreach ($connection in $connections)
            {
                $null = ip link set $connection.ifname nomaster
            }

            ip link delete $bridge type bridge
        }
    }
}
