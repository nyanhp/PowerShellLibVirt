# This is where the strings go, that are written by
# Write-PSFMessage, Stop-PSFFunction or the PSFramework validation scriptblocks
@{
	'Error.BridgeExists'             = 'Bridge {0} exists.'
	'Error.NetworkExists'            = 'Network {0} exists.'
	'Error.PoolNotFound'             = 'Storage Pool {0} could not be found.'
	'Error.VmNotFound'               = 'VM {0} could not be found'
	'Error.VMDeploymentFailed'       = 'Deployment of {0} failed.'
	'Error.VmNetworkNotFound'        = 'VM network {0} not found.'
	'Error.VmBridgeNotFound'         = 'VM network bridge {0} not found.'
	'Error.NetworkCreationFailed'    = 'Error creation network {0}. virsh exit code {1}'
	'Error.NetworkDestructionFailed' = 'Destruction of network {0} failed. virsh exit code {1}'

	'Warning.BridgeConnectionExists' = 'Bridge {0} adapter {1} already connected'

	'Verbose.Checkpoint'             = 'Create VM snapshot'
	'Verbose.CreateVm'               = 'Create VM'
	'Verbose.UndefineVm'             = 'Undefine (remove) VM'
	'Verbose.RebootVm'               = 'Restarte VM'
	'Verbose.RestoreCheckpoint'      = 'Restore VM snapshot'
	'Verbose.StartVm'                = 'Start VM'
	'Verbose.StopVm'                 = 'Stop VM'
	'Verbose.SaveVm'                 = 'Save (Suspend) VM'
}