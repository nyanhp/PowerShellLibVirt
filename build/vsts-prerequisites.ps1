param (
    [string]
    $Repository = 'PSGallery'
)

$modules = @("Pester", "PSFramework", "PSModuleDevelopment", "PSScriptAnalyzer", "PlatyPs")

# Automatically add missing dependencies
$data = Import-PowerShellDataFile -Path "$PSScriptRoot\..\PoshLibVirt\PoshLibVirt.psd1"
foreach ($dependency in $data.RequiredModules) {
    if ($dependency -is [string]) {
        if ($modules -contains $dependency) { continue }
        $modules += $dependency
    }
    else {
        if ($modules -contains $dependency.ModuleName) { continue }
        $modules += $dependency.ModuleName
    }
}

foreach ($module in $modules) {
    Write-Host "Installing $module" -ForegroundColor Cyan
    Install-Module $module -Force -SkipPublisherCheck -Repository $Repository
    Import-Module $module -Force -PassThru
}

dotnet build "$PSScriptRoot\..\library\PoshLibVirt"
foreach ($heeeeelp in (Get-ChildItem -Directory -Path "$PSScriptRoot\..\docs"))
{
    New-ExternalHelp -Path $heeeeelp.FullName -OutputPath "$PSScriptRoot\..\PoshLibVirt\$($heeeeelp.BaseName)" -Force
}
