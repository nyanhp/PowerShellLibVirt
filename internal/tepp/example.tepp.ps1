<#
# Example:
Register-PSFTeppScriptblock -Name "LibVirt.alcohol" -ScriptBlock { 'Beer','Mead','Whiskey','Wine','Vodka','Rum (3y)', 'Rum (5y)', 'Rum (7y)' }
#>
Register-PSFTeppScriptblock -Name LibVirt.OsVariant -ScriptBlock {
    osinfo-query os --fields=short-id | Select-Object -Skip 1
}

Register-PSFTeppScriptblock -Name LibVirt.OsType -ScriptBlock {
    'linux','windows'
}

Register-PSFTeppScriptblock -Name LibVirt.HyperVisorType -ScriptBlock {
    $caps = [xml](virsh capabilities)
    $caps.capabilities.guest.Where({$_.arch.wordsize -eq 64}).arch.domain.type
}