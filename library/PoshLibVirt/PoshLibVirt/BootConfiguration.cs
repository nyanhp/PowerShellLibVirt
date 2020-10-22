using System;
using System.Collections.Generic;

namespace PoshLibVirt
{
    public class BootConfiguration
    {
        public List<string> BootDevices { get; set; }
        public string Kernel { get; set; }
        public string KernelArguments { get; set; }
        public string InitialRamDisk { get; set; }
        public bool BiosMenuEnabled { get; set; }

        public BootConfiguration()
        {
            BootDevices = new List<string>();
        }

        public override string ToString()
        {
            var str = string.Join(',', BootDevices);
            if (!string.IsNullOrWhiteSpace(Kernel)) { str += $",kernel=${Kernel}"; }
            if (!string.IsNullOrWhiteSpace(InitialRamDisk)) { str += $",initrd=${InitialRamDisk}"; }
            if (!string.IsNullOrWhiteSpace(KernelArguments)) { str += $",kernel_args=\"${KernelArguments}\""; }
            if (BiosMenuEnabled) { str += ",menu=on"; }
            if (str.StartsWith(',')) { str.Remove(0, 1); }

            return str;
        }
    }
}