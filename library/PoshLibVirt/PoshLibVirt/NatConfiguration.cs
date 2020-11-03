using System;
using System.Net;

namespace PoshLibVirt
{
    public class NatConfiguration
    {
        public IPAddress StartAddress { get; set; }
        public IPAddress EndAddress { get; set; }
        public UInt16? StartPort { get; set; }
        public UInt16? EndPort { get; set; }
        public bool IsIpv6 { get; set; }

        public NatConfiguration ()
        {
            IsIpv6 = false;
        }
    }
}