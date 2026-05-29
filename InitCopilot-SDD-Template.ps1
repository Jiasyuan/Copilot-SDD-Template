
param (
    [Parameter(Mandatory = $true)]
    [string]$TargetPath,

    [Parameter(Mandatory = $true)]
    [string]$SolutionName
)

# =====================================
# Script Root
# =====================================

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

# =====================================
# Template Source
# =====================================

$sourcePath = Join-Path $scriptRoot "FolderStructure"

if (!(Test-Path $sourcePath)) {
    Write-Host "Source path not found: $sourcePath" -ForegroundColor Red
    exit 1
}

# =====================================
# Create Target Folder
# =====================================

if (!(Test-Path $TargetPath)) {
    New-Item -ItemType Directory -Path $TargetPath | Out-Null
    Write-Host "Created target folder: $TargetPath" -ForegroundColor Green
}

# =====================================
# Copy Template
# =====================================

Copy-Item -Path "$sourcePath\*" -Destination $TargetPath -Recurse -Force

Write-Host ""
Write-Host "Template copied successfully!" -ForegroundColor Cyan

# =====================================
# Backend Paths
# =====================================

$backendPath = Join-Path $TargetPath "Backend"

if (!(Test-Path $backendPath)) {
    Write-Host "Backend folder not found: $backendPath" -ForegroundColor Red
    exit 1
}

$srcPath = Join-Path $backendPath "src"
$testsPath = Join-Path $backendPath "tests"
$dbPath = Join-Path $backendPath "DB"

# =====================================
# Create Backend Folders
# =====================================

New-Item -ItemType Directory -Path $srcPath -Force | Out-Null
New-Item -ItemType Directory -Path $testsPath -Force | Out-Null
New-Item -ItemType Directory -Path $dbPath -Force | Out-Null

Write-Host ""
Write-Host "Created folders:" -ForegroundColor Green
Write-Host "- src"
Write-Host "- tests"
Write-Host "- DB"

# =====================================
# Create Solution
# =====================================

Set-Location $backendPath

dotnet new sln -n $SolutionName

Write-Host ""
Write-Host "Solution created: $SolutionName.sln" -ForegroundColor Cyan

# =====================================
# Project Names
# =====================================

$applicationProject = "$SolutionName.Application"
$domainProject = "$SolutionName.Domain"
$infrastructureProject = "$SolutionName.Infrastructure"
$webApiProject = "$SolutionName.WebApi"

# Test Projects
$applicationTestProject = "$SolutionName.Application.Tests"
$domainTestProject = "$SolutionName.Domain.Tests"
$infrastructureTestProject = "$SolutionName.Infrastructure.Tests"
$webApiTestProject = "$SolutionName.WebApi.Tests"

# Shared Project
$sharedUtilityProject = "JiaSyuan.Utility"

# =====================================
# Create Source Projects
# =====================================

Set-Location $srcPath

dotnet new classlib -n $applicationProject
dotnet new classlib -n $domainProject
dotnet new classlib -n $infrastructureProject
dotnet new webapi -n $webApiProject

Write-Host ""
Write-Host "Source projects created successfully!" -ForegroundColor Cyan

# =====================================
# Create Test Projects
# =====================================

Set-Location $testsPath

dotnet new xunit -n $applicationTestProject
dotnet new xunit -n $domainTestProject
dotnet new xunit -n $infrastructureTestProject
dotnet new xunit -n $webApiTestProject

Write-Host ""
Write-Host "Test projects created successfully!" -ForegroundColor Cyan

# =====================================
# Add Projects To Solution
# =====================================

Set-Location $backendPath

# Source Projects
dotnet sln add ".\src\$applicationProject\$applicationProject.csproj"
dotnet sln add ".\src\$domainProject\$domainProject.csproj"
dotnet sln add ".\src\$infrastructureProject\$infrastructureProject.csproj"
dotnet sln add ".\src\$webApiProject\$webApiProject.csproj"

