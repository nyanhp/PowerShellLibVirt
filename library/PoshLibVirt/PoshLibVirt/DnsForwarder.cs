using System.Net;

namespace PoshLibVirt
{
    public class DnsForwarder
    {
        public IPAddress Address { get; set; }
        public string Domain { get; set; }
    }
}