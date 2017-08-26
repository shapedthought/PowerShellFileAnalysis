#calculates the percentage of files changed in the three time frames

#Inital scan of file system

$dirLoc = Read-Host -Prompt "Enter the file system location"
$i = 1
Write-Host "Pre-scan please wait...."

$files = Get-ChildItem $dirLoc -File -Recurse

$files | ForEach-Object {
    Write-Progress -Activity "Scanning file $($_.name)" -Status "File $i of $($files.Count)" -PercentComplete (($i / $files.Count) * 100)
    $i++
}

Write-Host "."
Write-Host "."
Write-Host "."
Write-Host "."
Write-Host "."
Write-Host "."

#Total used capacity

$cap = ($files | Measure-Object -Sum length).sum / 1GB

Write-Host "Total Used Capacity is" $cap "GB"
Write-Host ".................."

#Largest file

$largestFile = $files | Select-Object FullName | Sort length -Descending | select -first 1
$largestFileCap = ($files | Select-Object length | Sort length -Descending | select -first 1).length / 1GB
Write-Host "Largest file is" $largestFile "at" $largestFileCap "THIS IS INCORRECT AT THE MOMENT, WORKING ON IT"
Write-Host ".................."

#Average file size

$averageFile = ($files | Measure-Object -Property length -Average).Average / 1GB
Write-Host "Average File size is" $averageFile "GB"
Write-Host ".................."

#Date calculations

$date = Get-Date
$dateWeek = $date.AddDays(-7)
$dateMonth = $date.AddMonths(-1)
$date6months = $date.AddMonths(-6)

#Get the file count for Creation Time in each timeframe

$CtotalFiles = $files | Measure-Object | %{$_.Count}
$CdateWeek1 = $files | Where-Object {$_.CreationTime -ge $dateWeek } | Measure-Object | %{$_.Count}
$CdateMonths = $files | Where-Object {$_.CreationTime -ge $dateMonth -and $_.CreationTime -lt $dateWeek } | Measure-Object | %{$_.Count}
$Cdate6Months1 = $files | Where-Object {$_.CreationTime -ge $date6Months -and $_.CreationTime -lt $dateMonth } | Measure-Object | %{$_.Count}
$Cdate6MonthsPlus = $files | Where-Object {$_.CreationTime -lt $date6Months } | Measure-Object | %{$_.Count}

#Calculations for Creation Time each timeframe

Write-Host "Created file info"
Write-Host "Total Files:" $CtotalFiles
Write-Host "Last week"(($CdateWeek1 / $CtotalFiles)*100) "%. Files:" $CdateWeek1
Write-Host "Last Month"(($CdateMonths / $CtotalFiles)*100) "%. Files:" $CdateMonths
Write-Host "Last 6 Months"(($Cdate6Months1 / $CtotalFiles)*100) "%. Files:" $Cdate6months1
Write-Host "Older than 6 Months"(($Cdate6MonthsPlus / $CtotalFiles)*100) "%. Files:" $Cdate6MonthsPlus

#Error check

$check = ($CtotalFiles - ($CdateWeek1 + $CdateMonths + $Cdate6months1 + $Cdate6MonthsPlus))
$check2 = if ($check -eq 0) { Write-Host "Error Check: All is good" } else { Write-Host "Error Check: ERROR missing" $check "files"}

#Get the file count for Modified in each timeframe

$MtotalFiles = $files | Measure-Object | %{$_.Count}
$MdateWeek1 = $files | Where-Object {$_.LastWriteTime -ge $dateWeek } | Measure-Object | %{$_.Count}
$MdateMonths = $files | Where-Object {$_.LastWriteTime -ge $dateMonth -and $_.LastWriteTime -lt $dateWeek } | Measure-Object | %{$_.Count}
$Mdate6Months1 = $files | Where-Object {$_.LastWriteTime -ge $date6Months -and $_.LastWriteTime -lt $dateMonth } | Measure-Object | %{$_.Count}
$Mdate6MonthsPlus = $files | Where-Object {$_.LastWriteTime -lt $date6Months } | Measure-Object | %{$_.Count}

#Calculations for Modified in each timeframe

Write-Host ".................."
Write-Host "Modified file info"
Write-Host "Total Files:" $MtotalFiles
Write-Host "Last week"(($MdateWeek1 / $MtotalFiles)*100) "%. Files:" $MdateWeek1
Write-Host "Last Month"(($MdateMonths / $MtotalFiles)*100) "%. Files:" $MdateMonths
Write-Host "Last 6 Months"(($Mdate6Months1 / $MtotalFiles)*100) "%. Files:" $Mdate6months1
Write-Host "Older than 6 Months"(($Mdate6MonthsPlus / $MtotalFiles)*100) "%. File:" $Mdate6MonthsPlus

#Error check

$check = ($MtotalFiles - ($MdateWeek1 + $MdateMonths + $Mdate6months1 + $Mdate6MonthsPlus))
$check2 = if ($check -eq 0) { Write-Host "Error Check: All is good" } else { Write-Host "Error Check: ERROR missing" $check "files"}




#Get the file count for Last Access time in each timeframe

$AtotalFiles = $files | Measure-Object | %{$_.Count}
$AdateWeek1 = $files | Where-Object {$_.LastAccessTime -ge $dateWeek } | Measure-Object | %{$_.Count}
$AdateMonths = $files | Where-Object {$_.LastAccessTime -ge $dateMonth -and $_.LastAccessTime -lt $dateWeek } | Measure-Object | %{$_.Count}
$Adate6Months1 = $files | Where-Object {$_.LastAccessTime -ge $date6Months -and $_.LastAccessTime -lt $dateMonth } | Measure-Object | %{$_.Count}
$Adate6MonthsPlus = $files | Where-Object {$_.LastAccessTime -lt $date6Months } | Measure-Object | %{$_.Count}


#Calculations for Last Access time in each timeframe

Write-Host ".................."
Write-Host "Access time file info"
Write-Host "Total Files:" $AtotalFiles
Write-Host "Last week"(($AdateWeek1 / $AtotalFiles)*100) "%. Files:" $AdateWeek1
Write-Host "Last Month"(($AdateMonths / $AtotalFiles)*100) "%. Files:" $AdateMonths
Write-Host "Last 6 Months"(($Adate6Months1 / $AtotalFiles)*100) "%. Files:" $Adate6months1
Write-Host "Older than 6 Months"(($Adate6MonthsPlus / $AtotalFiles)*100) "%. File:" $Adate6MonthsPlus

#Error check

$check = ($AtotalFiles - ($AdateWeek1 + $AdateMonths + $Adate6months1 + $Adate6MonthsPlus))
$check2 = if ($check -eq 0) { Write-Host "Error Check: All is good" } else { Write-Host "Error Check: ERROR missing" $check "files"}


Write-Host "All-Done"
Start-Sleep 100

