using System;
using System.IO;

namespace PoshLibVirt
{
    public class StoragePool
    {
        public PoolType Type {get; set;}
        public string Name {get;set;}
        public Guid Uuid {get; set;}

        public ulong Capacity {get; set;}

        public ulong AllocatedBytes {get; set;}
        public ulong AvailableBytes {get; set;}
        public string TargetPath {get; set;}

        public override string ToString()
        {
            return Name;
        }
    }
}