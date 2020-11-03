using System.Collections.Generic;

namespace PoshLibVirt
{
    public class NetworkForwarding
    {
        public string Device { get; set; }
        public ForwardingMode Mode { get; set; }
        public NatConfiguration NatConfiguration { get; set; }
        public List<string> Interfaces { get; set; }

        public NetworkForwarding()
        {
            Interfaces = new List<string>();
        }
    }
}