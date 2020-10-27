<#
.SYNOPSIS
    Clear CommonParameters from Dictionary
.DESCRIPTION
    Clear CommonParameters from Dictionary
.PARAMETER ParameterDictionary
    The dictionary to clean up
.EXAMPLE
    Clear-PSBoundParameters -ParameterDictionary $PSBoundParameters

    Clears the PSBoundParameters dictionary
#>
function Clear-PSBoundParameters
{
    [CmdletBinding()]
    param
    (
        [hashtable]
        $ParameterDictionary
    )

    $newTable = $ParameterDictionary.Clone()
    'Verbose', 'Debug', 'InformationAction', 'ErrorAction', 'WarningAction', 'ErrorVariable', 'InformationVariable', 'OutVariable', 'PipelineVariable', 'OutBuffer' |
    ForEach-Object { $newTable.Remove($_) }

    $newTable
}
