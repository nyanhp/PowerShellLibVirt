# This is where the strings go, that are written by
# Write-PSFMessage, Stop-PSFFunction or the PSFramework validation scriptblocks
@{
	'Error.BridgeExists'             = 'Bridge {0} existiert bereits.'
	'Error.NetworkExists'            = 'Netzwerk {0} existiert bereits.'
	'Error.PoolNotFound'             = 'Storage Pool {0} konnte nicht gefunden werden.'
	'Error.VmNotFound'               = 'VM {0} konnte nicht gefunden werden.'
	'Error.VMDeploymentFailed'       = 'Installation von {0} ist fehlgeschlagen.'
	'Error.VmNetworkNotFound'        = 'VM Netzwerk {0} onnte nicht gefunden werden.'
	'Error.VmBridgeNotFound'         = 'VM Netzwerk-Bridge {0} onnte nicht gefunden werden.'
	'Error.NetworkCreationFailed'    = 'Fehler bei der Erstellung von Netzwerk {0}. virsh Rückgabewert {1}'

	'Warning.BridgeConnectionExists' = 'Bridge {0} Adapter {1} ist bereits verbunden.'

	'Verbose.Checkpoint'             = 'Erstelle VM-Snapshot'
	'Verbose.CreateVm'               = 'Erstelle VM'
	'Verbose.UndefineVm'             = 'Entferne VM'
	'Verbose.RebootVm'               = 'Starte VM neu'
	'Verbose.RestoreCheckpoint'      = 'Wiederhersttellung VM-Snapshot'
	'Verbose.StartVm'                = 'Starte VM'
	'Verbose.StopVm'                 = 'Stoppe VM'
	'Verbose.SaveVm'                 = 'Sichere (Pausiere) VM'
}