# Test Projects
dotnet sln add ".\tests\$applicationTestProject\$applicationTestProject.csproj"
dotnet sln add ".\tests\$domainTestProject\$domainTestProject.csproj"
dotnet sln add ".\tests\$infrastructureTestProject\$infrastructureTestProject.csproj"
dotnet sln add ".\tests\$webApiTestProject\$webApiTestProject.csproj"

Write-Host ""
Write-Host "Projects added to solution!" -ForegroundColor Cyan

# =====================================
# Add Shared Project
# =====================================

$sharedUtilityProjectPath = ".\shared\$sharedUtilityProject\$sharedUtilityProject.csproj"

if (Test-Path $sharedUtilityProjectPath) {

    dotnet sln add $sharedUtilityProjectPath

    Write-Host ""
    Write-Host "Shared project added to solution:" -ForegroundColor Cyan
    Write-Host "- $sharedUtilityProject"
}
else {

    Write-Host ""
    Write-Host "Shared utility project not found:" -ForegroundColor Yellow
    Write-Host "- $sharedUtilityProjectPath"
}

# =====================================
# Configure Project References
# =====================================

# -------------------------------------
# Application -> Domain
# -------------------------------------

dotnet add ".\src\$applicationProject\$applicationProject.csproj" reference `
    ".\src\$domainProject\$domainProject.csproj"

# -------------------------------------
# Infrastructure -> Application + Domain
# -------------------------------------

dotnet add ".\src\$infrastructureProject\$infrastructureProject.csproj" reference `
    ".\src\$applicationProject\$applicationProject.csproj"

dotnet add ".\src\$infrastructureProject\$infrastructureProject.csproj" reference `
    ".\src\$domainProject\$domainProject.csproj"

# -------------------------------------
# WebApi -> Application + Infrastructure
# -------------------------------------

dotnet add ".\src\$webApiProject\$webApiProject.csproj" reference `
    ".\src\$applicationProject\$applicationProject.csproj"

dotnet add ".\src\$webApiProject\$webApiProject.csproj" reference `
    ".\src\$infrastructureProject\$infrastructureProject.csproj"

# =====================================
# Shared Utility References
# =====================================

if (Test-Path $sharedUtilityProjectPath) {

    # Application -> Utility
    dotnet add ".\src\$applicationProject\$applicationProject.csproj" reference `
        $sharedUtilityProjectPath

    # Infrastructure -> Utility
    dotnet add ".\src\$infrastructureProject\$infrastructureProject.csproj" reference `
        $sharedUtilityProjectPath

    # WebApi -> Utility
    dotnet add ".\src\$webApiProject\$webApiProject.csproj" reference `
        $sharedUtilityProjectPath

    Write-Host ""
    Write-Host "Shared utility references configured!" -ForegroundColor Cyan
}

# =====================================
# Configure Test References
# =====================================

dotnet add ".\tests\$applicationTestProject\$applicationTestProject.csproj" reference `
    ".\src\$applicationProject\$applicationProject.csproj"

dotnet add ".\tests\$domainTestProject\$domainTestProject.csproj" reference `
    ".\src\$domainProject\$domainProject.csproj"

dotnet add ".\tests\$infrastructureTestProject\$infrastructureTestProject.csproj" reference `
    ".\src\$infrastructureProject\$infrastructureProject.csproj"

dotnet add ".\tests\$webApiTestProject\$webApiTestProject.csproj" reference `
    ".\src\$webApiProject\$webApiProject.csproj"

Write-Host ""
Write-Host "Test project references configured!" -ForegroundColor Cyan

# =====================================
# Restore Packages
# =====================================

dotnet restore

Write-Host ""
Write-Host "NuGet packages restored!" -ForegroundColor Cyan

# =====================================
# Completed
# =====================================

Write-Host ""
Write-Host "=====================================" -ForegroundColor Green
Write-Host "Copilot SDD Template Initialized!" -ForegroundColor Green
Write-Host "Solution : $SolutionName" -ForegroundColor Green
Write-Host "Location : $TargetPath" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green
