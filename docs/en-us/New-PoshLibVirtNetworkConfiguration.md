---
external help file: PoshLibVirt-help.xml
Module Name: PoshLibVirt
online version:
schema: 2.0.0
---

# New-PoshLibVirtNetworkConfiguration

## SYNOPSIS

## SYNTAX

```
New-PoshLibVirtNetworkConfiguration [-Name] <String> [[-MtuSizeByte] <UInt16>] [[-BridgeName] <String>]
 [[-ForwardingConfiguration] <NetworkForwarding>] [[-IpAddresses] <IpEntry[]>]
 [[-InboundQoS] <NetworkServiceQuality>] [[-OutboundQoS] <NetworkServiceQuality>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
New-PoshLibVirtNetworkConfiguration -Name eth0 -BridgeName virbr0 -IpAddress @(@{IpAddress = '1.2.3.4'; NetworkMask = '255.255.255.0'})
```

## PARAMETERS

### -Name
{{ Fill Name Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MtuSizeByte
{{ Fill MtuSizeByte Description }}

```yaml
Type: UInt16
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -BridgeName
{{ Fill BridgeName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ForwardingConfiguration
{{ Fill ForwardingConfiguration Description }}

```yaml
Type: NetworkForwarding
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IpAddresses
{{ Fill IpAddresses Description }}

```yaml
Type: IpEntry[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InboundQoS
{{ Fill InboundQoS Description }}

```yaml
Type: NetworkServiceQuality
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutboundQoS
{{ Fill OutboundQoS Description }}

```yaml
Type: NetworkServiceQuality
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
