using System.Net;
using System.Collections.Generic;

namespace PoshLibVirt
{
    public class HostRecord
    {
        public IPAddress Address { get; set; }
        public List<string> HostNames { get; set; }
    }
}