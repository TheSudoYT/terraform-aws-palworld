# Get the current working directory
$currentDirectory = $PWD.Path

# Run terraform init and terraform test in the root directory
Write-Host "Running terraform init in root directory"
terraform init
Write-Host "Running terraform test in root directory"
terraform test

# Change directory to the modules directory
Set-Location -Path "$currentDirectory\modules"

# Loop through each subdirectory in the modules directory
Get-ChildItem -Directory | ForEach-Object {
    $dir = $_.FullName
    Set-Location -Path $dir
    
    if (Test-Path -Path "main.tf") {
        Write-Host "Running terraform init in $dir"
        terraform init
        Write-Host "Running terraform test in $dir"
        terraform test
    }
    else {
        Write-Host "$dir is not a Terraform module, skipping..."
    }
    Set-Location -Path ..
}

#Notes:
# powershell -ExecutionPolicy Bypass -File powershell-test.ps1
