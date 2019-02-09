#File Anaylsis toolkit- Ed Howard exfhoward@protonmail.com

#Inital scan of file system

$dirLoc = Read-Host -Prompt "Enter the file system location"
Write-Host "Pre-scan please wait...."

$files = Get-ChildItem $dirLoc -File -Recurse

#Total used capacity

$cap = ($files | Measure-Object -Sum length).sum / 1GB

Write-Host "Total Used Capacity is" ("{0:N4} GB" -f $cap)
Write-Host ""

#Largest file

$largestFile = ($files | Sort-Object length -Descending | Select-Object -first 1).FullName
$largestFileCap = ($files | Select-Object length | Sort-Object length -Descending | Select-Object -first 1).length / 1GB
Write-Host "Largest file is" $largestFile "at" ("{0:N2} GB" -f $largestFileCap)
Write-Host ""

#Average file size

$averageFile = ($files | Measure-Object -Property length -Average).Average / 1GB 
Write-Host "Average File size is" ("{0:N4} GB" -f $averageFile)
Write-Host ""

#Longest pathname
$longPath = $files | Select-Object FullName | Sort-Object length | Select-Object -first 1;
Write-Host "Longest Path is" $longPath
Write-Host ""

#Date calculations

$date = Get-Date
$dateDay = $date.AddHours(-24)
$dateWeek = $date.AddDays(-7)
$dateMonth = $date.AddMonths(-1)
$date6months = $date.AddMonths(-6)

#Get the file count for Creation Time in each timeframe

$CtotalFiles = $files | Measure-Object | ForEach-Object{$_.Count}

$CdateDay = $files | Where-Object {$_.CreationTime -ge $dateDay } | Measure-Object | ForEach-Object{$_.Count}
$CdateDay1Cap = ($files | Where-Object {$_.CreationTime -ge $dateDay } | Measure-Object -Sum length).sum /1GB

$CdateWeek1 = $files | Where-Object {$_.CreationTime -ge $dateWeek -and $_.CreationTime -lt $dateDay } | Measure-Object | ForEach-Object{$_.Count}
$CdateWeek1Cap = ($files | Where-Object {$_.CreationTime -ge $dateWeek -and $_.CreationTime -lt $dateDay } | Measure-Object -Sum length).sum /1GB

$CdateMonths = $files | Where-Object {$_.CreationTime -ge $dateMonth -and $_.CreationTime -lt $dateWeek } | Measure-Object | ForEach-Object{$_.Count}
$CdateMonthsCap = ($files | Where-Object {$_.CreationTime -ge $dateMonth -and $_.CreationTime -lt $dateWeek } | Measure-Object -Sum length).sum / 1GB

$Cdate6Months1 = $files | Where-Object {$_.CreationTime -ge $date6Months -and $_.CreationTime -lt $dateMonth } | Measure-Object | ForEach-Object{$_.Count}
$Cdate6Months1Cap = ($files | Where-Object {$_.CreationTime -ge $date6Months -and $_.CreationTime -lt $dateMonth } | Measure-Object -Sum length).sum / 1GB

$Cdate6MonthsPlus = $files | Where-Object {$_.CreationTime -lt $date6Months } | Measure-Object | ForEach-Object{$_.Count}
$Cdate6MonthsPlusCap = ($files | Where-Object {$_.CreationTime -lt $date6Months } | Measure-Object -Sum length).sum / 1GB


#Calculations for Creation Time each timeframe

Write-Host "Created file info" -ForegroundColor Cyan
Write-Host "Total Files:" $CtotalFiles
Write-Host "Lastd day"("{0:P2}" -f (($CdateDay / $CtotalFiles))) "Files:" $CdateDay "Capacity:" ("{0:N4} GB" -f $CdateDay1Cap) "Cap percetage" ("{0:P4}" -f ($CdateDay1Cap / $cap))
Write-Host "Last week"("{0:P2}" -f (($CdateWeek1 / $CtotalFiles))) "Files:" $CdateWeek1 "Capacity:" ("{0:N4} GB" -f $CdateWeek1Cap) "Cap percetage" ("{0:P4}" -f ($CdateWeek1Cap / $cap))
Write-Host "Last Month"("{0:P2}" -f (($CdateMonths / $CtotalFiles))) "Files:" $CdateMonths "Capacity:" ("{0:N4} GB" -f $CdateMonthsCap) "Cap percetage" ("{0:P4}" -f ($CdateMonthsCap / $cap))
Write-Host "Last 6 Months"("{0:P2}" -f (($Cdate6Months1 / $CtotalFiles))) "Files:" $Cdate6months1 "Capacity:" ("{0:N4} GB" -f $Cdate6Months1Cap) "Cap percetage" ("{0:P4}" -f (($Cdate6Months1Cap / $cap)))
Write-Host "Older than 6 Months"("{0:P2}" -f ($Cdate6MonthsPlus / $CtotalFiles)) "Files:" $Cdate6MonthsPlus "Capacity:" ("{0:N4} GB" -f $Cdate6MonthsPlusCap) "Cap percetage" ("{0:P4}" -f ($Cdate6MonthsPlusCap / $cap))

