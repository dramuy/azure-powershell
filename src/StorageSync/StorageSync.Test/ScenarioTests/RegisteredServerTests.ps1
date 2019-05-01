﻿# ----------------------------------------------------------------------------------
#
# Copyright Microsoft Corporation
# Licensed under the Apache License, Version 2.0 (the "License")
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ----------------------------------------------------------------------------------

<#
.SYNOPSIS
Test RegisteredServer
.DESCRIPTION
SmokeTest
#>
function Test-RegisteredServer
{
    # Setup
    $resourceGroupName = Get-ResourceGroupName
    Write-Verbose "RecordMode : $(Get-StorageTestMode)"
    try
    {
        # Test
        $storageSyncServiceName = Get-ResourceName("sss")
        $resourceGroupLocation = Get-ResourceGroupLocation
        $resourceLocation = Get-StorageSyncLocation("Microsoft.StorageSync/storageSyncServices")

        Write-Verbose "RGName: $resourceGroupName | Loc: $resourceGroupLocation | Type : ResourceGroup"
        New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

        Write-Verbose "Resource: $storageSyncServiceName | Loc: $resourceLocation | Type : StorageSyncService"
        $storageSyncService = New-AzStorageSyncService -ResourceGroupName $resourceGroupName -Location $resourceLocation -StorageSyncServiceName $storageSyncServiceName

        Write-Verbose "Resource: <auto-generated> | Loc: $resourceLocation | Type : RegisteredServer"
        $job = Register-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -AsJob 
        $job | Wait-Job
        $expectedRegisteredServer = get-job -Id $job.Id | receive-job -Keep
        $expectedRegisteredServer

        Write-Verbose "Get RegisteredServer by ServerId"
        $registeredServer = Get-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -ServerId $expectedRegisteredServer.ServerId -Verbose
        Write-Verbose "Validating RegisteredServer Properties"
        Assert-AreEqual $registeredServer.ServerId $expectedRegisteredServer.ServerId

        Write-Verbose "Get RegisteredServer by ParentObject"
        $registeredServers = Get-AzStorageSyncServer -ParentObject $storageSyncService -Verbose
        Assert-AreEqual $registeredServers.Length 1
        $registeredServer = $registeredServers[0]
        Write-Verbose "Validating RegisteredServer Properties"
        Assert-AreEqual $registeredServer.ServerId $expectedRegisteredServer.ServerId

        Write-Verbose "Get RegisteredServer by ParentResourceId"
        $registeredServers = Get-AzStorageSyncServer -ParentResourceId $storageSyncService.ResourceId -Verbose
        Assert-AreEqual $registeredServers.Length 1
        $registeredServer = $registeredServers[0]
        Write-Verbose "Validating RegisteredServer Properties"
        Assert-AreEqual $registeredServer.ServerId $expectedRegisteredServer.ServerId

        Write-Verbose "Unregister Server: $($expectedRegisteredServer.ServerId)"
        Unregister-AzStorageSyncServer -Force -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -ServerId $expectedRegisteredServer.ServerId -AsJob | Wait-Job

        Write-Verbose "Removing StorageSyncService: $storageSyncServiceName"
        Remove-AzStorageSyncService -Force -ResourceGroupName $resourceGroupName -Name $storageSyncServiceName -AsJob | Wait-Job
    }
    finally
    {
        # Cleanup
        Write-Verbose "Removing ResourceGroup : $resourceGroupName"
        Clean-ResourceGroup $resourceGroupName
    }
}

