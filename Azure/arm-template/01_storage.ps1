$rg = 'arm-storage-01'
New-AzResourceGroup -Name $rg -Location northeroupe - Force

New-AzResourceGroupDeployment `
  -Name 'New-storage' `
  -ResourceGroupName $rg`
  -TemplateFile '01_storage.json'