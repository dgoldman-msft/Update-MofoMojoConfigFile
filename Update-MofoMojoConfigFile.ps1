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
        [ValidateSet('DisableImACheater', 'EnableFishingRodRecipe', 'EnableLoxMeatSurprise', 'EnableChainsRecipe', 'EnableGuardStoneTweak', 'EnableFeatherMultiplier', 'RemeberLastConnectedIpEnabled')]
        [object[]]
        $SettingstoUpdate,

        [Parameter(Position = 1)]
        [switch]
        $Enable,

        [Parameter(Position = 1)]
        [switch]
        $Disable
    )
    
    begin {
        $ConfigFolderPath = '\Thunderstore Mod Manager\DataFolder\Valheim\profiles\Default\BepInEx\Config\'
        $ConfigFileName = 'MofoMojo.cfg'
        $PathToConfigFile = Join-Path $env:APPDATA -ChildPath $ConfigFolderPath
    }
    
    process {
        if ($SettingsToUpdate) {
            $newCfgFile = ""
            if ( Test-Path -Path (Join-Path -Path $PathToConfigFile -ChildPath $ConfigFileName) ) {
                $oldCfgFile = Get-Content -Path (join-path -Path $PathToConfigFile -ChildPath $ConfigFileName)

                # Save original configuration file first before making changes
                $index = (Get-ChildItem -Path $PathToConfigFile -Filter MofoMojo.cfg.bak*).count
                Rename-Item -Path (join-path -Path $PathToConfigFile -ChildPath $ConfigFileName) -NewName "MofoMojo.cfg.bak($index)" -force
            }
            else {
                Write-Host "$ConfigFileName not found! Exiting."
                return
            }

            foreach ($setting in $SettingsToUpdate) {
                
                switch ($setting) {
                    "DisableImACheater" {
                        if ($Enable) { $newCfgFile = $oldCfgFile.Replace('DisableImACheater = false', 'DisableImACheater = true') }
                        if ($Disable) { $newCfgFile = $oldCfgFile.Replace('DisableImACheater = true', 'DisableImACheater = false') }
                        break
                    } 
    
                    "EnableFishingRodRecipe" {
                        if ($Enable) { $newCfgFile = $oldCfgFile.Replace('EnableFishingRodRecipe = false', 'EnableFishingRodRecipe = true') }
                        if ($Disable) { $newCfgFile = $oldCfgFile.Replace('EnableFishingRodRecipe = true', 'EnableFishingRodRecipe = false') }
                        break
                    }
    
                    "EnableLoxMeatSurprise" {
                        if ($Enable) { $newCfgFile = $oldCfgFile.Replace('EnableLoxMeatSurprise = false', 'EnableLoxMeatSurprise = true') }
                        if ($Disable) { $newCfgFile = $oldCfgFile.Replace('EnableLoxMeatSurprise = true', 'EnableLoxMeatSurprise = false') }
                        break
                    }
    
                    "EnableChainsRecipe" {
                        if ($Enable) { $newCfgFile = $oldCfgFile.Replace('EnableChainsRecipe = false', 'EnableChainsRecipe = true') }
                        if ($Disable) { $newCfgFile = $oldCfgFile.Replace('EnableChainsRecipe = true', 'EnableChainsRecipe = false') }
                        break
                    }
    
                    "EnableGuardStoneTweak" {
                        if ($Enable) { $newCfgFile = $oldCfgFile.Replace('EnableGuardStoneTweak = false', 'EnableGuardStoneTweak = true') }
                        if ($Disable) { $newCfgFile = $oldCfgFile.Replace('EnableGuardStoneTweak = true', 'EnableGuardStoneTweak = false') }
                        break
                    }
    
                    "EnableFeatherMultiplier" {
                        if ($Enable) { $newCfgFile = $oldCfgFile.Replace('EnableFeatherMultiplier = false', 'EnableFeatherMultiplier = true') }
                        if ($Disable) { $newCfgFile = $oldCfgFile.Replace('EnableFeatherMultiplier = true', 'EnableFeatherMultiplier = false') }
                        break
                    }
    
                    "RemeberLastConnectedIpEnabled" {
                        if ($Enable) { $newCfgFile = $oldCfgFile.Replace('RemeberLastConnectedIpEnabled = false', 'RemeberLastConnectedIpEnabled = true') }
                        if ($Disable) { $newCfgFile = $oldCfgFile.Replace('RemeberLastConnectedIpEnabled = true', 'RemeberLastConnectedIpEnabled = false') }
                        break
                    }
                        
                    default { Write-Host "No values changed." }
                }
            }
            

            Set-Content -Path ($PathToConfigFile + $ConfigFileName) -Value $newCfgFile -Encoding UTF8 -Force
            Write-Host "Config file: $($ConfigFileName) updated!"
        }
        else {
            # We are just viewing the configuration settings only
            Write-Host "Grabbing config file: $($ConfigFileName) - read only."
            Get-Content -Path ($PathToConfigFile + $ConfigFileName) 
        }
    }
    
    end {
        Write-Host "Finished."
    }
}