<#
.SYNOPSIS
Test RegisteredServerPipeline1
.DESCRIPTION
SmokeTest
#>
function Test-RegisteredServerPipeline1
{
    # Setup
    $resourceGroupName = Get-ResourceGroupName
    Write-Verbose "RecordMode : $(Get-StorageTestMode)"
    try
    {
        # Test
        $storageSyncServiceName = Get-ResourceName("sss")
        $resourceGroupLocation = Get-ResourceGroupLocation
        $resourceLocation = Get-StorageSyncLocation("Microsoft.StorageSync/storageSyncServices")

        Write-Verbose "RGName: $resourceGroupName | Loc: $resourceGroupLocation | Type : ResourceGroup"
        New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

        Write-Verbose "Resource: $storageSyncServiceName | Loc: $resourceLocation | Type : StorageSyncService"
        $storageSyncService = New-AzStorageSyncService -ResourceGroupName $resourceGroupName -Location $resourceLocation -StorageSyncServiceName $storageSyncServiceName

        Write-Verbose "Resource: <auto-generated> | Loc: $resourceLocation | Type : RegisteredServer"

        Register-AzStorageSyncServer -ParentObject $storageSyncService | Get-AzStorageSyncServer | Unregister-AzStorageSyncServer -Force -AsJob | Wait-Job

        Write-Verbose "Removing StorageSyncService: $storageSyncServiceName"
        Remove-AzStorageSyncService -Force -ResourceGroupName $resourceGroupName -Name $storageSyncServiceName -AsJob | Wait-Job
    }
    finally
    {
        # Cleanup
        Write-Verbose "Removing ResourceGroup : $resourceGroupName"
        Clean-ResourceGroup $resourceGroupName
    }
}

<#
.SYNOPSIS
Test RegisteredServerPipeline2
.DESCRIPTION
SmokeTest
#>
function Test-RegisteredServerPipeline2
{
    # Setup
    $resourceGroupName = Get-ResourceGroupName
    Write-Verbose "RecordMode : $(Get-StorageTestMode)"
    try
    {
        # Test
        $storageSyncServiceName = Get-ResourceName("sss")
        $resourceGroupLocation = Get-ResourceGroupLocation
        $resourceLocation = Get-StorageSyncLocation("Microsoft.StorageSync/storageSyncServices")

        Write-Verbose "RGName: $resourceGroupName | Loc: $resourceGroupLocation | Type : ResourceGroup"
        New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

        Write-Verbose "Resource: $storageSyncServiceName | Loc: $resourceLocation | Type : StorageSyncService"
        $storageSyncService = New-AzStorageSyncService -ResourceGroupName $resourceGroupName -Location $resourceLocation -StorageSyncServiceName $storageSyncServiceName

        Write-Verbose "Resource: <auto-generated> | Loc: $resourceLocation | Type : RegisteredServer"

        Register-AzStorageSyncServer -ParentResourceId $storageSyncService.ResourceId | Unregister-AzStorageSyncServer -Force -AsJob | Wait-Job

        Write-Verbose "Removing StorageSyncService: $storageSyncServiceName"
        Remove-AzStorageSyncService -Force -ResourceGroupName $resourceGroupName -Name $storageSyncServiceName -AsJob | Wait-Job
    }
    finally
    {
        # Cleanup
        Write-Verbose "Removing ResourceGroup : $resourceGroupName"
        Clean-ResourceGroup $resourceGroupName
    }
}

<#
.SYNOPSIS
Test NewRegisteredServer
.DESCRIPTION
SmokeTest
#>
function Test-NewRegisteredServer
{
   # Setup
    $resourceGroupName = Get-ResourceGroupName
    Write-Verbose "RecordMode : $(Get-StorageTestMode)"
    try
    {
        # Test
        $storageSyncServiceName = Get-ResourceName("sss")
        $resourceGroupLocation = Get-ResourceGroupLocation
        $resourceLocation = Get-StorageSyncLocation("Microsoft.StorageSync/storageSyncServices")

        Write-Verbose "RGName: $resourceGroupName | Loc: $resourceGroupLocation | Type : ResourceGroup"
        New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

        Write-Verbose "Resource: $storageSyncServiceName | Loc: $resourceLocation | Type : StorageSyncService"
        $storageSyncService = New-AzStorageSyncService -ResourceGroupName $resourceGroupName -Location $resourceLocation -StorageSyncServiceName $storageSyncServiceName

        Write-Verbose "Resource: <auto-generated> | Loc: $resourceLocation | Type : RegisteredServer"
        $job = Register-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -AsJob 
        $job | Wait-Job
        $expectedRegisteredServer = get-job -Id $job.Id | receive-job -Keep
        $expectedRegisteredServer

        Write-Verbose "Get RegisteredServer by ServerId"
        $registeredServer = Get-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -ServerId $expectedRegisteredServer.ServerId -Verbose
        Write-Verbose "Validating RegisteredServer Properties"
        Assert-AreEqual $registeredServer.ServerId $expectedRegisteredServer.ServerId

        Write-Verbose "Unregister Server: $($expectedRegisteredServer.ServerId)"
        Unregister-AzStorageSyncServer -Force -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -ServerId $expectedRegisteredServer.ServerId -AsJob | Wait-Job

        Write-Verbose "Removing StorageSyncService: $storageSyncServiceName"
        Remove-AzStorageSyncService -Force -ResourceGroupName $resourceGroupName -Name $storageSyncServiceName -AsJob | Wait-Job
    }
    finally
    {
        # Cleanup
        Write-Verbose "Removing ResourceGroup : $resourceGroupName"
        Clean-ResourceGroup $resourceGroupName
    }
}

