namespace PoshLibVirt
{
    public class NetworkServiceQuality
    {
        public Direction Direction { get; set; }
        public uint? AverageKilobytes { get; set; }
        public uint? PeakKilobytes { get; set; }
        public uint? BurstKilobytes { get; set; }
        public uint? FloorKilobytes { get; set; }
    }
}