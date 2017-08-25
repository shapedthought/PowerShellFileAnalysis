# PowerShell file analysis project 
Last modified: 25/08/17- see commit changes for latest.

This is a project that I have started to help me do file analysis for file systems, this is an alternative to using proprietary tools that require sign up and don’t gather some relevant data such as directory depth and directory structure. 
It is early days at the moment and there are several scripts that do slightly different things. As my knowledge grows in PowerShell my aim is to consolidate this into a single multi-purpose script. 

### Current scripts

1.	File Breakdown- Created, this scans the file system and creates a percentage breakdown of the age of the files. 
2.	File Breakdown- Modified, this is the same as the modified version but does this by the date modified.
3.	File information- Long, this provides the total used capacity of the file system, total files, total folders and max path length. It is designed to read a text file with the list of shares on each line so multiple disks and shares can be scanned. It also outputs the findings into a text file. 
4.	File information- Short, this does the same as the long version but only shows the total amount of files. I’ve done this as the long version has to scan the file system twice. 

### Recent changes

I have recently added a progress bar to the ‘Created’ script, this will be added to the ‘Modified’ script shortly. 
### Short term planned changes

I am planning to add the ability to do pre-scan to determine the capacity of the file system and quantity of files. It will then let you opt to reduce the scope of the scan if only a sub-section is needed. This will be more useful when I add some of the changes below. 

Single pass scan for breakdown of files and directories.

### Future changes
1.	Average file size
2.	Max file size
3.	Break down of files by extension 
4.	Directory tree
