---
external help file: PoshLibVirt-help.xml
Module Name: PoshLibVirt
online version:
schema: 2.0.0
---

# Get-StorageVolume

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### Pool (Default)
```
Get-StorageVolume -Pool <StoragePool> [-Name <String[]>] [<CommonParameters>]
```

### PoolName
```
Get-StorageVolume -PoolName <String> [-Name <String[]>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -PoolName
{{ Fill PoolName Description }}

```yaml
Type: String
Parameter Sets: PoolName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Pool
{{ Fill Pool Description }}

```yaml
Type: StoragePool
Parameter Sets: Pool
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Name
{{ Fill Name Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
### PoshLibVirt.StoragePool
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
