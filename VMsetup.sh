#Creating resource group

az group create --resource-group JenkinsGroup -l uksouth

#Creating a virtual network wihtin our resource group

az network vnet create -g JenkinsGroup -n JenkinsVirtualNetwork --address-prefixes 10.0.0.0/16 --subnet-name JenkinsSubnet --subnet-prefix 10.0.0.0/24

#Creating our subnets 

az network vnet subnet create -g JenkinsGroup  --vnet-name JenkinsVirtualNetwork --name JenkinsSubnet --address-prefixes 10.0.0.0/24

#Creating our virtual machine

az vm create -g JenkinsGroup -n VirtualMachineGroup --image UbuntuLTS --admin-username azureuser --generate-ssh-keys

#Creating the nsg

az network nsg create -g JenkinsGroup -n JenkinsNSG

#Creating the rules in our nsg

az network nsg rule create --resource-group JenkinsGroup --name SSH --priority 500 --nsg-name JenkinsNSG

#Selecting our ports

az network nsg rule create -g JenkinsGroup --name SSH --destination-port-ranges 22 --nsg-name JenkinsNSG --priority 400

#Creating public ip

az network public-ip create --resource-group JenkinsGroup --name JenkinsIP1 --dns-name dnsname --allocation-method Static
az network public-ip create --resource-group JenkinsGroup --name JenkinsIP2 --dns-name dnsname --allocation-method Static
az network public-ip create --resource-group JenkinsGroup --name JenkinsIP3 --dns-name dnsname --allocation-method Static



#Creating the nic

az network nic create --resource-group JenkinsGroup --name JenkinsNIC1 --vnet-name JenkinsVirtualNetwork --subnet JenkinsSubnet --network-security-group JenkinsNSG --public-ip-address JenkinsIP
az network nic create --resource-group JenkinsGroup --name JenkinsNIC2 --vnet-name JenkinsVirtualNetwork --subnet JenkinsSubnet --network-security-group JenkinsNSG --public-ip-address JenkinsIP
az network nic create --resource-group JenkinsGroup --name JenkinsNIC3 --vnet-name JenkinsVirtualNetwork --subnet JenkinsSubnet --network-security-group JenkinsNSG --public-ip-address JenkinsIP

#creating the VM's

az vm create -g JenkinsGroup -n JenkinsHostVM --image UbuntuLTS --nics JenkinsNIC1 --size Standard_B1ls

az vm create -g JenkinsGroup -n JenkinsSlaveVM --image UbuntuLTS --nics JenkinsNIC2 --size Standard_B1ls

az vm create -g JenkinsGroup -n PythonServerVM --image UbuntuLTS --nics JenkinsNIC3 --size Standard_B1ls