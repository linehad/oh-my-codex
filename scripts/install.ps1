param(
  [switch]$Force,
  [string]$Destination
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$sourceRoot = Join-Path $repoRoot 'skills'

if (-not $Destination) {
  if ($env:CODEX_HOME) {
    $Destination = Join-Path $env:CODEX_HOME 'skills'
  } else {
    $Destination = Join-Path $HOME '.codex\skills'
  }
}

New-Item -ItemType Directory -Path $Destination -Force | Out-Null
$destResolved = (Resolve-Path -LiteralPath $Destination).Path

foreach ($skill in Get-ChildItem -LiteralPath $sourceRoot -Directory) {
  $target = Join-Path $destResolved $skill.Name

  if (Test-Path -LiteralPath $target) {
    if (-not $Force) {
      Write-Host "Skipping existing skill: $($skill.Name)"
      continue
    }

    $resolvedTarget = (Resolve-Path -LiteralPath $target).Path
    if (-not $resolvedTarget.StartsWith($destResolved, [System.StringComparison]::OrdinalIgnoreCase)) {
      throw "Refusing to remove outside destination: $resolvedTarget"
    }
    Remove-Item -LiteralPath $resolvedTarget -Recurse -Force
  }

  Copy-Item -LiteralPath $skill.FullName -Destination $destResolved -Recurse
  Write-Host "Installed skill: $($skill.Name)"
}

Copy-Item -LiteralPath (Join-Path $repoRoot 'LICENSE.md') -Destination (Join-Path $destResolved '_oh-my-codex-LICENSE.md') -Force
Copy-Item -LiteralPath (Join-Path $repoRoot 'THIRD_PARTY_NOTICES.md') -Destination (Join-Path $destResolved '_oh-my-codex-THIRD_PARTY_NOTICES.md') -Force

Write-Host "Restart Codex to pick up new skills."
