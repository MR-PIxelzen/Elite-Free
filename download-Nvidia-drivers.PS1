$repo = "MR-PIxelzen/Elite-Free"
$response = Invoke-RestMethod -Uri "https://api.github.com/repos/$repo/releases/latest" -UseBasicParsing

foreach ($asset in $response.assets) {
    $url = $asset.browser_download_url
    $filename = [System.IO.Path]::GetFileName($url)
    
    if ($filename -like "*-x64.exe") {
        Invoke-WebRequest -Uri $url -OutFile $filename
        break
    }
}
