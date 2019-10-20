# Variables for common values
$resourceGroup = "RG-LAB-BCDR"
$location = "eastus"
$vmName = "VM-IIS"

# Create a resource group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create user object
$cred = Get-Credential -Message "Enter a username and password for the virtual machine."

# Create a virtual machine
New-AzVM `
  -ResourceGroupName $resourceGroup `
  -Name $vmName `
  -Location $location `
  -ImageName "Win2016Datacenter" `
  -VirtualNetworkName "RG-LAB-BCDR-vnet" `
  -SubnetName "default" `
  -SecurityGroupName "VM-IIS-nsg" `
  -PublicIpAddressName "VM-IIS-pubIP" `
  -Credential $cred `
  -OpenPorts 80

# Install IIS
$PublicSettings = '{"ModulesURL":"https://github.com/Azure/azure-quickstart-templates/raw/master/dsc-extension-iis-server-windows-vm/ContosoWebsite.ps1.zip", "configurationFunction": "ContosoWebsite.ps1\\ContosoWebsite", "Properties": {"MachineName": "VM-IIS"} }'

Set-AzVMExtension -ExtensionName "DSC" -ResourceGroupName $resourceGroup -VMName $vmName `
  -Publisher "Microsoft.Powershell" -ExtensionType "DSC" -TypeHandlerVersion 2.19 `
  -SettingString $PublicSettings -Location $location