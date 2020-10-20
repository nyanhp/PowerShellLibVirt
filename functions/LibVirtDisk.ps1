class LibVirtDisk
{
    [string] $Path
    [string] $StoragePoolName
    [string] $Volume
    [ValidateSet('cdrom','disk','floppy')] [string] $Device
    [uint16] $SizeGb
    [ValidateSet('rw','ro','sh')] [string] $Permission
    [bool] $Sparse = $true
    [ValidateSet('none','writethrough','writeback')] [string] $CacheMode = 'writethrough'
    [ValidateSet('raw','bochs','cloop','cow','dmg','iso','qcow','qcow2','qed','vmdk','vpc')] [string] $Format
}
