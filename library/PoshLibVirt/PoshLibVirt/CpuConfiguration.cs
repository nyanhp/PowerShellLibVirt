using System;
using System.Collections.Generic;

namespace PoshLibVirt
{
    public class CpuConfiguration
    {
        public string Model { get; set; }
        public List<string> EnabledFeatures { get; set; }
        public List<string> DisabledFeatures { get; set; }
        public bool IsHostCpu { get; set; }

        public CpuConfiguration()
        {
            EnabledFeatures = new List<string>();
            DisabledFeatures = new List<string>();
        }

        public override string ToString()
        {
            if (IsHostCpu)
            {
                return "--cpu host";
            }

            var str = $"--cpu {Model}";

            foreach (var feature in EnabledFeatures)
            {
                str += $",+{feature}";
            }

            foreach (var feature in DisabledFeatures)
            {
                str += $",-{feature}";
            }

            return str;
        }
    }
}
