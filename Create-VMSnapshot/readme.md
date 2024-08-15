Place this file into the module directory as described [here](../readme.md#install-cloud-modules)

This module will create a quick snapshot of the OS disk and aditional disks.   
lookup with  `get-azvm` for the machine where you want to create a snapshot.

Create a snapshot with:
```PowerShell
Create-VMSnapshot -ResourceGroupName MyResourceGroup01 -VmName MyServer01
```
The Snapshots will have the following format:  
{VMName}-{DiskName}-snapshot-{yyymmdd-HHmmss}

> [!NOTE]
> the time might be different than your local time depending on the timezone
```
MyServer01-OSdisk-snapshot-20240815-152423
MyServer01-DataDisk01-snapshot-20240815-152435
```
 
 To view all the Snapshots just type 
 ```PowerShell 
 get-AzSnapshot | Where-Object {$_.ResourceGroupName -eq "MyResourceGroup01"} | Select-Object Name
 ```