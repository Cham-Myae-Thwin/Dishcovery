# create_dishcovery_structure.ps1
# Creates feature-based folder structure for Dishcovery and placeholder Dart screen files.
# Run from the project root (where you want the 'lib' folder to be created).

param(
    [string]$Root = ".\lib"
)

# Helper to create a directory if not present
function Ensure-Dir {
    param([string]$path)
    if (-not (Test-Path -Path $path)) {
        New-Item -ItemType Directory -Path $path | Out-Null
        Write-Host "Created directory: $path"
    } else {
        Write-Host "Directory exists: $path"
    }
}

# Helper to create a file with an optional header if not present
function Ensure-File {
    param(
        [string]$filePath,
        [string]$content = ""
    )
    if (-not (Test-Path -Path $filePath)) {
        $content | Out-File -FilePath $filePath -Encoding UTF8
        Write-Host "Created file: $filePath"
    } else {
        Write-Host "File exists: $filePath"
    }
}

# Base folders
$lib = Resolve-Path -LiteralPath $Root
Ensure-Dir $lib

$folders = @(
    "$lib\core",
    "$lib\features",
    "$lib\models",
    "$lib\services",
    "$lib\data",
    "$lib\shared"
)

foreach ($f in $folders) { Ensure-Dir $f }

# Feature folders and the main screens requested
$features = @{
    "welcome" = "Welcome";
    "browse_recipe" = "BrowseRecipe";
    "ingredient_search" = "IngredientSearch";
    "recipe_detail" = "RecipeDetail";
    "my_cookbook" = "MyCookbook";
    "profile" = "Profile"
}

foreach ($feature in $features.Keys) {
    $featureRoot = "$lib\features\$feature"
    Ensure-Dir $featureRoot

    $screensDir = "$featureRoot\screens"
    Ensure-Dir $screensDir

    # screen file name
    $screenPascal = $features[$feature]
    $screenFile = "$screensDir\${screenPascal}Screen.dart"

    $header = "// ${screenPascal}Screen.dart\n// Placeholder screen for the $screenPascal feature.\n\nimport 'package:flutter/material.dart';\n\n// TODO: Implement $screenPascal screen\n"
    Ensure-File -filePath $screenFile -content $header

    # Add a feature entry file (optional)
    $featureFile = "$featureRoot\${feature}_feature.dart"
    $featureFileContent = "// ${feature}_feature.dart\n// Feature entry for $screenPascal\n\n// TODO: Export public widgets/providers for this feature\n"
    Ensure-File -filePath $featureFile -content $featureFileContent
}

# Create common model and service placeholders
Ensure-File -filePath "$lib\models\recipe.dart" -content "// recipe.dart\n// Recipe model placeholder\n\nclass Recipe {\n  // TODO: define model fields\n}\n"
Ensure-File -filePath "$lib\services\recipe_repository.dart" -content "// recipe_repository.dart\n// Local JSON recipe repository placeholder\n\n// TODO: implement loading and filtering of recipes\n"

# Create a sample local data file for recipes (empty JSON array)
Ensure-File -filePath "$lib\data\recipes.json" -content "[]"

Write-Host "`nStructure creation complete."
