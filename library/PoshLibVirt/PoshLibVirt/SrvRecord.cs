using System.Net.Sockets;

namespace PoshLibVirt
{
    public class SrvRecord
    {
        public string ServiceName { get; set; }
        public ProtocolType Protocol { get; set; }
        public string Target { get; set; }
        public string Domain { get; set; }
        public int Port { get; set; }
        public int Weight { get; set; }
        public int Priority { get; set; }
    }
}