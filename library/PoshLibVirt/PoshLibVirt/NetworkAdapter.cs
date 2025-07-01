using System;
using System.Text.RegularExpressions;
using System.Collections.Generic;

namespace PoshLibVirt
{
    public class NetworkAdapter
    {
        private string macAddress;

        public string Name { get; set; }
        public string NetworkName { get; set; }
        public string BridgeName { get; set; }

        public string MacAddress { get => macAddress; set => macAddress = Regex.Replace(value, @"[\.\-\:]", string.Empty); }

        public System.Collections.Generic.List<string> GetCommandLine()
        {
            var cmdLine = new System.Collections.Generic.List<string> { "--network" };
            if (!string.IsNullOrWhiteSpace(NetworkName))
            {
                cmdLine.Add($"network={NetworkName}");
            }
            if (!string.IsNullOrWhiteSpace(BridgeName))
            {
                cmdLine.Add($"bridge={BridgeName}");
            }
            if (!string.IsNullOrWhiteSpace(MacAddress))
            {
                var mac = MacAddress.PadRight(12, '0').ToLower()
                    .Insert(2, ":")
                    .Insert(5, ":")
                    .Insert(8, ":")
                    .Insert(11, ":")
                    .Insert(14, ":");
                cmdLine.Add($"mac={mac}");
            }
            return cmdLine;
        }

        public override string ToString()
        {
            var str = "--network";
            if (!string.IsNullOrWhiteSpace(NetworkName))
            {
                str += $" network={NetworkName}";
            }
            if (!string.IsNullOrWhiteSpace(BridgeName))
            {
                str += $" bridge={BridgeName}";
            }
            if (!string.IsNullOrWhiteSpace(MacAddress))
            {
            var mac = MacAddress.PadRight(12, '0').ToLower()
                .Insert(2, ":")
                .Insert(5, ":")
                .Insert(8, ":")
                .Insert(11, ":")
                .Insert(14, ":");
                str += $" mac={mac}";
            }
            return str;
        }
    }
}