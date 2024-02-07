$DestLocalPath = "" #Write here the path to your folder containing the Obsidian database.
$PathToFolder= "" #Here's the full path to your Obsidian base
$Date = Get-Date -Format "dd/MM/yyyy"
$DestinationPath = "C:\Users\Kitoyama\Desktop\docks\.ob_base_$Date.zip" #Before _$Date.zip, paste the full path to your Obsidian database
$DeleteDateLocalFiles = (Get-Date).AddDays(-3)
$YandexCloud = "C:\Users\Kitoyama\YandexDisk\Backups" 
$DeleteDate = (Get-Date).AddDays(-10)

Compress-Archive -Path $PathToFolder -DestinationPath $DestinationPath -Force #Create Archive

$ObjectToDelete = Get-ChildItem -Path $DestLocalPath | ? {$_.Name -like ".ob_base*.zip" -and $_.CreationTime -lt $DeleteDateLocalFiles} -ErrorAction SilentlyContinue #Get too old archive

#Check and delete or not older archive
if ($ObjectToDelete) {
    $ObjectToDelete | % {
        $FileToDelete = $_
        Remove-Item $FileToDelete -WhatIf
        Write-Host "I'm delete $FileToDelete older archive" -ForegroundColor Green
    }
} else {
    Write-Host  "I'm not find older archive. Nothing to Delete" -ForegroundColor Yellow
}
        
Copy-Item -Path $DestinationPath -Destination $YandexCloud -Force #Copy to yandex Disk, when it has locally path

$YandexCloudDeleteObject = Get-ChildItem -LiteralPath $YandexCloud #Get oldet object on your Yandex Disk

#Check and delete older archive on Yandex Disk
$YandexCloudDeleteObject | % {
    $FileOnYandexCloud = $_
    if ($FileOnYandexCloud.CreationTime -lt $DeleteDate) {
        Remove-Item $FileOnYandexCloud
        Write-Host "$FileOnYandexCloud has been deleted" -ForegroundColor Green
    } else {
        Write-Host "$FileOnYandexCloud not too old to delete" -ForegroundColor Yellow
    }
}
