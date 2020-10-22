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