#Error check

$check = ($CtotalFiles - ($CdateDay + $CdateWeek1 + $CdateMonths + $Cdate6months1 + $Cdate6MonthsPlus))
if ($check -eq 0) { Write-Host "Error Check: All is good" } else { Write-Host "Error Check: ERROR missing" $check "files" }
$checkCap = ($cap - ($CdateDay1Cap + $CdateWeek1Cap + $CdateMonthsCap + $Cdate6Months1Cap + $Cdate6MonthsPlusCap))
if ($checkCap -eq 0) { Write-Host "Cap check: All is good" } else { Write-Host "Cap Check: Error missing" $checkCap "GB" }

#Get the file count for Modified in each timeframe

$MtotalFiles = $files | Measure-Object | ForEach-Object{$_.Count}

$MdateDay = $files | Where-Object {$_.LastWriteTime -ge $dateDay } | Measure-Object | ForEach-Object{$_.Count}
$MdateDayCap = ($files | Where-Object {$_.LastWriteTime -ge $dateDay } | Measure-Object -Sum length).sum /1GB

$MdateWeek1 = $files | Where-Object {$_.LastWriteTime -ge $dateWeek -and $_.LastWriteTime -lt $dateDay} | Measure-Object | ForEach-Object{$_.Count}
$MdateWeek1Cap = ($files | Where-Object {$_.LastWriteTime -ge $dateWeek -and $_.LastWriteTime -lt $dateDay } | Measure-Object -Sum length).sum /1GB

$MdateMonths = $files | Where-Object {$_.LastWriteTime -ge $dateMonth -and $_.LastWriteTime -lt $dateWeek } | Measure-Object | ForEach-Object{$_.Count}
$MdateMonthsCap = ($files | Where-Object {$_.LastWriteTime -ge $dateMonth -and $_.CreationTime -lt $dateWeek } | Measure-Object -Sum length).sum / 1GB

$Mdate6Months1 = $files | Where-Object {$_.LastWriteTime -ge $date6Months -and $_.LastWriteTime -lt $dateMonth } | Measure-Object | ForEach-Object{$_.Count}
$Mdate6Months1Cap = ($files | Where-Object {$_.LastWriteTime -ge $date6Months -and $_.CreationTime -lt $dateMonth } | Measure-Object -Sum length).sum / 1GB

$Mdate6MonthsPlus = $files | Where-Object {$_.LastWriteTime -lt $date6Months } | Measure-Object | ForEach-Object{$_.Count}
$Mdate6MonthsPlusCap = ($files | Where-Object {$_.LastWriteTime -lt $date6Months } | Measure-Object -Sum length).sum / 1GB

#Calculations for Modified in each timeframe

Write-Host ""
Write-Host "Modified file info" -ForegroundColor Cyan
Write-Host "Total Files:" $MtotalFiles
Write-Host "Last Day"("{0:P2}" -f ($MdateDay / $MtotalFiles)) "Files:" $MdateDay "Capacity:" ("{0:N4} GB" -f $MdateDayCap) "Cap percetage" ("{0:P4}" -f ($MdateDayCap / $cap))
Write-Host "Last week"("{0:P2}" -f ($MdateWeek1 / $MtotalFiles)) "Files:" $MdateWeek1 "Capacity:" ("{0:N4} GB" -f $MdateWeek1Cap) "Cap percetage" ("{0:P4}" -f ($MdateWeek1Cap / $cap))
Write-Host "Last Month"("{0:P2}" -f ($MdateMonths / $MtotalFiles)) "Files:" $MdateMonths "Capacity:" ("{0:N4} GB" -f $MdateMonthsCap) "Cap percetage" ("{0:P4}" -f ($MdateMonthsCap / $cap))
Write-Host "Last 6 Months"("{0:P2}" -f ($Mdate6Months1 / $MtotalFiles)) " Files:" $Mdate6months1 "Capacity:" ("{0:N4} GB" -f $Mdate6Months1Cap) "Cap percetage" ("{0:P4}" -f (($Mdate6Months1Cap / $cap)))
Write-Host "Older than 6 Months"("{0:P2}" -f ($Mdate6MonthsPlus / $MtotalFiles)) "Files:" $Mdate6MonthsPlus "Capacity:" ("{0:N4} GB" -f $Mdate6MonthsPlusCap) "Cap percetage" ("{0:P4}" -f ($Mdate6MonthsPlusCap / $cap))

#Error check

