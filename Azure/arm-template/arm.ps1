$rgName = 'arm-rg'
$rgLocation = "eastus"
$rg = New-AzureRmResourceGroup -Name $rgName -Location $rgLocation
$parameters = @{
  appName = "maureen-armapp";
}
$templatePath = ".\arm.json"

New-AzureRmResourceGroupDeployment -ResourceGroupName $rg.ResourceGroupName -TemplateFile $templatePath -TemplateParameterObject $parameters




