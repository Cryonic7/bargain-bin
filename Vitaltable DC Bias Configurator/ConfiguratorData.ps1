Set-ExecutionPolicy -Scope CurrentUser unrestricted
cls
$done = $FALSE
$Scriptdir = $PSScriptRoot
$target = $Scriptdir
while($done -eq $FALSE){
    $title = "VitalTable DC Bias Configurator V1.0"
    $message = "`nMain Menu`nChoose what file, or files, that you would like to convert using the options below!`n`nDefault target is the folder that the script resides in, a.k.a. every .vitaltable file that is in the same folder.`nCurrent Target is: " + $target + "\`n`n"
    #options:
    ##set target
    ##Turn DC Bias ON for target
    ##Turn DC Bias OFF for target
    ##exit

    #Options builder thingy start
    $OpSetTarget = New-Object System.Management.Automation.Host.ChoiceDescription "Set &Target.", `
    "Set a new target file or folder to convert.`n    If a single file is chosen, no other nearby files should be affected.`n"

    $OpBiasON = New-Object System.Management.Automation.Host.ChoiceDescription "Turn DC Bias O&N for target.", `
    "Turns DC Bias ON for the target specified by the file or folder path.`n"

    $OpBiasOFF = New-Object System.Management.Automation.Host.ChoiceDescription "Turn DC Bias O&FF for target.", `
    "Turns DC Bias OFF for the target specified by the file or folder path.`n"

    $OpExit = New-Object System.Management.Automation.Host.ChoiceDescription "E&xit the program.", `
    "Exits the program"

    #End of options builder
    ##Aux options
    $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes"
    $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No"
    
    #UI Prompt start
    $options = [System.Management.Automation.Host.ChoiceDescription[]]($OpSetTarget, $OpBiasON, $OpBiasOFF, $OpExit)
    $prompt = $Host.UI.PromptForChoice($title, $message, $options, 3)
    #UI Prompt end

    #main switch
    switch ($prompt)
    {
        ##Set Target File
        0{
            cls
            Write-Host "`nYou are currently changing the target`n`n"
            Write-Host ("Current Target is:`n>  " + $target + "\")
            Write-Host "`nWhat file would you like to change the target to?`nTo target a file, include the Filename and full extension (e.g. `"C:\path\path\ABCD00.vitaltable`")`nTo target a folder, just leave it at the path, with nothing after the last slash! (e.g. `"C:\path\path\`")`n"
            $newTarget = Read-Host -Prompt "[Drive]:/[Path]/[Filename].vitaltable"
            $newTarget = ($newTarget -replace "`"", "")
            if($newTarget -eq ""){
                Write-Host "`nFound empty string. Handling exception, and returning to main menu...`n"
                pause
                cls
                Break
            }
            if(-Not (Test-Path "$newTarget")){
                Write-Host "`nFatal Error: I can't seem to find that file, or it doesn't exist!`nReturning to main menu...`n"
                pause
                cls
                Break               
            } else{
                Write-Host "`nNew Target Successfully set! Committing changes, and returning to main menu...`n"
                $target = "$newTarget"
                pause
                cls                
                Break
            }
        }
        #done with set file

        ##Turn Bias ON
        1{
            cls
            #check if sure
            $confirmTitle = "`nYou're about to turn DC Bias ON for the targeted file or folders."
            $confirm = [System.Management.Automation.Host.ChoiceDescription[]]($yes,$no)
            $check = $Host.UI.PromptForChoice($confirmTitle,"`nAre You sure? [Y/N]: ",$confirm, 0)
            switch ($check){
                #yes
                0{
                    Write-Host "`nTurning on DC Bias..."

                    #this area needs to detect if file or if folder?
                    
                    #for single FILE 
                    if (Test-Path -Path $target -PathType Leaf) {
                        Write-Host "`nTarget found as type FILE. Enabling DC Bias for single file..."
                        ((Get-Content $target -Raw) -replace '"remove_all_dc":true','"remove_all_dc":false') | Set-Content $target
                        Write-Host "`n`nDone."
                        pause
                        cls
                        Break
                    }else{
                   
                    #for whole FOLDER
                    if (Test-Path -Path $target -PathType Container) {
                        Write-Host "`nTarget found as type FOLDER. Enabling DC Bias for all files within..."
                        Write-Host "`nGetting files..."
                        $files = Get-ChildItem -Path $target\* -Include *.vitaltable
                        Write-Host "`Applying...`n"
                        foreach ($i in $files){
                            Write-Host $i " - DC Bias Enabled"
                            ((Get-Content $i -Raw) -replace '"remove_all_dc":true','"remove_all_dc":false') | Set-Content $i
                        }
                        Write-Host "`n`nDone. Returning to main menu...`n"
                        pause
                        cls
                        Break
                    }else{
                    Write-Host "if you see this text, something has gone horribly wrong"
                    }}
                }
                #no
                1{
                    Write-Host "`nAborted. Returning to main menu...`n"
                    pause
                    cls
                    Break
                }
            }
        }
        #done with turn on bias

        ##Turn Bias OFF
        2{
            cls
            #check if sure
            $confirmTitle = "`nYou're about to turn DC Bias OFF for the targeted file or folders."
            $confirm = [System.Management.Automation.Host.ChoiceDescription[]]($yes,$no)
            $check = $Host.UI.PromptForChoice($confirmTitle,"`nAre You sure? [Y/N]: ",$confirm, 0)
            switch ($check){
                #yes
                0{
                    Write-Host "`nTurning off DC Bias..."

                    #this area needs to detect if file or if folder?
                    
                    #for single FILE 
                    if (Test-Path -Path $target -PathType Leaf) {
                        Write-Host "`nTarget found as type FILE. Disabling DC Bias for single file..."
                        ((Get-Content $target -Raw) -replace '"remove_all_dc":false','"remove_all_dc":true') | Set-Content $target
                        Write-Host "`n`nDone."
                        pause
                        cls
                        Break
                    }else{
                   
                    #for whole FOLDER
                    if (Test-Path -Path $target -PathType Container) {
                        Write-Host "`nTarget found as type FOLDER. Disabling DC Bias for all files within..."
                        Write-Host "`nGetting files..."
                        $files = Get-ChildItem -Path $target\* -Include *.vitaltable
                        Write-Host "`Applying...`n"
                        foreach ($i in $files){
                            Write-Host $i " - DC Bias Disabled"
                            ((Get-Content $i -Raw) -replace '"remove_all_dc":false','"remove_all_dc":true') | Set-Content $i
                        }
                        Write-Host "`n`nDone. Returning to main menu...`n"
                        pause
                        cls
                        Break
                    }else{
                    Write-Host "if you see this text, something has gone horribly wrong"
                    }}
                }
                #no
                1{
                    Write-Host "`nAborted. Returning to main menu...`n"
                    pause
                    cls
                    Break
                }
            }
        }
        # done with turn off bias
        
        ##Exit Program
        3{
            Write-Host "Thanks for using my tool! Have a wonderful day!`n"
            $done = $TRUE
            Break
        }
        #done with exit
    }
}