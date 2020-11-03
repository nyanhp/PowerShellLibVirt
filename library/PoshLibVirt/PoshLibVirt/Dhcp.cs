using System.Collections.Generic;
using System.Net;

namespace PoshLibVirt
{
    public class Dhcp
    {
        public IPAddress RangeStart { get; set; }
        public IPAddress RangeEnd { get; set; }
        public List<StaticDhcpEntry> StaticEntries { get; set; }
    }
}