Register-PSFTeppArgumentCompleter -Command New-Vm -Parameter OsType -Name PoshLibVirt.OsType
Register-PSFTeppArgumentCompleter -Command New-Vm -Parameter OsVariant -Name PoshLibVirt.OsVariant
Register-PSFTeppArgumentCompleter -Command New-Vm -Parameter HypervisorType -Name PoshLibVirt.HyperVisorType
Register-PSFTeppArgumentCompleter -Command New-PoshLibVirtCpuConfiguration -Parameter Model -Name PoshLibVirt.CpuModel
Register-PSFTeppArgumentCompleter -Command New-NetworkBridge -Parameter AdapterName -Name PoshLibVirt.AdapterName
Register-PSFTeppArgumentCompleter -Command New-NetworkBridge,Get-NetworkBridge,Remove-NetworkBridge -Parameter Name -Name PoshLibVirt.BridgeName