class PoshLibVirtBootConfiguration
{
    [string[]] $BootDevices
    [string] $Kernel
    [string] $KernelArguments
    [string] $InitialRamDisk
    [bool] $BiosMenuEnabled = $false

    [string] ToString()
    {
        $str = $this.BootDevices -join ','
        if (-not [string]::IsNullOrWhiteSpace($this.Kernel)) { $str += ",kernel=$($this.Kernel)" }
        if (-not [string]::IsNullOrWhiteSpace($this.InitialRamDisk)) { $str += ",initrd=$($this.InitialRamDisk)" }
        if (-not [string]::IsNullOrWhiteSpace($this.KernelArguments)) { $str += ",kernel_args=`"$($this.KernelArguments)`"" }
        if ($this.BiosMenuEnabled) { $str += ",menu=on" }
        if ($str.StartsWith(',')) { $str.Remove(0, 1) }

        return $str
    }
}
