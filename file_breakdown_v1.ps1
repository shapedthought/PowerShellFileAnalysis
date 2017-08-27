﻿#calculates the percentage of files changed in the three time frames

#Inital scan of file system

$dirLoc = Read-Host -Prompt "Enter the file system location"
$i = 1
Write-Host "Pre-scan please wait...."

$files = Get-ChildItem $dirLoc -File -Recurse

$files | ForEach-Object {
    Write-Progress -Activity "Scanning file $($_.name)" -Status "File $i of $($files.Count)" -PercentComplete (($i / $files.Count) * 100)
    $i++
}

Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""

#Total used capacity

$cap = ($files | Measure-Object -Sum length).sum / 1GB

Write-Host "Total Used Capacity is" $cap "GB"
Write-Host ""

#Largest file

$largestFile = ($files | Sort length -Descending | Select-Object -first 1).FullName
$largestFileCap = ($files | Select-Object length | Sort length -Descending | select -first 1).length / 1GB
Write-Host "Largest file is" $largestFile "at" $largestFileCap "GB"
Write-Host ""

#Average file size

$averageFile = ($files | Measure-Object -Property length -Average).Average / 1GB 
Write-Host "Average File size is" $averageFile "GB"
Write-Host ""

#Longest pathname
$longPath = $files | Select-Object FullName | Sort length | select -first 1;
Write-Host "Longest Path is" $longPath
Write-Host ""

#Date calculations

$date = Get-Date
$dateWeek = $date.AddDays(-7)
$dateMonth = $date.AddMonths(-1)
$date6months = $date.AddMonths(-6)

#Get the file count for Creation Time in each timeframe

$CtotalFiles = $files | Measure-Object | %{$_.Count}

$CdateWeek1 = $files | Where-Object {$_.CreationTime -ge $dateWeek } | Measure-Object | %{$_.Count}
$CdateWeek1Cap = ($files | Where-Object {$_.CreationTime -ge $dateWeek } | Measure-Object -Sum length).sum /1GB

$CdateMonths = $files | Where-Object {$_.CreationTime -ge $dateMonth -and $_.CreationTime -lt $dateWeek } | Measure-Object | %{$_.Count}
$CdateMonthsCap = ($files | Where-Object {$_.CreationTime -ge $dateMonth -and $_.CreationTime -lt $dateWeek } | Measure-Object -Sum length).sum / 1GB

$Cdate6Months1 = $files | Where-Object {$_.CreationTime -ge $date6Months -and $_.CreationTime -lt $dateMonth } | Measure-Object | %{$_.Count}
$Cdate6Months1Cap = ($files | Where-Object {$_.CreationTime -ge $date6Months -and $_.CreationTime -lt $dateMonth } | Measure-Object -Sum length).sum / 1GB

$Cdate6MonthsPlus = $files | Where-Object {$_.CreationTime -lt $date6Months } | Measure-Object | %{$_.Count}
$Cdate6MonthsPlusCap = ($files | Where-Object {$_.CreationTime -lt $date6Months } | Measure-Object -Sum length).sum / 1GB


#Calculations for Creation Time each timeframe

Write-Host "Created file info" -ForegroundColor Cyan
Write-Host "Total Files:" $CtotalFiles
Write-Host "Last week"("{0:P2}" -f (($CdateWeek1 / $CtotalFiles))) "Files:" $CdateWeek1 "Capacity:" ("{0:N4} GB" -f $CdateWeek1Cap) "Cap percetage" ("{0:P4}" -f ($CdateWeek1Cap / $cap))
Write-Host "Last Month"("{0:P2}" -f (($CdateMonths / $CtotalFiles))) "Files:" $CdateMonths "Capacity:" ("{0:N4} GB" -f $CdateMonthsCap) "Cap percetage" ("{0:P4}" -f ($CdateMonthsCap / $cap))
Write-Host "Last 6 Months"("{0:P2}" -f (($Cdate6Months1 / $CtotalFiles))) "Files:" $Cdate6months1 "Capacity:" ("{0:N4} GB" -f $Cdate6Months1Cap) "Cap percetage" ("{0:P4}" -f (($Cdate6Months1Cap / $cap)))
Write-Host "Older than 6 Months"("{0:P2}" -f ($Cdate6MonthsPlus / $CtotalFiles)) "Files:" $Cdate6MonthsPlus "Capacity:" ("{0:N4} GB" -f $Cdate6MonthsPlusCap) "Cap percetage" ("{0:P4}" -f ($Cdate6MonthsPlusCap / $cap))

