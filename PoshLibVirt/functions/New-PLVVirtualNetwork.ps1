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
