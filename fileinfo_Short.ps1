Write-Host "FileAssessment Script written by Ed Howard @ CDW 21/08/17 e.howard@uk.cdw.com"

$OutFile = Read-Host -Prompt "Enter Output path e.g C:\Users\name\output.txt"
$Directory = Read-Host -Prompt "Enter the location of the directory text file"

$directories = Get-Content $Directory
$TotalObjects = "Total Objects"
$LongPath = "Longest Path"
$Capacity = "Used Capacity:"

$directories | ForEach-Object {

Write-Host "Scanning" $_ "please wait...";
$Data = Get-ChildItem $_ -Recurse -Force;

$hello = "Assessment for $_";
$hello | Out-File -Append $Outfile;

$Capacity | Out-File -Append $Outfile;
$Cap = ($Data | Measure-Object -Sum length).sum / 1GB;
$Cap | Out-File -Append $Outfile;
Write-Host "Capacity of " $_ " is " $Cap " GB.";

$TotalObjects | Out-File -Append $Outfile;
$TotalObjects2 = $Data | Measure-Object | %{$_.Count};
$TotalObjects2 | Out-File -Append $OutFile; 
Write-Host "Total Objects in " $_ " is " $TotalObjects2;

$LongPath | Out-File -Append $Outfile;
$FullName = $Data | Select-Object FullName | Sort length | select -first 1 
$FullName | Out-File -Append $OutFile;
$FullName | Measure-Object FullName -Character | Out-File -Append $OutFile;
Write-Host "The Longest Path is " $FullName;

Write-Host "Done " $_;

}

Write-Host "Finished at last!"
Start-Sleep -s 10