#calculates the percentage of files changed in the three time frames

#Inital scan of file system

$dirLoc = Read-Host -Prompt "Enter the file system location"

Write-Host "Scanning, please wait..."

$files = Get-ChildItem $dirLoc -File -Recurse

#Date calculations

$date = Get-Date
$dateWeek = $date.AddDays(-7)
$dateMonth = $date.AddMonths(-1)
$date6months = $date.AddMonths(-6)

#Get the file count for each timeframe

$totalFiles = $files | Measure-Object | %{$_.Count}
$dateWeek1 = $files | Where-Object {$_.LastWriteTime -ge $dateWeek } | Measure-Object | %{$_.Count}
$dateMonths = $files | Where-Object {$_.LastWriteTime -ge $dateMonth -and $_.CreationTime -lt $dateWeek } | Measure-Object | %{$_.Count}
$date6Months1 = $files | Where-Object {$_.LastWriteTime -ge $date6Months -and $_.CreationTime -lt $dateMonth } | Measure-Object | %{$_.Count}
$date6MonthsPlus = $files | Where-Object {$_.LastWriteTime -lt $date6Months } | Measure-Object | %{$_.Count}

#Calculations for each timeframe

Write-Host "Total Files:" $totalFiles
Write-Host "Last week"(($dateWeek1 / $totalFiles)*100) "%. Files:" $dateWeek1
Write-Host "Last Month"(($dateMonths / $totalFiles)*100) "%. Files:" $dateMonths
Write-Host "Last 6 Months"(($date6Months1 / $totalFiles)*100) "%. Files:" $date6months1
Write-Host "Older than 6 Months"(($date6MonthsPlus / $totalFiles)*100) "%. File:" $date6MonthsPlus

#Error check

$check = ($totalFiles - ($dateWeek1 + $dateMonths + $date6months1 + $date6MonthsPlus))
$check2 = if ($check -eq 0) { Write-Host "Error Check: All is good" } else { Write-Host "Error Check: ERROR missing" $check "files"}

Write-Host "All done!"
Start-Sleep -s 10