$check = ($MtotalFiles - ($MdateWeek1 + $MdateMonths + $Mdate6months1 + $Mdate6MonthsPlus))
if ($check -eq 0) { Write-Host "Error Check: All is good" } else { Write-Host "Error Check: ERROR missing" $check "files" }
$checkCap = ($cap - ($MdateWeek1Cap + $MdateMonthsCap + $Mdate6Months1Cap + $Mdate6MonthsPlusCap))
if ($checkCap -eq 0) { Write-Host "Cap check: All is good" } else { Write-Host "Cap Check: Error missing" $checkCap "GB" }



#Get the file count for Last Access time in each timeframe

$AtotalFiles = $files | Measure-Object | ForEach-Object{$_.Count}

$AdateDay1 = $files | Where-Object {$_.LastAccessTime -ge $dateDay } | Measure-Object | ForEach-Object{$_.Count}
$AdateDay1Cap = ($files | Where-Object {$_.LastAccessTime -ge $dateDay } | Measure-Object -Sum length).sum /1GB

$AdateWeek1 = $files | Where-Object {$_.LastAccessTime -ge $dateWeek } | Measure-Object | ForEach-Object{$_.Count}
$AdateWeek1Cap = ($files | Where-Object {$_.LastAccessTime -ge $dateWeek } | Measure-Object -Sum length).sum /1GB

$AdateMonths = $files | Where-Object {$_.LastAccessTime -ge $dateMonth -and $_.LastAccessTime -lt $dateWeek } | Measure-Object | ForEach-Object{$_.Count}
$AdateMonthsCap = ($files | Where-Object {$_.LastAccessTime -ge $dateMonth -and $_.CreationTime -lt $dateWeek } | Measure-Object -Sum length).sum / 1GB

$Adate6Months1 = $files | Where-Object {$_.LastAccessTime -ge $date6Months -and $_.LastAccessTime -lt $dateMonth } | Measure-Object | ForEach-Object{$_.Count}
$Adate6Months1Cap = ($files | Where-Object {$_.LastAccessTime -ge $date6Months -and $_.CreationTime -lt $dateMonth } | Measure-Object -Sum length).sum / 1GB

$Adate6MonthsPlus = $files | Where-Object {$_.LastAccessTime -lt $date6Months } | Measure-Object | ForEach-Object{$_.Count}
$Adate6MonthsPlusCap = ($files | Where-Object {$_.LastAccessTime -lt $date6Months } | Measure-Object -Sum length).sum / 1GB

#Calculations for Last Access time in each timeframe

Write-Host ""
Write-Host "Access time file info" -ForegroundColor Cyan
Write-Host "Total Files:" $AtotalFiles
Write-Host "Last week"("{0:P2}" -f ($AdateDay1 / $AtotalFiles)) "Files:" $AdateDay1 "Capacity:" ("{0:N4} GB" -f $AdateDay1Cap) "Cap percetage" ("{0:P4}" -f ($AdateDay1Cap / $cap))
Write-Host "Last week"("{0:P2}" -f ($AdateWeek1 / $AtotalFiles)) "Files:" $AdateWeek1 "Capacity:" ("{0:N4} GB" -f $AdateWeek1Cap) "Cap percetage" ("{0:P4}" -f ($AdateWeek1Cap / $cap))
Write-Host "Last Month"("{0:P2}" -f ($AdateMonths / $AtotalFiles)) "Files:" $AdateMonths "Capacity:" ("{0:N4} GB" -f $AdateMonthsCap) "Cap percetage" ("{0:P4}" -f ($AdateMonthsCap / $cap))
Write-Host "Last 6 Months"("{0:P2}" -f ($Adate6Months1 / $AtotalFiles)) "Files:" $Adate6months1 "Capacity:" ("{0:N4} GB" -f $Adate6Months1Cap) "Cap percetage" ("{0:P4}" -f (($Adate6Months1Cap / $cap)))
Write-Host "Older than 6 Months"("{0:P2}" -f ($Adate6MonthsPlus / $AtotalFiles)) "Files:" $Adate6MonthsPlus "Capacity:" ("{0:N4} GB" -f $Adate6MonthsPlusCap) "Cap percetage" ("{0:P4}" -f ($Adate6MonthsPlusCap / $cap))

#Error check

$check = ($AtotalFiles - ($AdateDay1 + $AdateWeek1 + $AdateMonths + $Adate6months1 + $Adate6MonthsPlus))
if ($check -eq 0) { Write-Host "Error Check: All is good" } else { Write-Host "Error Check: ERROR missing" $check "files" }
$checkCap = ($cap - ($AdateDay1Cap + $AdateWeek1Cap + $AdateMonthsCap + $Adate6Months1Cap + $Adate6MonthsPlusCap))
if ($checkCap -eq 0) { Write-Host "Cap check: All is good" } else { Write-Host "Cap Check: Error missing" $checkCap "GB" }

#File Breakdown
Write-Host ""
Write-Host "Quantity of files by extension"
$files | Group-Object Extension -NoElement | Sort-Object count -desc
Write-Host "All-Done"
Start-Sleep 100

