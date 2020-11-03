using System;
using System.Net;
using System.Collections.Generic;
using System.Xml;

namespace PoshLibVirt
{
    public class NetworkConfiguration
    {
        public string Name { get; set; }
        public Guid Uuid { get; set; }
        public UInt16? MtuSizeByte { get; set; }
        public string BridgeName { get; set; }
        public NetworkForwarding ForwardingConfiguration { get; set; }
        public List<IpEntry> IpAddresses { get; set; }
        public DnsServer Dns { get; set; }
        public NetworkServiceQuality InboundQoS { get; set; }
        public NetworkServiceQuality OutboundQoS { get; set; }

        public NetworkConfiguration()
        {
            IpAddresses = new List<IpEntry>();
        }

        public XmlDocument ToXml()
        {
            var xmlNetwork = new XmlDocument();
            var rootNode = xmlNetwork.CreateElement("network");
            var nameNode = xmlNetwork.CreateElement("name");
            nameNode.InnerText = Name;
            rootNode.AppendChild(nameNode);
            if (null != Uuid)
            {
                var uidNode = xmlNetwork.CreateElement("uuid");
                uidNode.InnerText = Uuid.ToString();
                rootNode.AppendChild(uidNode);
            }

            if (null != MtuSizeByte)
            {
                var mtuNode = xmlNetwork.CreateElement("mtu");
                var mtuAttr = xmlNetwork.CreateAttribute("size");
                mtuAttr.Value = MtuSizeByte.ToString();
                mtuNode.Attributes.Append(mtuAttr);
                rootNode.AppendChild(mtuNode);
            }

            if (!string.IsNullOrWhiteSpace(BridgeName))
            {
                var brNode = xmlNetwork.CreateElement("bridge");
                var brNameAttr = xmlNetwork.CreateAttribute("name");
                brNameAttr.Value = BridgeName;
                brNode.Attributes.Append(brNameAttr);
                rootNode.AppendChild(brNode);
            }

            if (null != ForwardingConfiguration)
            {
                var fwNode = xmlNetwork.CreateElement("forward");
                var fwModeAttr = xmlNetwork.CreateAttribute("mode");
                fwModeAttr.Value = BridgeName;
                fwNode.Attributes.Append(fwModeAttr);
                var fwDevAttr = xmlNetwork.CreateAttribute("dev");
                fwDevAttr.Value = ForwardingConfiguration.Device;
                fwNode.Attributes.Append(fwDevAttr);

                if (null != ForwardingConfiguration.NatConfiguration)
                {
                    var natNode = xmlNetwork.CreateElement("nat");

                    if (ForwardingConfiguration.NatConfiguration.IsIpv6)
                    {
                        var ipv6Attr = xmlNetwork.CreateAttribute("ipv6");
                        ipv6Attr.Value = "yes";
                        natNode.Attributes.Append(ipv6Attr);
                    }

                    if (null != ForwardingConfiguration.NatConfiguration.StartAddress && null != ForwardingConfiguration.NatConfiguration.EndAddress)
                    {
                        var natAdNode = xmlNetwork.CreateElement("address");
                        var natStartAdAttr = xmlNetwork.CreateAttribute("start");
                        natStartAdAttr.Value = ForwardingConfiguration.NatConfiguration.StartAddress.ToString();
                        natAdNode.Attributes.Append(natStartAdAttr);
                        var natEndAttr = xmlNetwork.CreateAttribute("end");
                        natEndAttr.Value = ForwardingConfiguration.NatConfiguration.EndAddress.ToString();
                        natAdNode.Attributes.Append(natEndAttr);
                        natNode.AppendChild(natAdNode);
                    }

                    if (null != ForwardingConfiguration.NatConfiguration.StartPort && null != ForwardingConfiguration.NatConfiguration.EndPort)
                    {
                        var natAdNode = xmlNetwork.CreateElement("port");
                        var natStartAdAttr = xmlNetwork.CreateAttribute("start");
                        natStartAdAttr.Value = ForwardingConfiguration.NatConfiguration.StartPort.ToString();
                        natAdNode.Attributes.Append(natStartAdAttr);
                        var natEndAttr = xmlNetwork.CreateAttribute("end");
                        natEndAttr.Value = ForwardingConfiguration.NatConfiguration.EndPort.ToString();
                        natAdNode.Attributes.Append(natEndAttr);
                        natNode.AppendChild(natAdNode);
                    }

                    fwNode.AppendChild(natNode);
                }

                foreach (var ifName in ForwardingConfiguration.Interfaces)
                {
                    var ifNode = xmlNetwork.CreateElement("interface");
                    var ifAttr = xmlNetwork.CreateAttribute("dev");
                    ifAttr.Value = ifName;
                    ifNode.Attributes.Append(ifAttr);

                    fwNode.AppendChild(ifNode);
                }

                rootNode.AppendChild(fwNode);
            }

            if (null != InboundQoS)
            {
                var qosNode = xmlNetwork.SelectSingleNode("/network/bandwidth");

                if (null == qosNode)
                {
                    qosNode = xmlNetwork.CreateElement("bandwidth");
                }

                if (InboundQoS.AverageKilobytes.HasValue)
                {
                    var qAttr = xmlNetwork.CreateAttribute("average");
                    qAttr.Value = InboundQoS.AverageKilobytes.Value.ToString();
                    qosNode.Attributes.Append(qAttr);
                }

                if (InboundQoS.FloorKilobytes.HasValue)
                {
                    var qAttr = xmlNetwork.CreateAttribute("floor");
                    qAttr.Value = InboundQoS.FloorKilobytes.Value.ToString();
                    qosNode.Attributes.Append(qAttr);
                }

                if (InboundQoS.BurstKilobytes.HasValue)
                {
                    var qAttr = xmlNetwork.CreateAttribute("burst");
                    qAttr.Value = InboundQoS.BurstKilobytes.Value.ToString();
                    qosNode.Attributes.Append(qAttr);
                }

                if (InboundQoS.PeakKilobytes.HasValue)
                {
                    var qAttr = xmlNetwork.CreateAttribute("peak");
                    qAttr.Value = InboundQoS.PeakKilobytes.Value.ToString();
                    qosNode.Attributes.Append(qAttr);
                }

                rootNode.AppendChild(qosNode);
            }
            {
                var fwNode = xmlNetwork.CreateElement("forward");
                var fwModeAttr = xmlNetwork.CreateAttribute("mode");
                fwModeAttr.Value = BridgeName;
                fwNode.Attributes.Append(fwModeAttr);
                var fwDevAttr = xmlNetwork.CreateAttribute("dev");
                fwDevAttr.Value = ForwardingConfiguration.Device;
                fwNode.Attributes.Append(fwDevAttr);

                if (null != ForwardingConfiguration.NatConfiguration)
                {
                    var natNode = xmlNetwork.CreateElement("nat");

                    if (ForwardingConfiguration.NatConfiguration.IsIpv6)
                    {
                        var ipv6Attr = xmlNetwork.CreateAttribute("ipv6");
                        ipv6Attr.Value = "yes";
                        natNode.Attributes.Append(ipv6Attr);
                    }

                    if (null != ForwardingConfiguration.NatConfiguration.StartAddress && null != ForwardingConfiguration.NatConfiguration.EndAddress)
                    {
                        var natAdNode = xmlNetwork.CreateElement("address");
                        var natStartAdAttr = xmlNetwork.CreateAttribute("start");
                        natStartAdAttr.Value = ForwardingConfiguration.NatConfiguration.StartAddress.ToString();
                        natAdNode.Attributes.Append(natStartAdAttr);
                        var natEndAttr = xmlNetwork.CreateAttribute("end");
                        natEndAttr.Value = ForwardingConfiguration.NatConfiguration.EndAddress.ToString();
                        natAdNode.Attributes.Append(natEndAttr);
                        natNode.AppendChild(natAdNode);
                    }

                    if (null != ForwardingConfiguration.NatConfiguration.StartPort && null != ForwardingConfiguration.NatConfiguration.EndPort)
                    {
                        var natAdNode = xmlNetwork.CreateElement("port");
                        var natStartAdAttr = xmlNetwork.CreateAttribute("start");
                        natStartAdAttr.Value = ForwardingConfiguration.NatConfiguration.StartPort.ToString();
                        natAdNode.Attributes.Append(natStartAdAttr);
                        var natEndAttr = xmlNetwork.CreateAttribute("end");
                        natEndAttr.Value = ForwardingConfiguration.NatConfiguration.EndPort.ToString();
                        natAdNode.Attributes.Append(natEndAttr);
                        natNode.AppendChild(natAdNode);
                    }

                    fwNode.AppendChild(natNode);
                }

                foreach (var ifName in ForwardingConfiguration.Interfaces)
                {
                    var ifNode = xmlNetwork.CreateElement("interface");
                    var ifAttr = xmlNetwork.CreateAttribute("dev");
                    ifAttr.Value = ifName;
                    ifNode.Attributes.Append(ifAttr);

                    fwNode.AppendChild(ifNode);
                }

                rootNode.AppendChild(fwNode);
            }

            if (null != OutboundQoS)
            {
                var qosNode = xmlNetwork.SelectSingleNode("/network/bandwidth");

                if (null == qosNode)
                {
                    qosNode = xmlNetwork.CreateElement("bandwidth");
                }

                if (OutboundQoS.AverageKilobytes.HasValue)
                {
                    var qAttr = xmlNetwork.CreateAttribute("average");
                    qAttr.Value = OutboundQoS.AverageKilobytes.Value.ToString();
                    qosNode.Attributes.Append(qAttr);
                }

                if (OutboundQoS.FloorKilobytes.HasValue)
                {
                    var qAttr = xmlNetwork.CreateAttribute("floor");
                    qAttr.Value = OutboundQoS.FloorKilobytes.Value.ToString();
                    qosNode.Attributes.Append(qAttr);
                }

                if (OutboundQoS.BurstKilobytes.HasValue)
                {
                    var qAttr = xmlNetwork.CreateAttribute("burst");
                    qAttr.Value = OutboundQoS.BurstKilobytes.Value.ToString();
                    qosNode.Attributes.Append(qAttr);
                }

                if (OutboundQoS.PeakKilobytes.HasValue)
                {
                    var qAttr = xmlNetwork.CreateAttribute("peak");
                    qAttr.Value = OutboundQoS.PeakKilobytes.Value.ToString();
                    qosNode.Attributes.Append(qAttr);
                }

                rootNode.AppendChild(qosNode);
            }

            foreach (var ip in IpAddresses)
            {
                var ipNode = xmlNetwork.CreateElement("ip");
                var addrAttr = xmlNetwork.CreateAttribute("address");
                addrAttr.Value = ip.IpAddress.ToString();
                ipNode.Attributes.Append(addrAttr);
                var maskAttr = xmlNetwork.CreateAttribute("netmask");
                maskAttr.Value = ip.NetworkMask.ToString();
                ipNode.Attributes.Append(maskAttr);

                if (null != ip.DhcpConfiguration)
                {
                    var dhcpNode = xmlNetwork.CreateElement("dhcp");
                    var rangeNode = xmlNetwork.CreateElement("range");
                    var rStartAttr = xmlNetwork.CreateAttribute("start");
                    var rEndAttr = xmlNetwork.CreateAttribute("end");
                    rStartAttr.Value = ip.DhcpConfiguration.RangeStart.ToString();
                    rEndAttr.Value = ip.DhcpConfiguration.RangeEnd.ToString();
                    rangeNode.Attributes.Append(rStartAttr);
                    rangeNode.Attributes.Append(rEndAttr);
                    dhcpNode.AppendChild(rangeNode);

                    foreach (var reservation in ip.DhcpConfiguration.StaticEntries)
                    {
                        var hostNode = xmlNetwork.CreateElement("host");
                        var macAttr = xmlNetwork.CreateAttribute("mac");
                        var nameAttr = xmlNetwork.CreateAttribute("name");
                        var hostIpAttr = xmlNetwork.CreateAttribute("ip");
                        macAttr.Value = reservation.MacAddress;
                        nameAttr.Value = reservation.Name;
                        hostIpAttr.Value = reservation.IpAddress.ToString();
                        hostNode.Attributes.Append(macAttr);
                        hostNode.Attributes.Append(nameAttr);
                        hostNode.Attributes.Append(hostIpAttr);
                        dhcpNode.AppendChild(hostNode);
                    }

                    ipNode.AppendChild(dhcpNode);
                }

                rootNode.AppendChild(ipNode);
            }

            if (null != Dns)
            {
                var dnsNode = xmlNetwork.CreateElement("dns");

                foreach (var svc in Dns.SrvRecords)
                {
                    var svcNode = xmlNetwork.CreateElement("srv");
                    var svcAttr = xmlNetwork.CreateAttribute("service");
                    var protoAttr = xmlNetwork.CreateAttribute("protocol");
                    var domainAttr = xmlNetwork.CreateAttribute("domain");
                    var targetAttr = xmlNetwork.CreateAttribute("target");
                    var prioAttr = xmlNetwork.CreateAttribute("priority");
                    var portAttr = xmlNetwork.CreateAttribute("port");
                    var weightAttr = xmlNetwork.CreateAttribute("weight");
                    svcAttr.Value = svc.ServiceName;
                    protoAttr.Value = svc.Protocol.ToString();
                    domainAttr.Value = svc.Domain;
                    targetAttr.Value = svc.Target;
                    prioAttr.Value = svc.Priority.ToString();
                    portAttr.Value = svc.Port.ToString();
                    weightAttr.Value = svc.Weight.ToString();
                    svcNode.Attributes.Append(svcAttr);
                    svcNode.Attributes.Append(protoAttr);
                    svcNode.Attributes.Append(domainAttr);
                    svcNode.Attributes.Append(targetAttr);
                    svcNode.Attributes.Append(prioAttr);
                    svcNode.Attributes.Append(portAttr);
                    svcNode.Attributes.Append(weightAttr);
                    dnsNode.AppendChild(svcNode);
                }

                foreach (var host in Dns.HostRecords)
                {
                    var hostNode = xmlNetwork.CreateElement("host");
                    var hostAddrAttr = xmlNetwork.CreateAttribute("ip");
                    hostAddrAttr.Value = host.Address.ToString();
                    hostNode.Attributes.Append(hostAddrAttr);

                    foreach (var hName in host.HostNames)
                    {
                        var hNameNode = xmlNetwork.CreateElement("hostname");
                        hNameNode.InnerText = hName;
                        hostNode.AppendChild(hNameNode);
                    }

                    dnsNode.AppendChild(hostNode);
                }

                foreach (var txt in Dns.TxtRecords)
                {
                    var txtNode = xmlNetwork.CreateElement("txt");
                    var txNameAttr = xmlNetwork.CreateAttribute("name");
                    txNameAttr.Value = txt.Name;
                    txtNode.Attributes.Append(txNameAttr);
                    var txValAttr = xmlNetwork.CreateAttribute("value");
                    txValAttr.Value = txt.Value;
                    txtNode.Attributes.Append(txValAttr);

                    dnsNode.AppendChild(txtNode);
                }

                foreach (var forwarder in Dns.Forwarders)
                {
                    var dnsFwNode = xmlNetwork.CreateElement("forwarder");

                    if (null != forwarder.Address)
                    {
                        var fwAdAttr = xmlNetwork.CreateAttribute("addr");
                        fwAdAttr.Value = forwarder.Address.ToString();
                        dnsFwNode.Attributes.Append(fwAdAttr);
                    }

                    if (!string.IsNullOrWhiteSpace(forwarder.Domain))
                    {
                        var fwDomAttr = xmlNetwork.CreateAttribute("domain");
                        fwDomAttr.Value = forwarder.Domain;
                        dnsFwNode.Attributes.Append(fwDomAttr);
                    }

                    dnsNode.AppendChild(dnsFwNode);
                }

                rootNode.AppendChild(dnsNode);
            }

            xmlNetwork.AppendChild(rootNode);
            return xmlNetwork;
        }
    }
}