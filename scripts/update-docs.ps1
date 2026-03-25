param(
    [switch]$Init,
    [switch]$NonBlocking
)

$ErrorActionPreference = 'Stop'

$docsRepoUrl = 'https://github.com/BryanTieu/mv-release-notes.git'
$docsArchiveUrl = 'https://github.com/BryanTieu/mv-release-notes/archive/refs/heads/main.zip'
$docsCommitApiUrl = 'https://api.github.com/repos/BryanTieu/mv-release-notes/commits/main'
$versionFileName = '.release-notes-version'

function Get-RemoteDocsVersion {
    try {
        $headers = @{ 'User-Agent' = 'uv-release-notes-ai-skill' }
        $response = Invoke-RestMethod -Uri $docsCommitApiUrl -Headers $headers
        if ($response -and $response.sha) {
            return [string]$response.sha
        }
    }
    catch {
        return $null
    }

    return $null
}

function Get-LocalDocsVersion {
    $versionFilePath = Join-Path (Join-Path $PWD 'docs') $versionFileName
    if (Test-Path $versionFilePath) {
        return (Get-Content -Path $versionFilePath -Raw).Trim()
    }

    return $null
}

function Set-LocalDocsVersion {
    param(
        [string]$Version
    )

    if (-not $Version) {
        return
    }

    $versionFilePath = Join-Path (Join-Path $PWD 'docs') $versionFileName
    Set-Content -Path $versionFilePath -Value $Version -NoNewline
}

function Sync-DocsFromArchive {
    param(
        [string]$Version
    )

    $docsPath = Join-Path $PWD 'docs'
    $tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("mv-release-notes-" + [System.Guid]::NewGuid().ToString())
    $zipPath = Join-Path $tempRoot 'docs.zip'
    $extractPath = Join-Path $tempRoot 'extract'

    New-Item -ItemType Directory -Path $tempRoot | Out-Null
    New-Item -ItemType Directory -Path $extractPath | Out-Null

    try {
        Invoke-WebRequest -Uri $docsArchiveUrl -OutFile $zipPath
        Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

        $repoRoot = Get-ChildItem -Path $extractPath -Directory | Select-Object -First 1
        if (-not $repoRoot) {
            throw 'Downloaded docs archive did not contain an extractable repository folder.'
        }

        if (Test-Path $docsPath) {
            Remove-Item -Path $docsPath -Recurse -Force
        }

        New-Item -ItemType Directory -Path $docsPath | Out-Null
        Copy-Item -Path (Join-Path $repoRoot.FullName '*') -Destination $docsPath -Recurse -Force
        Set-LocalDocsVersion -Version $Version

        Write-Host "Docs downloaded successfully from $docsRepoUrl"
    }
    finally {
        if (Test-Path $tempRoot) {
            Remove-Item -Path $tempRoot -Recurse -Force
        }
    }
}

try {
    $docsPath = Join-Path $PWD 'docs'
    $hasDocs = Test-Path $docsPath
    $remoteVersion = Get-RemoteDocsVersion
    $localVersion = Get-LocalDocsVersion

    if ($Init) {
        Sync-DocsFromArchive -Version $remoteVersion
        Write-Host 'Docs forced refresh completed.'
    }
    elseif (-not $hasDocs) {
        Sync-DocsFromArchive -Version $remoteVersion
        Write-Host 'Docs bootstrap completed.'
    }
    elseif (-not $remoteVersion) {
        Write-Warning 'Unable to check remote docs version. Keeping existing local docs.'
    }
    elseif ($localVersion -eq $remoteVersion) {
        Write-Host 'Docs are up to date. No download required.'
    }
    else {
        Sync-DocsFromArchive -Version $remoteVersion
        Write-Host 'Docs updated to latest version.'
    }

}
catch {
    if ($NonBlocking) {
        Write-Warning ("Docs sync skipped: " + $_.Exception.Message)
        exit 0
    }

    throw
}

