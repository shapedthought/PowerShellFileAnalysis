#FileAssessment Script written by Ed Howard @ CDW 21/08/17 e.howard@uk.cdw.com 

$OutFile = Read-Host -Prompt "Enter Output path e.g C:\Users\name\output.txt"
$Directory = Read-Host -Prompt "Enter the location of the directory text file"

$directories = Get-Content $Directory
$Capacity = "Total Used Capacity"
$TotalFiles = "Total Files"
$TotalDir = "Total Dir"
$LongPath = "Longest Path"

$directories | ForEach-Object {

$hello = "Assessment for $_";
$hello | Out-File -Append $Outfile;

$Capacity | Out-File -Append $Outfile;
Write-Host "Getting used capacity GB";
$Cap = (Get-ChildItem $_ -Recurse -Force | Measure-Object -Sum length).sum / 1GB;
$Cap | Out-File -Append $Outfile;
Write-Host "Capacity of " $_ " is " $Cap " GB.";

$TotalFiles | Out-File -Append $Outfile;
Write-Host "Getting the total files for" $_ ". This may take a while.";

$TotalFiles2 = Get-ChildItem $_ -Recurse -File -Force | Measure-Object | %{$_.Count};
$TotalFiles2 | Out-File -Append $OutFile; 
Write-Host "Total Files for" $_ "is" $TotalFiles2;

Write-Host "Getting the total folders for" $_;
$TotalDir | Out-File -Append $Outfile;
$TotalDir2 = Get-ChildItem $_ -Recurse -Directory -Force | Measure-Object | %{$_.Count};
$TotalDir2 | Out-File -Append $OutFile; 
Write-Host "Total Folders for " $_ "is" $TotalDir2; 

Write-Host "Getting the max path depth for" $_;
$LongPath | Out-File -Append $Outfile;
$LongPath2 = Get-ChildItem $_ -Recurse -Force | Select-Object FullName | Sort length | select -first 1;
$LongPath2 | Out-File -Append $OutFile;
$LongPath2 | Measure-Object FullName -Character | Out-File -Append $OutFile;
Write-Host "The Longest Path for " $_ " is " $LongPath2;
}

Write-Host "All done!"
Start-Sleep -s 10