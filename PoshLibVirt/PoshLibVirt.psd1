﻿@{
	# Script module or binary module file associated with this manifest
	RootModule           = 'PoshLibVirt.psm1'

	# Version number of this module.
	ModuleVersion        = '1.0.0'

	# ID used to uniquely identify this module
	GUID                 = '59a3dc31-a48e-4e87-8431-b057fddb1fb3'

	# Author of this module
	Author               = 'jhp'

	# Company or vendor of this module
	CompanyName          = 'Jan-Hendrik Peters'

	# Copyright statement for this module
	Copyright            = 'Copyright (c) 2020 jhp'

	# Description of the functionality provided by this module
	Description          = 'This module aims to provide access to libvirt on Linux. Requires libvirt-client, iproute2 binaries'

	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion    = '6.0'

	CompatiblePSEditions = 'Core'

	# Modules that must be imported into the global environment prior to importing
	# this module
	RequiredModules      = @(
		@{ ModuleName = 'PSFramework'; ModuleVersion = '1.4.150' }
	)

	# Assemblies that must be loaded prior to importing this module
	RequiredAssemblies   = @('bin\PoshLibVirt.dll')

	# Type files (.ps1xml) to be loaded when importing this module
	# TypesToProcess = @('xml\PoshLibVirt.Types.ps1xml')

	# Format files (.ps1xml) to be loaded when importing this module
	# FormatsToProcess = @('xml\PoshLibVirt.Format.ps1xml')

	# Functions to export from this module
	FunctionsToExport    = @(
		'Checkpoint-PLVVm',
		'Clear-PLVStorageVolumeContent',
		'Copy-PLVStorageVolume',
		'Get-PLVNetworkBridge',
		'Get-PLVStoragePool',
		'Get-PLVStorageVolume',
		'Get-PLVVirtualNetwork',
		'Get-PLVVm',
		'Get-PLVVmSnapshot',
		'New-PLVNetworkBridge',
		'New-PLVBootConfiguration',
		'New-PLVCpuConfiguration',
		'New-PLVDiskConfiguration',
		'New-PLVNetworkConfiguration',
		'New-PLVStoragePool',
		'New-PLVStorageVolume',
		'New-PLVVirtualNetwork',
		'New-PLVVm',
		'Read-PLVStorageVolumeContent',
		'Remove-PLVNetworkBridge',
		'Remove-PLVStoragePool',
		'Remove-PLVStorageVolume',
		'Remove-PLVVirtualNetwork',
		'Remove-PLVVm',
		'Remove-PLVVmSnapshot',
		'Resize-PLVStorageVolume',
		'Restart-PLVVm',
		'Restore-PLVVmSnapshot',
		'Set-PLVStoragePool',
		'Set-PLVVm',
		'Start-PLVStoragePool',
		'Start-PLVVirtualNetwork',
		'Start-PLVVm',
		'Stop-PLVStoragePool',
		'Stop-PLVVirtualNetwork',
		'Stop-PLVVm',
		'Suspend-PLVVm',
		'Write-PLVStorageVolumeContent'
	)

	# Cmdlets to export from this module
	CmdletsToExport      = ''

	# Variables to export from this module
	VariablesToExport    = ''

	# Aliases to export from this module
	AliasesToExport      = ''

	# List of all modules packaged with this module
	ModuleList           = @()

	# List of all files packaged with this module
	FileList             = @()

	# Private data to pass to the module specified in ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData          = @{

		#Support for PowerShellGet galleries.
		PSData = @{

			# Tags applied to this module. These help with module discovery in online galleries.
			Tags = @('linux', 'libvirt', 'virsh', 'kvm', 'qemu' )

			# A URL to the license for this module.
			# LicenseUri = ''

			# A URL to the main website for this project.
			# ProjectUri = ''

			# A URL to an icon representing this module.
			# IconUri = ''

			# ReleaseNotes of this module
			# ReleaseNotes = ''

		} # End of PSData hashtable

	} # End of PrivateData hashtable
}