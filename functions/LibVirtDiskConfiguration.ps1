class LibVirtDiskConfiguration
{
    [string] $Path
    [string] $StoragePoolName
    [string] $Volume
    [ValidateSet('cdrom','disk','floppy')] [string] $Device
    [uint64] $Size
    [ValidateSet('rw','ro','sh')] [string] $Permission
    [bool] $Sparse = $true
    [ValidateSet('none','writethrough','writeback')] [string] $CacheMode = 'writethrough'
    [ValidateSet('raw','bochs','cloop','cow','dmg','iso','qcow','qcow2','qed','vmdk','vpc')] [string] $Format

    [string] ToString()
    {
        $str = ''
        if ($this.Path) {$str = -join @($str,"path=$($this.Path),")}
        if ($this.StoragePoolName) {$str = -join @($str,"pool=$($this.StoragePoolName),")}
        if ($this.Volume) {$str = -join @($str,"vol=$($this.Volume),")}
        if ($this.Device) {$str = -join @($str,"device=$($this.Device),")}
        if ($this.Size) {$str = -join @($str,"size=$($this.Size / 1GB),")}
        if ($this.Permission) {$str = -join @($str,"perms=$($this.Permission),")}
        if ($this.Sparse) {$str = -join @($str,"sparse=$($this.Sparse.ToString().ToLower()),")}
        if ($this.CacheMode) {$str = -join @($str,"cache=$($this.CacheMode),")}
        if ($this.Format) {$str = -join @($str,"format=$($this.Format),")}
        return $str.Substring(0, $str.Length - 1)
    }
}