#Error check

$check = ($CtotalFiles - ($CdateWeek1 + $CdateMonths + $Cdate6months1 + $Cdate6MonthsPlus))
$check2 = if ($check -eq 0) { Write-Host "Error Check: All is good" } else { Write-Host "Error Check: ERROR missing" $check "files" }

#Get the file count for Modified in each timeframe

$MtotalFiles = $files | Measure-Object | %{$_.Count}
$MdateWeek1 = $files | Where-Object {$_.LastWriteTime -ge $dateWeek } | Measure-Object | %{$_.Count}
$MdateMonths = $files | Where-Object {$_.LastWriteTime -ge $dateMonth -and $_.LastWriteTime -lt $dateWeek } | Measure-Object | %{$_.Count}
$Mdate6Months1 = $files | Where-Object {$_.LastWriteTime -ge $date6Months -and $_.LastWriteTime -lt $dateMonth } | Measure-Object | %{$_.Count}
$Mdate6MonthsPlus = $files | Where-Object {$_.LastWriteTime -lt $date6Months } | Measure-Object | %{$_.Count}

#Calculations for Modified in each timeframe

Write-Host ""
Write-Host "Modified file info" -ForegroundColor Cyan
Write-Host "Total Files:" $MtotalFiles
Write-Host "Last week"(($MdateWeek1 / $MtotalFiles)*100) "%. Files:" $MdateWeek1
Write-Host "Last Month"(($MdateMonths / $MtotalFiles)*100) "%. Files:" $MdateMonths
Write-Host "Last 6 Months"(($Mdate6Months1 / $MtotalFiles)*100) "%. Files:" $Mdate6months1
Write-Host "Older than 6 Months"(($Mdate6MonthsPlus / $MtotalFiles)*100) "%. File:" $Mdate6MonthsPlus

#Error check

$check = ($MtotalFiles - ($MdateWeek1 + $MdateMonths + $Mdate6months1 + $Mdate6MonthsPlus))
$check2 = if ($check -eq 0) { Write-Host "Error Check: All is good" } else { Write-Host "Error Check: ERROR missing" $check "files" }




#Get the file count for Last Access time in each timeframe

$AtotalFiles = $files | Measure-Object | %{$_.Count}
$AdateWeek1 = $files | Where-Object {$_.LastAccessTime -ge $dateWeek } | Measure-Object | %{$_.Count}
$AdateMonths = $files | Where-Object {$_.LastAccessTime -ge $dateMonth -and $_.LastAccessTime -lt $dateWeek } | Measure-Object | %{$_.Count}
$Adate6Months1 = $files | Where-Object {$_.LastAccessTime -ge $date6Months -and $_.LastAccessTime -lt $dateMonth } | Measure-Object | %{$_.Count}
$Adate6MonthsPlus = $files | Where-Object {$_.LastAccessTime -lt $date6Months } | Measure-Object | %{$_.Count}


#Calculations for Last Access time in each timeframe

Write-Host ""
Write-Host "Access time file info" -ForegroundColor Cyan
Write-Host "Total Files:" $AtotalFiles
Write-Host "Last week"(($AdateWeek1 / $AtotalFiles)*100) "%. Files:" $AdateWeek1
Write-Host "Last Month"(($AdateMonths / $AtotalFiles)*100) "%. Files:" $AdateMonths
Write-Host "Last 6 Months"(($Adate6Months1 / $AtotalFiles)*100) "%. Files:" $Adate6months1
Write-Host "Older than 6 Months"(($Adate6MonthsPlus / $AtotalFiles)*100) "%. File:" $Adate6MonthsPlus

#Error check

$check = ($AtotalFiles - ($AdateWeek1 + $AdateMonths + $Adate6months1 + $Adate6MonthsPlus))
$check2 = if ($check -eq 0) { Write-Host "Error Check: All is good" } else { Write-Host "Error Check: ERROR missing" $check "files" }

#File Breakdown
Write-Host ""
Write-Host "Quantity of files by extension"
$files | group Extension -NoElement | sort count -desc


Write-Host "All-Done"
Start-Sleep 100

