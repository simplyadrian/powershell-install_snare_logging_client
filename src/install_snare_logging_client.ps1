# Powershell 2.0

# Stop and fail script when a command fails.
$errorActionPreference = "Stop"

# load library functions
$rsLibDstDirPath = "$env:rs_sandbox_home\RightScript\lib"
. "$rsLibDstDirPath\tools\PsOutput.ps1"
. "$rsLibDstDirPath\tools\ResolveError.ps1"
. "$rsLibDstDirPath\win\Version.ps1"

try
{
    $snare_path = join-path $env:programfiles "Snare"
    
    if (test-path $snare_path)
    {
        Write-Output "Snare already installed. Skipping installation."
        exit 0
    }

    Write-Host "Installing Snare to $snare_path"

    $snare_binary = "SnareForWindows-4.0.1.2a-MultiArch.exe"
    cd "$env:RS_ATTACH_DIR"
    cmd /c $snare_binary /VerySilent

    #Permanently update windows Path
    if (Test-Path $snare_path) {
        [environment]::SetEnvironmentvariable("PATH", $env:PATH+";"+$snare_path, "Machine")
    } 
    Else 
    {
        throw "Failed to install Snare. Aborting."
    }
    
    #Add snare registry.
    $snare_reg = "snare-registry.reg"
    cd "$env:RS_ATTACH_DIR"
    regedit.exe /S $snare_reg

}
catch
{
    ResolveError
    exit 1
}
