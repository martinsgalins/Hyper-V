#Script to resize VHD to whole MB, so it is ready to uploaded to Azure and Azure VM can be created with it.
#script must run on server where Hyper-V role is installed.
$path = '\\Server01\d$\Temp\disk01.vhd'
$vhd = get-vhd -Path $path
#Get VHD size in MB
$vhdsize = ($vhd.size / 1MB)
#Set new size. Round up to next Whole MB. If existing size is 52130.1MB, new size will be 52131MB.
$newsize = [math]::ceiling($vhdsize)
#conver to bytes
$newsize = ($newsize *1024 *1024)
#resize
Resize-VHD -Path $path -SizeBytes $newsize
Write-Host 'Resize completed!'