<#
.SYNOPSIS
Test NewRegisteredServerParentObject
.DESCRIPTION
SmokeTest
#>
function Test-NewRegisteredServerParentObject
{
   # Setup
    $resourceGroupName = Get-ResourceGroupName
    Write-Verbose "RecordMode : $(Get-StorageTestMode)"
    try
    {
        # Test
        $storageSyncServiceName = Get-ResourceName("sss")
        $resourceGroupLocation = Get-ResourceGroupLocation
        $resourceLocation = Get-StorageSyncLocation("Microsoft.StorageSync/storageSyncServices")

        Write-Verbose "RGName: $resourceGroupName | Loc: $resourceGroupLocation | Type : ResourceGroup"
        New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

        Write-Verbose "Resource: $storageSyncServiceName | Loc: $resourceLocation | Type : StorageSyncService"
        $storageSyncService = New-AzStorageSyncService -ResourceGroupName $resourceGroupName -Location $resourceLocation -StorageSyncServiceName $storageSyncServiceName

        Write-Verbose "Resource: <auto-generated> | Loc: $resourceLocation | Type : RegisteredServer"
        $job = Register-AzStorageSyncServer -ParentObject $storageSyncService -AsJob 
        $job | Wait-Job
        $expectedRegisteredServer = get-job -Id $job.Id | receive-job -Keep
        $expectedRegisteredServer

        Write-Verbose "Get RegisteredServer by ServerId"
        $registeredServer = Get-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -ServerId $expectedRegisteredServer.ServerId -Verbose
        Write-Verbose "Validating RegisteredServer Properties"
        Assert-AreEqual $registeredServer.ServerId $expectedRegisteredServer.ServerId

        Write-Verbose "Unregister Server: $($expectedRegisteredServer.ServerId)"
        Unregister-AzStorageSyncServer -Force -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -ServerId $expectedRegisteredServer.ServerId -AsJob | Wait-Job

        Write-Verbose "Removing StorageSyncService: $storageSyncServiceName"
        Remove-AzStorageSyncService -Force -ResourceGroupName $resourceGroupName -Name $storageSyncServiceName -AsJob | Wait-Job
    }
    finally
    {
        # Cleanup
        Write-Verbose "Removing ResourceGroup : $resourceGroupName"
        Clean-ResourceGroup $resourceGroupName
    }
}

