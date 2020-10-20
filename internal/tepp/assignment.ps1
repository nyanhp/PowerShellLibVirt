<#
# Example:
Register-PSFTeppArgumentCompleter -Command Get-Alcohol -Parameter Type -Name LibVirt.alcohol
#>
Register-PSFTeppArgumentCompleter -Command New-Vm -Parameter OsType -Name LibVirt.OsType
Register-PSFTeppArgumentCompleter -Command New-Vm -Parameter OsVariant -Name LibVirt.OsVariant
Register-PSFTeppArgumentCompleter -Command New-Vm -Parameter HypervisorType -Name LibVirt.HyperVisorType