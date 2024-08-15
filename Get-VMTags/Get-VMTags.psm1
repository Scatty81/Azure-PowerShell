Function Get-VMTags {
    $VMs = Get-AzVM
    foreach ($VM in $VMs) {
      foreach ($tag in $VM.Tags.GetEnumerator()) {
        [PSCustomObject]@{
          Server = $VM.Name
          Tagname = $tag.Key
          TagValue = $tag.Value
        }
      }
    }
  }