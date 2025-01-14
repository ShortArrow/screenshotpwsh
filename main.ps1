#!powershell

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$screens = [System.Windows.Forms.Screen]::AllScreens

if ($null -eq $screens -or $screens.Count -eq 0) {
    Write-Error "No monitors"
    return
}

# Calculate WorkingArea.Right and store in array
$rights = $screens | ForEach-Object { $_.WorkingArea.Right }
$bottoms = $screens | ForEach-Object { $_.WorkingArea.Bottom }

# Calculate the maximum value
$totalWidth = ($rights | Measure-Object -Maximum).Maximum
$totalHeight = ($bottoms | Measure-Object -Maximum).Maximum

if ($null -eq $totalWidth -or $null -eq $totalHeight -or $totalWidth -eq 0 -or $totalHeight -eq 0) {
    Write-Error "Fail get display size"
    return
}

$bitmap = New-Object System.Drawing.Bitmap([int]$totalWidth, [int]$totalHeight)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)

foreach ($screen in $screens) {
    $graphics.CopyFromScreen($screen.WorkingArea.Location, $screen.WorkingArea.Location, $screen.WorkingArea.Size)
}

$timestamp = Get-Date -Format "yyyyMMddHHmmss"
$filename = "screenshot_all_$timestamp.png"
$path = Join-Path $PSScriptRoot $filename

$bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)

$bitmap.Dispose()
$graphics.Dispose()
$fullpath = Resolve-Path $filename

Write-Host "Saved to $fullpath"

