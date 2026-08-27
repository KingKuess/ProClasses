# Renders index.html to motd.png (the image MOTD.md embeds) at the in-game
# MOTD panel width, cropped to the content. Run from anywhere:
#   powershell -ExecutionPolicy Bypass -File .\make-motd-png.ps1
# then commit + push motd.png. Needs Chrome or Edge installed.
param([int]$Width = 860, [int]$MaxHeight = 1800)

$browser = @(
  "C:\Program Files\Google\Chrome\Application\chrome.exe",
  "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe",
  "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe",
  "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $browser) { throw "Chrome/Edge not found" }

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$full = Join-Path $env:TEMP "proclasses_full.png"
$out  = Join-Path $here "motd.png"
$url  = "file:///" + ($here -replace '\\', '/') + "/index.html"

Start-Process -FilePath $browser -Wait -NoNewWindow -ArgumentList @(
  "--headless=new", "--disable-gpu", "--hide-scrollbars", "--force-device-scale-factor=1",
  "--window-size=$Width,$MaxHeight", ('--screenshot="' + $full + '"'), $url)

Add-Type -AssemblyName System.Drawing
$bmp = New-Object System.Drawing.Bitmap $full
# find the card's bottom border: first row from the bottom brighter than the page background
$bottom = $bmp.Height - 1
for ($y = $bmp.Height - 1; $y -ge 0; $y--) {
  $c = $bmp.GetPixel([int]($bmp.Width / 2), $y)
  if ($c.R -ge 35 -or $c.G -ge 35 -or $c.B -ge 40) { $bottom = $y; break }
}
$h = [Math]::Min($bmp.Height, $bottom + 12)
$rect = New-Object System.Drawing.Rectangle 0, 0, $bmp.Width, $h
$crop = $bmp.Clone($rect, $bmp.PixelFormat)
$bmp.Dispose()
$crop.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
Write-Output ("wrote {0} ({1}x{2})" -f $out, $crop.Width, $h)
$crop.Dispose()
