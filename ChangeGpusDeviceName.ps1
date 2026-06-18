Write-Host ""
Write-Host "AMD GPU to NVIDIA GPU Name Switcher"
Write-Host "Allows AMD GPUs to use Ray Tracing in Zenless Zone Zero"
Write-Host ""

Write-Host "Warning:"
Write-Host "This script modifies Windows registry entries related to display devices."
Write-Host "Incorrect operations may cause driver issues. Use at your own risk."
Write-Host ""

Write-Host "1. Switch to NVIDIA"
Write-Host "2. Restore AMD"
Write-Host "3. Exit"
Write-Host ""

do
{
	
	$Choice = Read-Host "Enter the operation number"
} 
until (
			$Choice -match '^\d+$' -and
			[int]$Choice -ge 1 -and
			[int]$Choice -le 3
)

switch ($Choice)
{
	"1" {
		Write-Host ""
		Write-Host "Changing GPU name to NVIDIA GeForce RTX 4090..."
		$Gpus = Get-PnpDevice -Class Display

		Write-Host ""
		Write-Host "Detected GPUs:"
		Write-Host ""

		for ($i = 0; $i -lt $Gpus.Count; $i++)
		{
			Write-Host "$($i + 1).$($Gpus[$i].FriendlyName)"
		}

		Write-Host ""

		do
		{
			$Choice = Read-Host "Enter the GPU number"
		}
		until (
			$Choice -match '^\d+$' -and
			[int]$Choice -ge 1 -and
			[int]$Choice -le $Gpus.Count
		)

		$SelectedGpu = $Gpus[[int]$Choice - 1]

		Write-Host ""
		Write-Host "Selected GPU:$($SelectedGpu.FriendlyName)"
		Write-Host "Device Instance Path:"
		Write-Host $SelectedGpu.InstanceId
		Write-Host ""

		if ($SelectedGpu.FriendlyName -eq "NVIDIA GeForce RTX 4090")
		{
			Write-Host "The selected GPU is already set as NVIDIA. No changes are required."
			Read-Host "Press Enter to exit"
			return
		}
		else
		{
			$RegPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\$($SelectedGpu.InstanceId)"

			$CurrentValue = (Get-ItemProperty -Path $RegPath -Name DeviceDesc -ErrorAction SilentlyContinue).DeviceDesc
			if ([string]::IsNullOrEmpty($CurrentValue))
			{
				Write-Host "DeviceDesc was not found. Unable to continue."
				Read-Host "Press Enter to exit"
				return
			}

			New-ItemProperty `
				-Path $RegPath `
				-Name DeviceDesc_Backup `
				-Value $CurrentValue `
				-PropertyType String `
				-Force | Out-Null

			Set-ItemProperty `
				-Path $RegPath `
				-Name DeviceDesc `
				-Value "NVIDIA GeForce RTX 4090"

			Write-Host "Successfully changed DeviceDesc to `"NVIDIA GeForce RTX 4090`""
			Write-Host "Original DeviceDesc value `"$CurrentValue`" has been backed up to DeviceDesc_Backup."
			Write-Host "A system restart is required for the change to take effect."
			Read-Host "Press Enter to exit"
			return
		}
	}

	"2" {
		Write-Host "Restoring original GPU name..."
		$Gpus = Get-PnpDevice -Class Display
		$Gpu = $Gpus | where-object {
			$_.FriendlyName -eq "NVIDIA GeForce RTX 4090"
		} | select-object -First 1

		if ($null -eq $Gpu)
		{
			Write-Host ""
			Write-Host "No GPU named `"NVIDIA GeForce RTX 4090`" was found."
			Write-Host "This script only restores GPUs previously modified by this tool."
			Read-Host "Press Enter to exit"
			return
		}
		else
		{
			$RegPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\$($Gpu.InstanceId)"

			$BackupValue = (Get-ItemProperty -Path $RegPath -Name DeviceDesc_Backup -ErrorAction SilentlyContinue).DeviceDesc_Backup
			if ([string]::IsNullOrEmpty($BackupValue))
			{
				Write-Host "DeviceDesc_Backup was not found. Unable to restore."
				Read-Host "Press Enter to exit"
				return
			}

			Set-ItemProperty -Path $RegPath -Name DeviceDesc -Value $BackupValue

			Write-Host ""
			Write-Host "Successfully restored: $BackupValue"
			Write-Host "A system restart is required for the change to take effect."
			Read-Host "Press Enter to exit"

			return
		}
	}

	"3" {
		Write-Host "Exiting..."
		return
	}
}
