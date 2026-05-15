# Third-Party Notices

## oh-my-openagent / oh-my-opencode

This package is a Codex skill adaptation aligned with the oh-my-openagent /
oh-my-opencode project family.

- Upstream author: YeonGyu Kim and contributors
- Upstream repository: https://github.com/code-yeongyu/oh-my-openagent
- Upstream dev branch: https://github.com/code-yeongyu/oh-my-openagent/tree/dev
- Upstream license: Sustainable Use License Version 1.0 (`SUL-1.0`)

## Modification Notice

This repository is a modified/adapted work for Codex skills. Notable changes:

- Converted agent-harness concepts into standalone Codex `SKILL.md` files.
- Made `oh-my-codex` the main Codex orchestrator skill.
- Represented role/model matching as Codex `reasoning_effort` guidance.
- Replaced OpenCode-specific runtime APIs with Codex-native orchestration rules.
- Added installer scripts for copying skills into `$CODEX_HOME/skills` or
  `~/.codex/skills`.

This repository is not the upstream project and does not include the upstream
runtime implementation.