<#
.SYNOPSIS
Test NewRegisteredServerParentResourceId
.DESCRIPTION
SmokeTest
#>
function Test-NewRegisteredServerParentResourceId
{
   # Setup
    $resourceGroupName = Get-ResourceGroupName
    Write-Verbose "RecordMode : $(Get-StorageTestMode)"
    try
    {
        # Test
        $storageSyncServiceName = Get-ResourceName("sss")
        $resourceGroupLocation = Get-ResourceGroupLocation
        $resourceLocation = Get-StorageSyncLocation("Microsoft.StorageSync/storageSyncServices")

        Write-Verbose "RGName: $resourceGroupName | Loc: $resourceGroupLocation | Type : ResourceGroup"
        New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

        Write-Verbose "Resource: $storageSyncServiceName | Loc: $resourceLocation | Type : StorageSyncService"
        $storageSyncService = New-AzStorageSyncService -ResourceGroupName $resourceGroupName -Location $resourceLocation -StorageSyncServiceName $storageSyncServiceName

        Write-Verbose "Resource: <auto-generated> | Loc: $resourceLocation | Type : RegisteredServer"
        $job = Register-AzStorageSyncServer -ParentResourceId $storageSyncService.ResourceId -AsJob 
        $job | Wait-Job
        $expectedRegisteredServer = get-job -Id $job.Id | receive-job -Keep
        $expectedRegisteredServer

        Write-Verbose "Get RegisteredServer by ServerId"
        $registeredServer = Get-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -ServerId $expectedRegisteredServer.ServerId -Verbose
        Write-Verbose "Validating RegisteredServer Properties"
        Assert-AreEqual $registeredServer.ServerId $expectedRegisteredServer.ServerId

        Write-Verbose "Unregister Server: $($expectedRegisteredServer.ServerId)"
        Unregister-AzStorageSyncServer -Force -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -ServerId $expectedRegisteredServer.ServerId -AsJob | Wait-Job

        Write-Verbose "Removing StorageSyncService: $storageSyncServiceName"
        Remove-AzStorageSyncService -Force -ResourceGroupName $resourceGroupName -Name $storageSyncServiceName -AsJob | Wait-Job
    }
    finally
    {
        # Cleanup
        Write-Verbose "Removing ResourceGroup : $resourceGroupName"
        Clean-ResourceGroup $resourceGroupName
    }
}

<#
.SYNOPSIS
Test GetRegisteredServer
.DESCRIPTION
SmokeTest
#>
function Test-GetRegisteredServer
{
     # Setup
    $resourceGroupName = Get-ResourceGroupName
    Write-Verbose "RecordMode : $(Get-StorageTestMode)"
    try
    {
        # Test
        $storageSyncServiceName = Get-ResourceName("sss")
        $resourceGroupLocation = Get-ResourceGroupLocation
        $resourceLocation = Get-StorageSyncLocation("Microsoft.StorageSync/storageSyncServices")

        Write-Verbose "RGName: $resourceGroupName | Loc: $resourceGroupLocation | Type : ResourceGroup"
        New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

        Write-Verbose "Resource: $storageSyncServiceName | Loc: $resourceLocation | Type : StorageSyncService"
        $storageSyncService = New-AzStorageSyncService -ResourceGroupName $resourceGroupName -Location $resourceLocation -StorageSyncServiceName $storageSyncServiceName

        Write-Verbose "Resource: <auto-generated> | Loc: $resourceLocation | Type : RegisteredServer"
        $job = Register-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -AsJob 
        $job | Wait-Job
        $expectedRegisteredServer = get-job -Id $job.Id | receive-job -Keep
        $expectedRegisteredServer

        Write-Verbose "Get RegisteredServer by StorageSyncService"
        $registeredServers = Get-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -Verbose

        Write-Verbose "Get RegisteredServer by ServerId"
        $registeredServer = Get-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -ServerId $expectedRegisteredServer.ServerId -Verbose
        Write-Verbose "Validating RegisteredServer Properties"
        Assert-AreEqual $registeredServer.ServerId $expectedRegisteredServer.ServerId

        Write-Verbose "Unregister Server: $($expectedRegisteredServer.ServerId)"
        Unregister-AzStorageSyncServer -Force -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -ServerId $expectedRegisteredServer.ServerId -AsJob | Wait-Job

        Write-Verbose "Removing StorageSyncService: $storageSyncServiceName"
        Remove-AzStorageSyncService -Force -ResourceGroupName $resourceGroupName -Name $storageSyncServiceName -AsJob | Wait-Job
    }
    finally
    {
        # Cleanup
        Write-Verbose "Removing ResourceGroup : $resourceGroupName"
        Clean-ResourceGroup $resourceGroupName
    }
}

