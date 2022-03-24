<#
.EXAMPLE
New-PoshLibVirtNetworkConfiguration -Name eth0 -BridgeName virbr0 -IpAddress @(@{IpAddress = '1.2.3.4'; NetworkMask = '255.255.255.0'})
#>
function New-PoshLibVirtNetworkConfiguration
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