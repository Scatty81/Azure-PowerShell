Function Create-VMSnapshot {
    Param (
      [Parameter(Mandatory=$true)][string]$ResourceGroupName,
      [Parameter(Mandatory=$true)][string]$VMName
    )
  
    $VMDiskSnapshotConfigOS = New-AzSnapshotConfig -SourceUri (((get-azvm -ResourceGroupName $ResourceGroupName -Name $VMName).StorageProfile).OsDisk.ManagedDisk.id) -Location "West Europe" -CreateOption "copy" -SkuName Standard_LRS
    $VMDiskSnapShotOS       = @{
      Snapshot              = $VMDiskSnapshotConfigOS
      SnapshotName          = (((get-azvm -ResourceGroupName $ResourceGroupName -Name $VMName).StorageProfile).OsDisk | Select-Object -ExpandProperty Name)+"-snapshot-"+(Get-Date -Format yyyyMMdd-HHmmss)
      ResourceGroupName     = $ResourceGroupName
    }
    #write-host @VMDiskSnapShotOS
    New-AzSnapshot @VMDiskSnapShotOS
  
    foreach($disk in ((get-azvm -ResourceGroupName $ResourceGroupName -Name $VMName).StorageProfile).DataDisks) {
      $VMDiskSnapshotConfigData = New-AzSnapshotConfig -SourceUri (((get-azvm -ResourceGroupName $ResourceGroupName -Name $VMName).StorageProfile).DataDisks[$disk.Lun].ManagedDisk.id) -Location "West Europe" -CreateOption "copy" -SkuName Standard_LRS
  
      $VMDiskSnapShotData  = @{
        Snapshot           = $VMDiskSnapshotConfigData
        SnapshotName       = $disk.Name +"-snapshot-"+(Get-Date -Format yyyyMMdd-HHmmss)
        ResourceGroupName  =  $ResourceGroupName
      }
      # write-host @VMDiskSnapShotData
      New-AzSnapshot @VMDiskSnapShotData
    }
    write-host "Following snapshots are created"
    Get-AzSnapshot | Where-Object {$_.Id -match "$VMName"} | Select-Object Name
  }