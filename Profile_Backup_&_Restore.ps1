


function Show-Menu
     {
          param (
                [string]$Title = 'Choose a Profile Operation'
          )
       cls
       Write-Host  -ForegroundColor Cyan "================ $Title ================"
            
       Write-Host "1: Press '1' To Backup a profile"
       Write-Host "2: Press '2' to Restore a profile"
       Write-Host "3: Press '3' to Cleanup all profile backups"
                 
       Write-Host "Q: Press 'Q' to quit."
     }
        
###################################### Script Functions ##################################################
        
     Function BackupProfile {


###################################### Prompt for user to backup ##################################################

        $Profiles = Get-ChildItem "C:\Users" | Select Name
        Write-Host "Select Profile to backup"
        $menu = @{}
        for ($i=1;$i -le $Profiles.count; $i++) 
            { Write-Host "$i. $($Profiles[$i-1].name),$($Profiles[$i-1].status)" 
                $menu.Add($i,($Profiles[$i-1].name))}

        [int]$ans = Read-Host 'Enter selection'
        $selection = $menu.Item($ans) ; 

        

        Write-Host  -ForegroundColor Cyan "Cleaning up temp files................"
        

###################################### Delete Temp File Directories ##################################################

$delete = "C:\Users\$selection\AppData\Local\Google\Chrome\User Data\Default\Cache\*",
          "C:\Users\$selection\AppData\Local\Google\Chrome\User Data\Default\Code Cache\",
          "C:\Users\$selection\AppData\Local\Google\Chrome\User Data\Default\Service Worker\ScriptCache",
          "C:\Users\$selection\AppData\Local\Google\Chrome\User Data\Profile 1\Cache\",
          "C:\Users\$selection\AppData\Local\Google\Chrome\User Data\Profile 1\Code Cache\",
          "C:\Users\$selection\AppData\Local\Google\Chrome\User Data\Profile 1\Service Worker\ScriptCache",
          "C:\Users\$selection\AppData\Local\Mozilla\Firefox\Profiles\*.default\cache",
          "C:\Users\$selection\AppData\Local\Mozilla\Firefox\Profiles\*.default\cache2",
          "C:\Users\$selection\Downloads"

        Write-Host -ForegroundColor Cyan "Begin Browser Cleanup"
        Get-ChildItem -Path $delete  -ErrorAction SilentlyContinue | Remove-Item -Verbose -Recurse -Force
        New-Item -ItemType "directory" -Path "c:\temp" -ErrorAction SilentlyContinue
        New-Item -ItemType "directory" -Path "c:\temp\Profiles\.donotdelete" -ErrorAction SilentlyContinue
        

###################################### Backing Up Profile ############################## 
        
        
$folder = "Desktop",
          "Favorites",
          "Documents",
          "Pictures",
          "AppData\Local\Google\Chrome\User Data",
          "AppData\Local\Mozilla\Firefox\Profiles",
          "AppData\Roaming\Mozilla\Firefox"

$destination = "C:\temp\Profiles\$selection"

Write-Host ""
Write-Host ""
Write-Host ""
Write-Host -ForegroundColor green "Backing up data from local machine for $selection"


###################################### Backup Loop   ################################### 

ForEach ($f in $folder) {

    Copy-Item -Path "C:\Users\$selection\$f" -Destination ($destination + "\" + $f) -recurse -ErrorAction silentlyContinue 
    write-host "$f Backup Complete"
   
 
    }
    
    Write-Host  -ForegroundColor green "Backup Complete" 
    Remove-Variable * -ErrorAction SilentlyContinue

}

 
 
Function RestoreProfile {


###################################### Prompt for user to Restore ##################################################
        cls
        Write-Host ""
        Write-Host ""
        Write-Host ""
        $DestProfiles = Get-ChildItem "C:\users" | Select Name
        Write-Host -ForegroundColor green "Select User to restore"
        $menu = @{}
        for ($i=1;$i -le $DestProfiles.count; $i++) 
            { Write-Host "$i. $($DestProfiles[$i-1].name),$($DestProfiles[$i-1].status)" 
                $menu.Add($i,($DestProfiles[$i-1].name))}

        [int]$ans = Read-Host 'Enter selection'
        $selection = $menu.Item($ans) ; 

                cls
        Write-Host ""
        Write-Host ""
        Write-Host ""
        $SourceProfiles = Get-ChildItem "C:\temp\Profiles" | Select Name
        New-Item -ItemType "directory" -Path "c:\temp\Profiles\.donotdelete" -ErrorAction SilentlyContinue
        Write-Host -ForegroundColor green "Select Source User Profile"
        $menu = @{}
        for ($i=1;$i -le $SourceProfiles.count; $i++) 
            { Write-Host "$i. $($SourceProfiles[$i-1].name),$($SourceProfiles[$i-1].status)" 
                $menu.Add($i,($SourceProfiles[$i-1].name))}

        [int]$ans = Read-Host 'Enter selection'
        $SourceSelection = $menu.Item($ans) ; 
       

        
        
        
$folder = "Downloads",
          "Desktop",
          "Favorites",
          "Documents",
          "Pictures",
          "AppData\Local\Google\Chrome\User Data",
          "AppData\Local\Mozilla\Firefox\Profiles",
          "AppData\Roaming\Mozilla\Firefox"


cls
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host -ForegroundColor green "Restoring data from local machine for $selection"





###################################### Restore Loop   ################################### 

ForEach ($f in $folder) {
    
    Robocopy "C:\temp\Profiles\$SourceSelection\$f" "C:\Users\$selection\$f" /E /S

    }
    
    Write-Host  -ForegroundColor green "Restore Complete" 
    Write-Host ""
    Write-Host ""
    Write-Host ""
    Remove-Variable * -ErrorAction SilentlyContinue

}        


Function CleanupBackups {

    Write-Host -ForegroundColor red "Cleaning up temp profile backups"
    remove-item -path "c:\temp\Profiles" -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host ""
    Write-Host ""
    Write-Host ""
    Write-Host -ForegroundColor cyan "Cleanup Completed"

}


 #Main menu loop
     do
     {
          Show-Menu
          $input = Read-Host "Please make a selection"
          switch ($input)
          {
                '1' {
                     cls
                     BackupProfile
                }
                '2' {
                     cls
                     RestoreProfile
                } 
                '3' {
                     cls
                     CleanupBackups
                } 
                'q' {
                     return
                }
          
        }  pause
     }
     until ($input -eq 'q')










