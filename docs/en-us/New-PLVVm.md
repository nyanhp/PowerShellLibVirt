---
external help file: PoshLibVirt-help.xml
Module Name: PoshLibVirt
online version:
schema: 2.0.0
---

# New-PLVVm

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### fv
```
New-PLVVm -PLVVmName <String> [-Description <String>] -Memory <UInt64> -CpuCount <UInt16> [-MaxCpuCount <UInt16>]
 [-Sockets <UInt16>] [-Cores <UInt16>] [-Threads <UInt16>] [-Cpu <CpuConfiguration>] [-CpuSet <UInt16[]>]
 [-StorageConfiguration <DiskConfiguration[]>] [-OsType <String>] [-OsVariant <String>]
 [-BootConfiguration <BootConfiguration>] [-CdRom <String>] [-InstallationSource <String>] [-PxeBoot] [-Import]
 [-LiveCd] [-NetworkAdapter <NetworkAdapter[]>] [-FullVirtualization] [-HypervisorType <String>] [-NoApic]
 [-NoAcpi] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### pv
```
New-PLVVm -PLVVmName <String> [-Description <String>] -Memory <UInt64> -CpuCount <UInt16> [-MaxCpuCount <UInt16>]
 [-Sockets <UInt16>] [-Cores <UInt16>] [-Threads <UInt16>] [-Cpu <CpuConfiguration>] [-CpuSet <UInt16[]>]
 [-StorageConfiguration <DiskConfiguration[]>] [-OsType <String>] [-OsVariant <String>]
 [-BootConfiguration <BootConfiguration>] [-CdRom <String>] [-InstallationSource <String>] [-PxeBoot] [-Import]
 [-LiveCd] [-NetworkAdapter <NetworkAdapter[]>] [-ParaVirtualization] [-HypervisorType <String>] [-NoApic]
 [-NoAcpi] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### container
```
New-PLVVm -PLVVmName <String> [-Description <String>] -Memory <UInt64> -CpuCount <UInt16> [-MaxCpuCount <UInt16>]
 [-Sockets <UInt16>] [-Cores <UInt16>] [-Threads <UInt16>] [-Cpu <CpuConfiguration>] [-CpuSet <UInt16[]>]
 [-StorageConfiguration <DiskConfiguration[]>] [-OsType <String>] [-OsVariant <String>]
 [-BootConfiguration <BootConfiguration>] [-CdRom <String>] [-InstallationSource <String>] [-PxeBoot] [-Import]
 [-LiveCd] [-NetworkAdapter <NetworkAdapter[]>] [-Container] [-HypervisorType <String>] [-NoApic] [-NoAcpi]
 [-WhatIf] [-Confirm] [<CommonParameters>]
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

### -BootConfiguration
{{ Fill BootConfiguration Description }}

```yaml
Type: BootConfiguration
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CdRom
{{ Fill CdRom Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
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

### -Container
{{ Fill Container Description }}

```yaml
Type: SwitchParameter
Parameter Sets: container
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Cores
{{ Fill Cores Description }}

```yaml
Type: UInt16
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Cpu
{{ Fill Cpu Description }}

```yaml
Type: CpuConfiguration
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CpuCount
{{ Fill CpuCount Description }}

```yaml
Type: UInt16
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CpuSet
{{ Fill CpuSet Description }}

```yaml
Type: UInt16[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
{{ Fill Description Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FullVirtualization
{{ Fill FullVirtualization Description }}

```yaml
Type: SwitchParameter
Parameter Sets: fv
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HypervisorType
{{ Fill HypervisorType Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Import
{{ Fill Import Description }}

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

### -InstallationSource
{{ Fill InstallationSource Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LiveCd
{{ Fill LiveCd Description }}

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

### -MaxCpuCount
{{ Fill MaxCpuCount Description }}

```yaml
Type: UInt16
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Memory
{{ Fill Memory Description }}

```yaml
Type: UInt64
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NetworkAdapter
{{ Fill NetworkAdapter Description }}

```yaml
Type: NetworkAdapter[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoAcpi
{{ Fill NoAcpi Description }}

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

### -NoApic
{{ Fill NoApic Description }}

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

### -OsType
{{ Fill OsType Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OsVariant
{{ Fill OsVariant Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParaVirtualization
{{ Fill ParaVirtualization Description }}

```yaml
Type: SwitchParameter
Parameter Sets: pv
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PxeBoot
{{ Fill PxeBoot Description }}

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

### -Sockets
{{ Fill Sockets Description }}

```yaml
Type: UInt16
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StorageConfiguration
{{ Fill StorageConfiguration Description }}

```yaml
Type: DiskConfiguration[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Threads
{{ Fill Threads Description }}

```yaml
Type: UInt16
Parameter Sets: (All)
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
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
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

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
