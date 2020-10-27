using System;

namespace PoshLibVirt
{
    public class Snapshot
    {
        public string Name { get; set; }
        public string Description { get; set; }
        public VirtualMachineState State { get; set; }
        public DateTime CreationTime { get; set; }
        private static readonly DateTime epoch = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc);

        public Snapshot()
        {

        }

        public Snapshot (string name, string description, VirtualMachineState state, ulong secondsSinceEpoch)
        {
            Name = name;
            Description = description;
            State = state;
            CreationTime = epoch.AddSeconds(secondsSinceEpoch);
        }
    }
}