<#
.SYNOPSIS
Test GetRegisteredServers
.DESCRIPTION
SmokeTest
#>
function Test-GetRegisteredServers
{
    # Setup
    $resourceGroupName = Get-ResourceGroupName
    Write-Verbose "RecordMode : $(Get-StorageTestMode)"
    try
    {
        # Test
        $storageSyncServiceName = Get-ResourceName("sss")
        $resourceGroupLocation = Get-ResourceGroupLocation
        $resourceLocation = Get-StorageSyncLocation("Microsoft.StorageSync/storageSyncServices")

        Write-Verbose "RGName: $resourceGroupName | Loc: $resourceGroupLocation | Type : ResourceGroup"
        New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

        Write-Verbose "Resource: $storageSyncServiceName | Loc: $resourceLocation | Type : StorageSyncService"
        $storageSyncService = New-AzStorageSyncService -ResourceGroupName $resourceGroupName -Location $resourceLocation -StorageSyncServiceName $storageSyncServiceName

        Write-Verbose "Resource: <auto-generated> | Loc: $resourceLocation | Type : RegisteredServer"
        $job = Register-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -AsJob 
        $job | Wait-Job
        $expectedRegisteredServer = get-job -Id $job.Id | receive-job -Keep
        $expectedRegisteredServer

        Write-Verbose "Get RegisteredServer by StorageSyncService"
        $registeredServers = Get-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -Verbose

        Assert-AreEqual $registeredServers.Length 1
        $registeredServer = $registeredServers[0]

        Write-Verbose "Validating RegisteredServer Properties"
        Assert-AreEqual $registeredServer.ServerId $expectedRegisteredServer.ServerId

        Write-Verbose "Unregister Server: $($expectedRegisteredServer.ServerId)"
        Unregister-AzStorageSyncServer -Force -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -ServerId $expectedRegisteredServer.ServerId -AsJob | Wait-Job

        Write-Verbose "Removing StorageSyncService: $storageSyncServiceName"
        Remove-AzStorageSyncService -Force -ResourceGroupName $resourceGroupName -Name $storageSyncServiceName -AsJob | Wait-Job
    }
    finally
    {
        # Cleanup
        Write-Verbose "Removing ResourceGroup : $resourceGroupName"
        Clean-ResourceGroup $resourceGroupName
    }
}

<#
.SYNOPSIS
Test GetRegisteredServerParentObject
.DESCRIPTION
SmokeTest
#>
function Test-GetRegisteredServerParentObject
{
      # Setup
    $resourceGroupName = Get-ResourceGroupName
    Write-Verbose "RecordMode : $(Get-StorageTestMode)"
    try
    {
        # Test
        $storageSyncServiceName = Get-ResourceName("sss")
        $resourceGroupLocation = Get-ResourceGroupLocation
        $resourceLocation = Get-StorageSyncLocation("Microsoft.StorageSync/storageSyncServices")

        Write-Verbose "RGName: $resourceGroupName | Loc: $resourceGroupLocation | Type : ResourceGroup"
        New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

        Write-Verbose "Resource: $storageSyncServiceName | Loc: $resourceLocation | Type : StorageSyncService"
        $storageSyncService = New-AzStorageSyncService -ResourceGroupName $resourceGroupName -Location $resourceLocation -StorageSyncServiceName $storageSyncServiceName

        Write-Verbose "Resource: <auto-generated> | Loc: $resourceLocation | Type : RegisteredServer"
        $job = Register-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -AsJob 
        $job | Wait-Job
        $expectedRegisteredServer = get-job -Id $job.Id | receive-job -Keep
        $expectedRegisteredServer

        Write-Verbose "Get RegisteredServer by ServerId"
        $registeredServer = Get-AzStorageSyncServer -ParentObject $storageSyncService -ServerId $expectedRegisteredServer.ServerId -Verbose
        Write-Verbose "Validating RegisteredServer Properties"
        Assert-AreEqual $registeredServer.ServerId $expectedRegisteredServer.ServerId

        Write-Verbose "Unregister Server: $($expectedRegisteredServer.ServerId)"
        Unregister-AzStorageSyncServer -Force -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -ServerId $expectedRegisteredServer.ServerId -AsJob | Wait-Job

        Write-Verbose "Removing StorageSyncService: $storageSyncServiceName"
        Remove-AzStorageSyncService -Force -ResourceGroupName $resourceGroupName -Name $storageSyncServiceName -AsJob | Wait-Job
    }
    finally
    {
        # Cleanup
        Write-Verbose "Removing ResourceGroup : $resourceGroupName"
        Clean-ResourceGroup $resourceGroupName
    }
}

