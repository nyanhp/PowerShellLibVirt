class PoshLibVirtCpuConfiguration
{
    [string] $Model
    [string[]] $EnabledFeatures
    [string[]] $DisabledFeatures
    [bool] $IsHostCpu = $false

    [string] ToString()
    {
        if ($this.IsHostCpu)
        {
            $str = "--cpu host"
        }
        else
        {
            $str = "--cpu $($this.Model)"
        }

        foreach ($feature in $this.EnabledFeatures)
        {
            $str = -join @($str, ",+$feature")
        }

        foreach ($feature in $this.DisabledFeatures)
        {
            $str = -join @($str, ",-$feature")
        }

        return $str
    }
}
