class PoshLibVirtNetworkConfiguration
{
    [string] $Name
    [string] $Bridge
    [string] $Model
    [string] $MacAddress = 'RANDOM'

    [xml] ToXml()
    {
        'New','Remove','Start','Stop','Get' | %{New-Item -Path "./functions/$_-VirtualNetwork.ps1"}
        'New','Remove','Get' | %{New-Item -Path "./functions/$_-NetworkBridge.ps1"}
        <#
        <network ipv6='yes' trustGuestRxFilters='no'>
  <name>default</name>
  <uuid>3e3fce45-4f53-4fa7-bb32-11f34168b82b</uuid>
  <metadata>
    <app1:foo xmlns:app1="http://app1.org/app1/">..</app1:foo>
    <app2:bar xmlns:app2="http://app1.org/app2/">..</app2:bar>
  </metadata>
<bridge name="virbr0" stp="on" delay="5" macTableManager="libvirt"/>
<mtu size="9000"/>
<domain name="example.com" localOnly="no"/>
<forward mode="nat" dev="eth0"/>
  <forward mode='nat'>
    <nat>
      <address start='1.2.3.4' end='1.2.3.10'/>
    </nat>
  </forward>
  <forward mode='nat'>
    <nat>
      <port start='500' end='1000'/>
    </nat>
  </forward>
  <forward mode='passthrough'>
    <interface dev='eth10'/>
    <interface dev='eth11'/>
    <interface dev='eth12'/>
    <interface dev='eth13'/>
    <interface dev='eth14'/>
  </forward>
        #>
        return ''
    }
}
