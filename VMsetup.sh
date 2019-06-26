#Creating resource group

az group create --resource-group JenkinsGroup -l uksouth

#Creating a virtual network wihtin our resource group

az network vnet create -g JenkinsGroup -n JenkinsVirtualNetwork --address-prefixes 10.0.0.0/16 --subnet-name JenkinsSubnet --subnet-prefix 10.0.0.0/24

#Creating our subnets 

az network vnet subnet create -g JenkinsGroup  --vnet-name JenkinsVirtualNetwork --name JenkinsSubnet --address-prefixes 10.0.0.0/24

#Creating the nsg

az network nsg create -g JenkinsGroup -n JenkinsNSG

#Creating the rules in our nsg

az network nsg rule create --resource-group JenkinsGroup --name SSH --priority 100 --nsg-name JenkinsNSG

#Selecting our ports

az network nsg rule create -g JenkinsGroup --name SSH --destination-port-ranges 22 --nsg-name JenkinsNSG --priority 100
az network nsg rule create -g JenkinsGroup --name HTTP --destination-port-ranges 8080 --nsg-name JenkinsNSG --priority 200
az network nsg rule create -g JenkinsGroup --name Python --destination-port-ranges 1337 --nsg-name JenkinsNSG --priority 300

#Creating public ip

az network public-ip create --resource-group JenkinsGroup --name JenkinsIPa --dns-name dnsnamea --allocation-method Static
az network public-ip create --resource-group JenkinsGroup --name JenkinsIPb --dns-name dnsnameb --allocation-method Static
az network public-ip create --resource-group JenkinsGroup --name JenkinsIPc --dns-name dnsnamec --allocation-method Static



#Creating the nic

az network nic create --resource-group JenkinsGroup --name JenkinsNICa --vnet-name JenkinsVirtualNetwork --subnet JenkinsSubnet --network-security-group JenkinsNSG --public-ip-address JenkinsIPa
az network nic create --resource-group JenkinsGroup --name JenkinsNICb --vnet-name JenkinsVirtualNetwork --subnet JenkinsSubnet --network-security-group JenkinsNSG --public-ip-address JenkinsIPb
az network nic create --resource-group JenkinsGroup --name JenkinsNICc --vnet-name JenkinsVirtualNetwork --subnet JenkinsSubnet --network-security-group JenkinsNSG --public-ip-address JenkinsIPc

#creating the VM's

az vm create -g JenkinsGroup -n JenkinsHostVM --image UbuntuLTS --nics JenkinsNICa --size Standard_B1ls --generate-ssh-keys

az vm create -g JenkinsGroup -n JenkinsSlaveVM --image UbuntuLTS --nics JenkinsNICb --size Standard_B1ls --generate-ssh-keys

az vm create -g JenkinsGroup -n PythonServerVM --image UbuntuLTS --nics JenkinsNICc --size Standard_B1ls --generate-ssh-keys
