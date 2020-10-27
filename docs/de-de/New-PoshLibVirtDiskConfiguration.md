---
external help file: PoshLibVirt-help.xml
Module Name: PoshLibVirt
online version:
schema: 2.0.0
---

# New-PoshLibVirtDiskConfiguration

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

```
New-PoshLibVirtDiskConfiguration [[-Path] <String>] [[-StoragePoolName] <String>] [[-Volume] <String>]
 [[-Device] <String>] [[-Size] <UInt64>] [[-Permission] <String>] [[-Sparse] <Boolean>] [[-CacheMode] <String>]
 [[-Format] <String>] [<CommonParameters>]
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

### -CacheMode
{{ Fill CacheMode Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: none, writethrough, writeback

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Device
{{ Fill Device Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: cdrom, disk, floppy

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Format
{{ Fill Format Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: raw, bochs, cloop, cow, dmg, iso, qcow, qcow2, qed, vmdk, vpc

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
{{ Fill Path Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Permission
{{ Fill Permission Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: rw, ro, sh

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Size
{{ Fill Size Description }}

```yaml
Type: UInt64
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Sparse
{{ Fill Sparse Description }}

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StoragePoolName
{{ Fill StoragePoolName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Volume
{{ Fill Volume Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
