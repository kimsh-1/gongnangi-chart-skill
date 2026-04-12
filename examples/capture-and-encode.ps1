$chrome = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$ffmpeg = "C:\Users\kim\AppData\Local\Microsoft\WinGet\Packages\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe\ffmpeg-8.0.1-full_build\bin\ffmpeg.exe"

$animations = @(
    @{
        Name = "barchart"
        Html = "D:\gongnangi-output\animation\animated-barchart.html"
        Width = 960
        Height = 500
        Fps = 10
        Duration = 4
    },
    @{
        Name = "4axis"
        Html = "D:\gongnangi-output\animation\animated-4axis.html"
        Width = 960
        Height = 500
        Fps = 10
        Duration = 5
    }
)

foreach ($anim in $animations) {
    $framesDir = "D:\gongnangi-output\animation\frames-$($anim.Name)"
    New-Item -ItemType Directory -Force -Path $framesDir | Out-Null

    $totalFrames = $anim.Fps * $anim.Duration
    Write-Host "Capturing $totalFrames frames for $($anim.Name)..."

    # Capture frames by loading page at different time offsets
    # Using Chrome's --virtual-time-budget approach
    for ($i = 0; $i -lt $totalFrames; $i++) {
        $timeMs = [int](($i / $anim.Fps) * 1000)
        $frameNum = $i.ToString("D4")
        $outFile = "$framesDir\frame-$frameNum.png"

        & $chrome --headless=new --disable-gpu --hide-scrollbars `
            --screenshot="$outFile" `
            --window-size="$($anim.Width),$($anim.Height)" `
            --virtual-time-budget=$timeMs `
            "file:///$($anim.Html)"

        if ($i % 10 -eq 0) { Write-Host "  Frame $i/$totalFrames" }
    }

    # Hold last frame for 1 second
    for ($i = 0; $i -lt $anim.Fps; $i++) {
        $frameNum = ($totalFrames + $i).ToString("D4")
        Copy-Item "$framesDir\frame-$($($totalFrames - 1).ToString('D4')).png" "$framesDir\frame-$frameNum.png"
    }

    $totalWithHold = $totalFrames + $anim.Fps

    # Encode to GIF
    $gifOut = "D:\gongnangi-output\animation\$($anim.Name).gif"
    & $ffmpeg -y -r $anim.Fps -i "$framesDir\frame-%04d.png" `
        -vf "fps=$($anim.Fps),scale=$($anim.Width):-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" `
        $gifOut
    Write-Host "GIF: $gifOut"

    # Encode to MP4
    $mp4Out = "D:\gongnangi-output\animation\$($anim.Name).mp4"
    & $ffmpeg -y -r $anim.Fps -i "$framesDir\frame-%04d.png" `
        -c:v libx264 -pix_fmt yuv420p -crf 18 `
        $mp4Out
    Write-Host "MP4: $mp4Out"

    # Encode to APNG
    $apngOut = "D:\gongnangi-output\animation\$($anim.Name).apng"
    & $ffmpeg -y -r $anim.Fps -i "$framesDir\frame-%04d.png" `
        -plays 0 $apngOut
    Write-Host "APNG: $apngOut"
}

Write-Host "`nAll done!"
