using System;
using System.Collections.Generic;

namespace PoshLibVirt
{
    public class VirtualMachine
    {
        public string Name { get; set; }
        public string Title { get; set; }
        public List<StorageVolume> Storage { get; set; }
        public List<NetworkConfiguration> Network { get; set; }
        public Guid Uuid { get; set; }
        public ulong Memory { get; set; }
        public ulong CurrentMemory { get; set; }
        public CpuConfiguration CpuConfiguration { get; set; }
        public VirtualMachineState PowerState { get; set; }
    }
}
