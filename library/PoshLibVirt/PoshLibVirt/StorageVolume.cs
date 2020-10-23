namespace PoshLibVirt
{
    public class StorageVolume
    {
        public string Name { get; set; }
        public string Key { get; set; }
        public ulong Capacity { get; set; }
        public ulong AllocatedBytes { get; set; }
        public ulong PhysicalBytes { get; set; }
        public string Path { get; set; }
        public StoragePool Pool { get; set; }

        public override string ToString()
        {
            return Name;
        }
    }
}