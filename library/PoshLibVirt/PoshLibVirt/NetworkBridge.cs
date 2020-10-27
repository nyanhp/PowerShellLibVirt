using System.Collections.Generic;

namespace PoshLibVirt
{
    public class NetworkBridge
    {
        public ushort IfIndex { get; set; }
        public string IfName { get; set; }
        public List<string> Flags { get; set; }
        public ushort Mtu { get; set; }
        public string QDisc { get; set; }
        public ConnectionStatus OperState { get; set; }
        public LinkMode LinkMode { get; set; }
        public string Group { get; set; }
        public ushort TxqLen { get; set; }
        public LinkType Link_Type { get; set; }
        public string Address { get; set; }
        public string Broadcast { get; set; }
    }
}