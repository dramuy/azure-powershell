---
external help file: Az.ServiceBus-help.xml
Module Name: Az.ServiceBus
online version: https://docs.microsoft.com/en-us/powershell/module/az.servicebus/new-azservicebusnamespacekey
schema: 2.0.0
---

# New-AzServiceBusNamespaceKey

## SYNOPSIS
Regenerates the primary or secondary connection strings for the namespace.

## SYNTAX

### RegenerateSubscriptionIdViaHost (Default)
```
New-AzServiceBusNamespaceKey -AuthorizationRuleName <String> -NamespaceName <String>
 -ResourceGroupName <String> [-Parameter <IRegenerateAccessKeyParameters>] [-DefaultProfile <PSObject>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### RegenerateExpanded
```
New-AzServiceBusNamespaceKey -AuthorizationRuleName <String> -NamespaceName <String>
 -ResourceGroupName <String> -SubscriptionId <String> [-Key <String>] -KeyType <KeyType>
 [-DefaultProfile <PSObject>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Regenerate
```
New-AzServiceBusNamespaceKey -AuthorizationRuleName <String> -NamespaceName <String>
 -ResourceGroupName <String> -SubscriptionId <String> [-Parameter <IRegenerateAccessKeyParameters>]
 [-DefaultProfile <PSObject>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### RegenerateSubscriptionIdViaHostExpanded
```
New-AzServiceBusNamespaceKey -AuthorizationRuleName <String> -NamespaceName <String>
 -ResourceGroupName <String> [-Key <String>] -KeyType <KeyType> [-DefaultProfile <PSObject>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Regenerates the primary or secondary connection strings for the namespace.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -AuthorizationRuleName
The authorization rule name.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultProfile
The credentials, account, tenant, and subscription used for communication with Azure.

```yaml
Type: System.Management.Automation.PSObject
Parameter Sets: (All)
Aliases: AzureRMContext, AzureCredential

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Key
Optional, if the key value provided, is reset for KeyType value or autogenerate Key value set for keyType

```yaml
Type: System.String
Parameter Sets: RegenerateExpanded, RegenerateSubscriptionIdViaHostExpanded
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KeyType
The access key to regenerate.

```yaml
Type: Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Support.KeyType
Parameter Sets: RegenerateExpanded, RegenerateSubscriptionIdViaHostExpanded
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NamespaceName
The namespace name

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Parameter
Parameters supplied to the Regenerate Authorization Rule operation, specifies which key needs to be reset.

```yaml
Type: Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Models.Api20170401.IRegenerateAccessKeyParameters
Parameter Sets: RegenerateSubscriptionIdViaHost, Regenerate
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ResourceGroupName
Name of the Resource group within the Azure subscription.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SubscriptionId
Subscription credentials that uniquely identify a Microsoft Azure subscription.
The subscription ID forms part of the URI for every service call.

```yaml
Type: System.String
Parameter Sets: RegenerateExpanded, Regenerate
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: System.Management.Automation.SwitchParameter
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

## OUTPUTS

### Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Models.Api20170401.IAccessKeys
## NOTES

## RELATED LINKS

[https://docs.microsoft.com/en-us/powershell/module/az.servicebus/new-azservicebusnamespacekey](https://docs.microsoft.com/en-us/powershell/module/az.servicebus/new-azservicebusnamespacekey)
