using System.Collections.Generic;

namespace PoshLibVirt
{
    public class DnsServer
    {
        public List<DnsForwarder> Forwarders { get; set; }
        public List<TxtRecord> TxtRecords { get; set; }
        public List<HostRecord> HostRecords { get; set; }
        public List<SrvRecord> SrvRecords { get; set; }
    }
}