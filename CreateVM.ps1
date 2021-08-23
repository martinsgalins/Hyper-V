$Customer = "test"
$VMname = "cust-$Customer-dp01"
#create OS disk from sysprep image, prepared before
New-Item -ItemType "directory" -Path "D:\VM\$VMname\Virtual Hard Disks"
Copy-Item "C:\TEMP\srv2019DC-sysprep202104.vhdx" -Destination "D:\VM\$VMname\Virtual Hard Disks\$VMname-OSdisk.vhdx"

#create Data disk
$DATAdisk = New-VHD -Path "E:\VM\$VMname\Virtual Hard Disks\$VMname-DataDisk-01.vhdx" -SizeBytes 100GB -Dynamic
#Create VM
New-VM -Name $VMname -MemoryStartupBytes 2048MB -Path D:\VM\ -Generation 2 -Switch "Microsoft Network Adapter Multiplexor Driver - Virtual Switch"
#Attach OS disk to VM
Add-VMHardDiskDrive -VMName $VMname -Path "D:\VM\$VMname\Virtual Hard Disks\$VMname-OSdisk.vhdx"

#Attach DATA disk to VM
Add-VMHardDiskDrive -VMName $VMname -Path $DATAdisk.path

#Set VLAN ID on VM NIC
Set-VMNetworkAdapterVlan -VMName $VMname -Access -VlanId 1

#Change boot order
$old_boot_order = Get-VMFirmware -VMName $VMname | Select-Object -ExpandProperty BootOrder
$new_boot_order = $old_boot_order | Where-Object { $_.BootType -ne "Network" }
Set-VMFirmware -VMName $VMname  -BootOrder $new_boot_order
