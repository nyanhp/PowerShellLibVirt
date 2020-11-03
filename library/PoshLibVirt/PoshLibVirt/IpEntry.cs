using System.Net;

namespace PoshLibVirt
{
    public class IpEntry
    {
        public IPAddress IpAddress { get; set; }
        public IPAddress NetworkMask { get; set; }
        public Dhcp DhcpConfiguration { get; set; }
    }
}