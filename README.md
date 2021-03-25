# Update-MofoMojoConfigFile

1. Put this script in a directory
2. Dot Source the script in to your current PowerShell session . .\Update-MofoMojoConfigFile.ps1
3. Run one of the examples below to get started!

EXAMPLE
> Update-MofoMojoConfigFile -SettingsToUpdate DisableImACheater -Enable or - Disable

In this example you can select multiple options by hitting CTRL + Spacebar or typing them out and pass them in as a collection to set each one

EXAMPLE
> Update-MofoMojoConfigFile -SettingsToUpdate DisableImACheater EnableFishingRodRecipe -Enable or - Disable

Single update example
> Update-MofoMojoConfigFile -SettingsToUpdate DisableImACheater -Enable or - Disable

Multiple update example
> Update-MofoMojoConfigFile -SettingsToUpdate DisableImACheater, EnableFishingRodRecipe -Enable or - Disable

Enjoy!