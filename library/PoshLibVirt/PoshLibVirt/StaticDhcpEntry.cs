using System.Net;

namespace PoshLibVirt
{
    public class StaticDhcpEntry
    {
        public string MacAddress { get; set; }
        public string Name { get; set; }
        public IPAddress IpAddress { get; set; }
    }
}