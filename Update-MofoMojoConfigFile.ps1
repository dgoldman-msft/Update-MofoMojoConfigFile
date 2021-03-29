function Update-MofoMojoConfigFile {
    <#
    .SYNOPSIS
        Update the MofoMojoMod configuration file
    
    .DESCRIPTION
        This function will allow you to change settings in the MofoMojoMod.cfg file
    
    .PARAMETER SettingsToUpdate
        The settings you wish to change
    
    .PARAMETER Enable
        Set values to true for enabled
    
    .PARAMETER Disable
        Set values to falase for disabled
    
    .EXAMPLE
        Update-MofoMojoMod -Enabled -Settings to update DisableImACheater

    .EXAMPLE
        Update-MofoMojoMod -Enabled -Settings to update DisableImACheater, EnableFishingRodRecipe
    
    .NOTES
        None

    #>
    [CmdletBinding()]
    param (
        
        [Parameter(Position = 0)]
        [ValidateSet('DisableImACheater', 'EnableFishingRodRecipe', 'EnableBaitRecipe', 'EnableLoxMeatSurprise', 'EnableChainsRecipe', 'EnableBronzeTweak', 'EnableGuardStoneTweak', 'EnableFeatherMultiplier', 'EnableFishingInOceanMultiplier', 'RemeberLastConnectedIpEnabled')]
        [object[]]
        $SettingstoUpdate,

        [Parameter(Position = 1, ParameterSetName = 'Flag')]
        [switch]
        $Enable,

        [Parameter(Position = 1, ParameterSetName = 'Flag')]
        [switch]
        $Disable,

        [switch]
        $OpenConfigFoler
    )
    
    begin {
        $ConfigFolderPath = '\Thunderstore Mod Manager\DataFolder\Valheim\profiles\Default\BepInEx\Config\'
        $ConfigFileName = 'MofoMojo.cfg'
        $PathToConfigFile = Join-Path $env:APPDATA -ChildPath $ConfigFolderPath
    }
    
    process {
        $parameters = $PSBoundParameters

        if ($OpenConfigFoler) {
            Invoke-Item -Path $PathToConfigFile
            return
        }

        if ($SettingsToUpdate) {
            $oldCfgFile = @()
            try {
					
                if ( Test-Path -Path (Join-Path -Path $PathToConfigFile -ChildPath $ConfigFileName -ErrorAction Stop) ) {
                    $script:oldCfgFile = Get-Content -Path (join-path -Path $PathToConfigFile -ChildPath $ConfigFileName) -Raw                    
                    # Save original configuration file first before making changes
                    $index = (Get-ChildItem -Path $PathToConfigFile -Filter MofoMojo.cfg.bak* -ErrorAction Stop).count
                    Rename-Item -Path (Join-Path -Path $PathToConfigFile -ChildPath $ConfigFileName) -NewName "MofoMojo.cfg.bak($index)" -force -ErrorAction Stop
                }
                else {
                    Write-Host "$ConfigFileName not found! Exiting."
                    return
                }
            }
            catch {
                Write-Host -ForegroundColor Red "ERROR: " $($error[0].Exception.Message)
            }

            Set-ConfigurationSetting @parameters
            
            try {
                Set-Content -Path ($PathToConfigFile + $ConfigFileName) -Value $script:oldCfgFile -Encoding UTF8 -Force
                Write-Host "Config file: $($ConfigFileName) updated!"
            }
            catch {
                Write-Host -ForegroundColor Red "ERROR: " $($error[0].Exception.Message)
            }
        }
        else {
            Write-Host "Grabbing config file: $($ConfigFileName) - read only."
            # We are just viewing the configuration settings only
            
            try {
                $contents = Get-Content -Path ($PathToConfigFile + $ConfigFileName) -ErrorAction Stop

                foreach ($line in $contents) {
                    if (($line -notmatch '^\w') -or ($line -eq "")) { } else {
                        $lineContents = $line -split ' '
                        [PSCustomObject]@{
                            Setting = $lineContents[0]
                            Value   = $lineContents[2]  
`                       }
                    }
                }
            }
            catch {
                Write-Host -ForegroundColor Red "ERROR: " $($error[0].Exception.Message)
            }
        }
       
    }
}

function Set-ConfigurationSetting {
    <#
    .SYNOPSIS
        Enables or disables a setting
    
    .DESCRIPTION
        This function will loop through all of the settings a user wants to change and enable or disable them
    
    .PARAMETER SettingstoUpdate
        The setting(s) to be enabled or disabled
    
    .PARAMETER Enable
        Enable flag
    
    .PARAMETER Disable
        Disable flag
    
    .NOTES
        This is the main helper function
    #>

    [CmdletBinding()]
    param (
        [object[]]
        $SettingstoUpdate,

        [switch]
        $Enable,
        
        [switch]
        $Disable
    )

    process {
        foreach ($value in $SettingsToUpdate) {
            if ($Enable) {
                $script:oldCfgFile = $script:oldCfgFile.Replace("$value = false", "$value = true")
                $oldsetting = $false
                $newSetting = $true
            }
            if ($Disable) {
                $script:oldCfgFile = $script:oldCfgFile.Replace("$value = true", "$value = false")
                $oldsetting = $true
                $newSetting = $false 
            }   
        
            [PSCustomObject] @{
                Setting     = $value
                'Old Value' = $oldSetting
                'New Value' = $newSetting
            }
        }
        Format-Table
    }
}