<#
.SYNOPSIS
Test GetRegisteredServerParentResourceId
.DESCRIPTION
SmokeTest
#>
function Test-GetRegisteredServerParentResourceId
{
    # Setup
    $resourceGroupName = Get-ResourceGroupName
    Write-Verbose "RecordMode : $(Get-StorageTestMode)"
    try
    {
        # Test
        $storageSyncServiceName = Get-ResourceName("sss")
        $resourceGroupLocation = Get-ResourceGroupLocation
        $resourceLocation = Get-StorageSyncLocation("Microsoft.StorageSync/storageSyncServices")

        Write-Verbose "RGName: $resourceGroupName | Loc: $resourceGroupLocation | Type : ResourceGroup"
        New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

        Write-Verbose "Resource: $storageSyncServiceName | Loc: $resourceLocation | Type : StorageSyncService"
        $storageSyncService = New-AzStorageSyncService -ResourceGroupName $resourceGroupName -Location $resourceLocation -StorageSyncServiceName $storageSyncServiceName

        Write-Verbose "Resource: <auto-generated> | Loc: $resourceLocation | Type : RegisteredServer"
        $job = Register-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -AsJob 
        $job | Wait-Job
        $expectedRegisteredServer = get-job -Id $job.Id | receive-job -Keep
        $expectedRegisteredServer

        Write-Verbose "Get RegisteredServer by ServerId"
        $registeredServer = Get-AzStorageSyncServer -ParentResourceId $storageSyncService.ResourceId -ServerId $expectedRegisteredServer.ServerId -Verbose
        Write-Verbose "Validating RegisteredServer Properties"
        Assert-AreEqual $registeredServer.ServerId $expectedRegisteredServer.ServerId

        Write-Verbose "Unregister Server: $($expectedRegisteredServer.ServerId)"
        Unregister-AzStorageSyncServer -Force -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -ServerId $expectedRegisteredServer.ServerId -AsJob | Wait-Job

        Write-Verbose "Removing StorageSyncService: $storageSyncServiceName"
        Remove-AzStorageSyncService -Force -ResourceGroupName $resourceGroupName -Name $storageSyncServiceName -AsJob | Wait-Job
    }
    finally
    {
        # Cleanup
        Write-Verbose "Removing ResourceGroup : $resourceGroupName"
        Clean-ResourceGroup $resourceGroupName
    }
}

<#
.SYNOPSIS
Test RemoveRegisteredServer
.DESCRIPTION
SmokeTest
#>
function Test-RemoveRegisteredServer
{
    # Setup
    $resourceGroupName = Get-ResourceGroupName
    Write-Verbose "RecordMode : $(Get-StorageTestMode)"
    try
    {
        # Test
        $storageSyncServiceName = Get-ResourceName("sss")
        $resourceGroupLocation = Get-ResourceGroupLocation
        $resourceLocation = Get-StorageSyncLocation("Microsoft.StorageSync/storageSyncServices")

        Write-Verbose "RGName: $resourceGroupName | Loc: $resourceGroupLocation | Type : ResourceGroup"
        New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

        Write-Verbose "Resource: $storageSyncServiceName | Loc: $resourceLocation | Type : StorageSyncService"
        $storageSyncService = New-AzStorageSyncService -ResourceGroupName $resourceGroupName -Location $resourceLocation -StorageSyncServiceName $storageSyncServiceName

        Write-Verbose "Resource: <auto-generated> | Loc: $resourceLocation | Type : RegisteredServer"
        $job = Register-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -AsJob 
        $job | Wait-Job
        $expectedRegisteredServer = get-job -Id $job.Id | receive-job -Keep

        Write-Verbose "Unregister Server: $($expectedRegisteredServer.ServerId)"
        Unregister-AzStorageSyncServer -Force -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -ServerId $expectedRegisteredServer.ServerId -AsJob | Wait-Job

        Write-Verbose "Removing StorageSyncService: $storageSyncServiceName"
        Remove-AzStorageSyncService -Force -ResourceGroupName $resourceGroupName -Name $storageSyncServiceName -AsJob | Wait-Job
    }
    finally
    {
        # Cleanup
        Write-Verbose "Removing ResourceGroup : $resourceGroupName"
        Clean-ResourceGroup $resourceGroupName
    }
}

