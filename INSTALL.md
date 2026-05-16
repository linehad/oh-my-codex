# Codex Installation Instructions

This file is for Codex, not a human-facing tutorial. When the user asks Codex to install Oh My Codex, follow this runbook.

## Goal

Install the four public skills from this repository's `skills` directory into the user's Codex skills directory.

- `sisyphus`
- `hephaestus`
- `prometheus`
- `atlas`

After installation, tell the user to restart Codex so the new skills are loaded.

## Preflight

1. Confirm you are at the repository root.
2. Confirm these paths exist:
   - `skills/`
   - `scripts/install.ps1`
   - `scripts/install.sh`
   - `manifest.json`
3. Detect the current OS and shell, then choose the correct install script.

If the repository is not present locally, clone it first.

```bash
git clone https://github.com/linehad/oh-my-codex.git
cd oh-my-codex
```

## Install Location

The default destination is `$CODEX_HOME/skills`.

If `CODEX_HOME` is not set, the scripts use the default Codex home skills directory.

- Windows PowerShell: `$HOME\.codex\skills`
- macOS / Linux: `$HOME/.codex/skills`

Use a custom destination only when the user explicitly requests one.

- PowerShell: `-Destination`
- macOS / Linux: `--dest`

## Windows PowerShell

Default install:

```powershell
.\scripts\install.ps1
```

Update or reinstall by overwriting existing skills:

```powershell
.\scripts\install.ps1 -Force
```

Custom destination:

```powershell
.\scripts\install.ps1 -Destination "C:\path\to\codex\skills"
```

## macOS / Linux

Default install:

```bash
./scripts/install.sh
```

If execution permission is missing, grant it and rerun:

```bash
chmod +x ./scripts/install.sh
./scripts/install.sh
```

Update or reinstall by overwriting existing skills:

```bash
./scripts/install.sh --force
```

Custom destination:

```bash
./scripts/install.sh --dest /path/to/codex/skills
```

## Force Policy

If skills with the same names already exist, the install scripts skip them by default.

Use the force option only when:

- the user asks for an update
- the user asks for a reinstall
- the user explicitly approves overwriting the existing skills

Do not delete or overwrite existing skills without user consent.

## Verify

After installation, confirm the destination contains:

- `sisyphus`
- `hephaestus`
- `prometheus`
- `atlas`

When possible, also confirm each directory contains `SKILL.md`.

## Report Back

After installation, briefly report:

- installed skills
- destination path
- whether force was used
- that Codex must be restarted

Always tell the user to restart Codex before using the new skills.

## Smoke Test Prompts

After restart, the user can invoke Sisyphus:

```text
$sisyphus로 이 작업을 처음부터 끝까지 진행해줘
```

Prometheus only works in Codex Plan Mode:

```text
$prometheus로 구현 전에 실행 계획부터 세워줘
```
