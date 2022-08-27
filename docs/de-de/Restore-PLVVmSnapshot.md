---
external help file: PoshLibVirt-help.xml
Module Name: PoshLibVirt
online version:
schema: 2.0.0
---

# Restore-PLVVmSnapshot

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### NameCurrent
```
Restore-PLVVmSnapshot -PLVVmName <String[]> [-Current] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### NameSuspend
```
Restore-PLVVmSnapshot -PLVVmName <String[]> -Name <String> [-Suspend] [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### NameStart
```
Restore-PLVVmSnapshot -PLVVmName <String[]> -Name <String> [-Start] [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### NameName
```
Restore-PLVVmSnapshot -PLVVmName <String[]> -Name <String> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ObjectCurrent
```
Restore-PLVVmSnapshot -Computer <VirtualMachine[]> [-Current] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ObjectSuspend
```
Restore-PLVVmSnapshot -Computer <VirtualMachine[]> -Name <String> [-Suspend] [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### ObjectStart
```
Restore-PLVVmSnapshot -Computer <VirtualMachine[]> -Name <String> [-Start] [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### ObjectName
```
Restore-PLVVmSnapshot -Computer <VirtualMachine[]> -Name <String> [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
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

### -Computer
{{ Fill Computer Description }}

```yaml
Type: VirtualMachine[]
Parameter Sets: ObjectCurrent, ObjectSuspend, ObjectStart, ObjectName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Current
{{ Fill Current Description }}

```yaml
Type: SwitchParameter
Parameter Sets: NameCurrent, ObjectCurrent
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
{{ Fill Force Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
{{ Fill Name Description }}

```yaml
Type: String
Parameter Sets: NameSuspend, NameStart, NameName, ObjectSuspend, ObjectStart, ObjectName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Start
{{ Fill Start Description }}

```yaml
Type: SwitchParameter
Parameter Sets: NameStart, ObjectStart
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Suspend
{{ Fill Suspend Description }}

```yaml
Type: SwitchParameter
Parameter Sets: NameSuspend, ObjectSuspend
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PLVVmName
{{ Fill VmName Description }}

```yaml
Type: String[]
Parameter Sets: NameCurrent, NameSuspend, NameStart, NameName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]
### PoshLibVirt.VirtualMachine[]
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