<#
.SYNOPSIS
Test RemoveRegisteredServerInputObject
.DESCRIPTION
SmokeTest
#>
function Test-RemoveRegisteredServerInputObject
{
    # Setup
    $resourceGroupName = Get-ResourceGroupName
    Write-Verbose "RecordMode : $(Get-StorageTestMode)"
    try
    {
        # Test
        $storageSyncServiceName = Get-ResourceName("sss")
        $resourceGroupLocation = Get-ResourceGroupLocation
        $resourceLocation = Get-StorageSyncLocation("Microsoft.StorageSync/storageSyncServices")

        Write-Verbose "RGName: $resourceGroupName | Loc: $resourceGroupLocation | Type : ResourceGroup"
        New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

        Write-Verbose "Resource: $storageSyncServiceName | Loc: $resourceLocation | Type : StorageSyncService"
        $storageSyncService = New-AzStorageSyncService -ResourceGroupName $resourceGroupName -Location $resourceLocation -StorageSyncServiceName $storageSyncServiceName

        Write-Verbose "Resource: <auto-generated> | Loc: $resourceLocation | Type : RegisteredServer"
        $job = Register-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -AsJob 
        $job | Wait-Job
        $expectedRegisteredServer = get-job -Id $job.Id | receive-job -Keep

        Write-Verbose "Unregister Server: $($expectedRegisteredServer.ServerId)"
        Unregister-AzStorageSyncServer -Force -InputObject $expectedRegisteredServer -AsJob | Wait-Job

        Write-Verbose "Removing StorageSyncService: $storageSyncServiceName"
        Remove-AzStorageSyncService -Force -ResourceGroupName $resourceGroupName -Name $storageSyncServiceName -AsJob | Wait-Job
    }
    finally
    {
        # Cleanup
        Write-Verbose "Removing ResourceGroup : $resourceGroupName"
        Clean-ResourceGroup $resourceGroupName
    }
}


<#
.SYNOPSIS
Test RemoveRegisteredServerInputObject
.DESCRIPTION
SmokeTest
#>
function Test-RemoveRegisteredServerResourceId
{
    # Setup
    $resourceGroupName = Get-ResourceGroupName
    Write-Verbose "RecordMode : $(Get-StorageTestMode)"
    try
    {
        # Test
        $storageSyncServiceName = Get-ResourceName("sss")
        $resourceGroupLocation = Get-ResourceGroupLocation
        $resourceLocation = Get-StorageSyncLocation("Microsoft.StorageSync/storageSyncServices")

        Write-Verbose "RGName: $resourceGroupName | Loc: $resourceGroupLocation | Type : ResourceGroup"
        New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation

        Write-Verbose "Resource: $storageSyncServiceName | Loc: $resourceLocation | Type : StorageSyncService"
        $storageSyncService = New-AzStorageSyncService -ResourceGroupName $resourceGroupName -Location $resourceLocation -StorageSyncServiceName $storageSyncServiceName

        Write-Verbose "Resource: <auto-generated> | Loc: $resourceLocation | Type : RegisteredServer"
        $job = Register-AzStorageSyncServer -ResourceGroupName $resourceGroupName -StorageSyncServiceName $storageSyncServiceName -AsJob 
        $job | Wait-Job
        $expectedRegisteredServer = get-job -Id $job.Id | receive-job -Keep
        $expectedRegisteredServer

        Write-Verbose "Unregister Server: $($expectedRegisteredServer.ServerId)"
        Unregister-AzStorageSyncServer -Force -ResourceId $expectedRegisteredServer.ResourceId -AsJob | Wait-Job

        Write-Verbose "Removing StorageSyncService: $storageSyncServiceName"
        Remove-AzStorageSyncService -Force -ResourceGroupName $resourceGroupName -Name $storageSyncServiceName -AsJob | Wait-Job
    }
    finally
    {
        # Cleanup
        Write-Verbose "Removing ResourceGroup : $resourceGroupName"
        Clean-ResourceGroup $resourceGroupName
    }
}