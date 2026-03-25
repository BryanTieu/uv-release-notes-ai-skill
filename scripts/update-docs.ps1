param(
    [switch]$Init,
    [switch]$NonBlocking
)

$ErrorActionPreference = 'Stop'

$docsRepoUrl = 'https://github.com/BryanTieu/mv-release-notes.git'
$docsArchiveUrl = 'https://github.com/BryanTieu/mv-release-notes/archive/refs/heads/main.zip'

function Sync-DocsFromArchive {
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

        Write-Host "Docs downloaded successfully from $docsRepoUrl"
    }
    finally {
        if (Test-Path $tempRoot) {
            Remove-Item -Path $tempRoot -Recurse -Force
        }
    }
}

try {
    $canUseSubmodule = (Test-Path '.git') -and (Test-Path '.gitmodules')

    if ($canUseSubmodule) {
        if ($Init) {
            git submodule update --init --recursive
        }

        git submodule sync -- docs
        git submodule update --init --remote --merge docs

        Write-Host 'Docs submodule synchronized successfully.'
    }
    else {
        Sync-DocsFromArchive
    }
}
catch {
    if ($NonBlocking) {
        Write-Warning ("Docs sync skipped: " + $_.Exception.Message)
        exit 0
    }

    throw
}

