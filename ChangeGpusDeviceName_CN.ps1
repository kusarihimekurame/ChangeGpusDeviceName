Write-Host ""
Write-Host "此脚本是通过修改注册表来切换显卡驱动名字, 让A卡伪装成N卡" 
Write-Host "能让A卡在绝区零v3.0中开启光追"
Write-Host ""
Write-Host "警告："
Write-Host "本脚本会修改 Windows 注册表中的显卡设备信息。"
Write-Host "错误操作可能导致驱动异常，请自行承担风险。"
Write-Host ""
Write-Host "1. 切换到N卡"
Write-Host "2. 还原到A卡"
Write-Host "3. 退出"
Write-Host ""

do
{
	
	$Choice = Read-Host "请输入对应操作的序号"
} 
until (
			$Choice -match '^\d+$' -and
			[int]$Choice -ge 1 -and
			[int]$Choice -le 3
)

switch ($Choice)
{
	"1" {
		Write-Host "开始切换..."
		$Gpus = Get-PnpDevice -Class Display

		Write-Host ""
		Write-Host "检测到以下显卡："
		Write-Host ""

		for ($i = 0; $i -lt $Gpus.Count; $i++)
		{
			Write-Host "$($i + 1).$($Gpus[$i].FriendlyName)"
		}

		Write-Host ""

		do
		{
			$Choice = Read-Host "请输入对应显卡序号"
		}
		until (
			$Choice -match '^\d+$' -and
			[int]$Choice -ge 1 -and
			[int]$Choice -le $Gpus.Count
		)

		$SelectedGpu = $Gpus[[int]$Choice - 1]

		Write-Host ""
		Write-Host "已选择：$($SelectedGpu.FriendlyName)"
		Write-Host "设备实例路径："
		Write-Host $SelectedGpu.InstanceId
		Write-Host ""

		if ($SelectedGpu.FriendlyName -eq "NVIDIA GeForce RTX 4090")
		{
			Write-Host "检查到已经是N卡, 无需切换"
			Read-Host "按回车键关闭"
			return
		}
		else
		{
			$RegPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\$($SelectedGpu.InstanceId)"

			$CurrentValue = (Get-ItemProperty -Path $RegPath -Name DeviceDesc -ErrorAction SilentlyContinue).DeviceDesc
			if ([string]::IsNullOrEmpty($CurrentValue))
			{
				Write-Host "未找到DeviceDesc值, 无法切换"
				Read-Host "按回车键关闭"
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

			Write-Host "成功修改显卡驱动DeviceDesc值为`"NVIDIA GeForce RTX 4090`""
			Write-Host "原来的显卡驱动的DeviceDesc值`"$CurrentValue`"已经备份到DeviceDesc_Backup中"
			Write-Host "需要重新启动电脑才能生效"
			Read-Host "按回车键关闭"
			return
		}
	}

	"2" {
		Write-Host "开始恢复..."
		$Gpus = Get-PnpDevice -Class Display
		$Gpu = $Gpus | where-object {
			$_.FriendlyName -eq "NVIDIA GeForce RTX 4090"
		} | select-object -First 1

		if ($null -eq $Gpu)
		{
			Write-Host ""
			Write-Host "未检测到切换后的N卡, 此脚本切换后的显卡名称固定为`"NVIDIA GeForce RTX 4090`""
			Read-Host "按回车键关闭"
			return
		}
		else
		{
			$RegPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\$($Gpu.InstanceId)"

			$BackupValue = (Get-ItemProperty -Path $RegPath -Name DeviceDesc_Backup -ErrorAction SilentlyContinue).DeviceDesc_Backup
			if ([string]::IsNullOrEmpty($BackupValue))
			{
				Write-Host "未找到备份值，无法恢复"
				Read-Host "按回车键关闭"
				return
			}

			Set-ItemProperty -Path $RegPath -Name DeviceDesc -Value $BackupValue

			Write-Host ""
			Write-Host "已恢复：$BackupValue"
			Write-Host "需要重启电脑才能生效"
			Read-Host "按回车键关闭"

			return
		}
	}

	"3" {
		Write-Host "已退出"
		return
	}
}
