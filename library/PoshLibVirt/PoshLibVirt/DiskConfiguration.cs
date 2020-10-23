using System;

namespace PoshLibVirt
{
    public class DiskConfiguration
    {
        public string Path { get; set; }
        public string StoragePoolName { get; set; }
        public string Volume { get; set; }
        public Device Device { get; set; }
        public ulong? Size { get; set; }
        public Permission Permission { get; set; }
        public bool Sparse { get; set; }
        public CacheMode CacheMode { get; set; }
        public Format Format { get; set; }

        public DiskConfiguration ()
        {
            Sparse = true;
            CacheMode = CacheMode.writethrough;
        }

        public override string ToString()
        {
            var str = "--disk ";
            str += $"perms={Permission.ToString()},";
            str += $"device={Device},";
            str += $"cache={CacheMode},";
            str += $"format={Format},";

            if (!string.IsNullOrWhiteSpace(Path)) { str += $"path={Path},"; }
            if (!string.IsNullOrWhiteSpace(StoragePoolName)) { str += $"pool={StoragePoolName},"; }
            if (!string.IsNullOrWhiteSpace(Volume)) { str += $"vol={Volume},"; }
            if (null != Size) { str += $"size={Size / (1024 * 1024 * 1024)},"; }
            if (Sparse) { str += $"sparse={Sparse.ToString().ToLower()},"; }

            return str.Substring(0, str.Length - 1);
        }
    }
}
