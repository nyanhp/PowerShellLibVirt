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

        public override string ToString()
        {
            var mac = MacAddress.PadRight(12, '0').ToLower()
                .Insert(2, ":")
                .Insert(5, ":")
                .Insert(8, ":")
                .Insert(11, ":")
                .Insert(14, ":");
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
                str += $" mac={mac}";
            }
            return str;
        }
    }
}