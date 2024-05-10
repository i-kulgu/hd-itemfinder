#################
### Variables ###
#################

# Location of your items.lua file 
$itemsloc = "D:\qb\qb-core\shared\items.lua"

# Location of your images folder
$imageloc = "D:\qb\qb-inventory\html\images"



################################
### Don't Touch from here on ###
################################


$luaTable = Get-Content -Path $itemsloc -Raw
$imageFolderPath = $imageloc
$imageFiles = Get-ChildItem -Path $imageFolderPath -Filter *.png | Select-Object -ExpandProperty Name
$pattern = "\s*=\s*'([^']+\.png)"
$imageNames = @()
$matches = [regex]::Matches($luaTable, $pattern)

# Loop through each match and extract the image names
foreach ($match in $matches) {
    $imageName = $match.Groups[1].Value
    $imageNames += $imageName
}

# Compare if each image file exists in $imageNames
$missingImages = $imageFiles | Where-Object { $_ -notin $imageNames }

# Output missing images
if ($missingImages.Count -gt 0) {
    Write-Host "Images in inventory with no items:" -BackgroundColor Green
    $missingImages
} else {
    Write-Host "All items found."
}
