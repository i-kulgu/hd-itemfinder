#################
### Variables ###
#################

# Location of your items.lua file 
$itemsloc = "D:\qb\qb-core\shared\items.lua"

# Location of your images folder
$imageloc = "D:\qb\qb-inventory\html\images"

# Location where to move the non existing images
$moveloc = "C:\Temp\missing"

################################
### Don't Touch from here on ###
################################

#Check existance of the moveloc and create if not exist
if (-not (Test-Path -Path $moveloc)) {
    # Create the directory if it doesn't exist
    New-Item -ItemType Directory -Path $moveloc -Force
    Write-Host "Directory created at $moveloc"
}

#$luaTable = Get-Content -Path $itemsloc -Raw
$luaTable = [IO.File]::ReadAllText($itemsloc)
$imageFiles = Get-ChildItem -LiteralPath $imageloc -Filter *.png | Select-Object Name, FullName
$pattern = "\s*=\s*'([^']+\.png)"
$imageNames = @()
$matches = [regex]::Matches($luaTable, $pattern)

# Loop through each match and extract the image names
foreach ($match in $matches) {
    $imageName = $match.Groups[1].Value
    $imageNames += $imageName
}

# Compare if each image file exists in $imageNames
$missingImages = $imageFiles | Where-Object { $_.Name -notin $imageNames }

# Output missing images
if ($missingImages.Count -gt 0) {
    Write-Host "Images in inventory with no items:" -BackgroundColor Green
    $missingImages
    foreach($image in $missingImages) {
        Move-Item -LiteralPath $image.FullName -Destination $moveloc
    }
} else {
    Write-Host "All items found."
}
