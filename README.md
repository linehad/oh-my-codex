# Oh My Codex

Codex skill pack for agent-harness style orchestration, aligned with the
oh-my-openagent / oh-my-opencode project family.

The package installs four user-facing Oh My Codex skills. Other Oh My
OpenAgent agents are internal agents invoked by those four skills; they are not
installed as user-facing skills and should not be invoked directly by users.

Invoking any user-facing Oh My Codex skill for a non-trivial task counts as an
explicit request for that skill's agent behavior, including its required
internal agents. For example, `$sisyphus로 HTML 테트리스 만들어줘` lets Sisyphus
delegate implementation to Sisyphus Junior, then call Multimodal Looker or
Momus when needed, without requiring the user to add "서브 에이전트 만들어서".

## User-Facing Skills

| Skill | Role | Default Codex reasoning |
| --- | --- | --- |
| `sisyphus` | Ultraworker and main orchestrator | high |
| `hephaestus` | Deep Agent and implementation owner | high |
| `prometheus` | Plan Builder | high |
| `atlas` | Plan Executor and checklist coordinator | medium |

Suggested display names:

```text
Sisyphus - Ultraworker
Hephaestus - Deep Agent
Prometheus - Plan Builder
Atlas - Plan Executor
```

Role boundary:

- Sisyphus orchestrates the work and chooses the route.
- Prometheus writes plans and does not implement.
- Atlas executes an accepted plan as a checklist coordinator.
- Hephaestus is a primary deep agent for explicit deep implementation or hard debugging.

Sisyphus and Atlas do not directly write code. For normal ultrawork or plan
execution, they delegate implementation by category to Sisyphus Junior.
Hephaestus is reserved for explicit deep-agent use or architecture-heavy
implementation.

## Internal Agents

These are not installed as separate user-facing skills. The four user-facing
skills invoke them as real Codex agents with injected role-specific prompts.

| Agent | Purpose | Default reasoning |
| --- | --- | --- |
| Oracle | Read-only architecture, debugging, and review consultant | high |
| Librarian | Docs, API, library, and external research | medium |
| Explore | Fast local codebase exploration | low |
| Multimodal Looker | Screenshots, PDFs, diagrams, and visual QA | medium |
| Metis | Pre-plan ambiguity and risk analysis | high |
| Momus | Practical plan review | xhigh |
| Sisyphus Junior | Focused one-objective executor | medium |

Non-user-facing agents must never be listed as user-facing skills. If a
user-facing skill uses one, it must spawn a separate agent when agent tools are
available. The prompt should include the assigned agent name and must return
findings/results to the parent.

Progress and final reports should name the assigned agent only, such as
`Sisyphus Junior`, `Momus`, `Oracle`, or `Multimodal Looker`.

Every injected agent prompt should include the assigned agent name:

```text
You are working for this parent task.
Do not call any other agent.
Return findings only to the parent.

Agent: Momus
Role: independent reviewer for plans, completed work, verification evidence, blockers, and residual risk.
```

Routing follows the upstream orchestration guide: primary agents are selected
directly, while internal agents are invoked through typed task routing or
category dispatch. Categories such as `visual-engineering`, `quick`, or `deep`
go to Sisyphus Junior. Non-trivial flows also run Momus review before the final
answer.

Prometheus does not solo-plan non-trivial work when agent tools are available.
For technical app/game/UI planning, it should use Explore for existing files,
Oracle for architecture or implementation strategy, and Momus before presenting
the final plan. Metis and Librarian are added when ambiguity or external docs
matter.

## Install

PowerShell:

```powershell
.\scripts\install.ps1
```

macOS/Linux:

```bash
./scripts/install.sh
```

By default, the scripts install into `$CODEX_HOME/skills`, or
`~/.codex/skills` when `CODEX_HOME` is not set.

Use `--force` to replace existing skills with the same names.

Restart Codex after installing or updating skills.

## Usage

```text
$sisyphus 로 이 작업을 오케스트레이션해줘
```

Planner-only flow:

```text
$prometheus 로 플랜모드처럼 계획부터 작성해줘
```

Prometheus cannot toggle Codex Plan Mode automatically. If Plan Mode is not
already active, it should ask the user to turn on Plan Mode and stop. If the
user explicitly chooses not to switch, Prometheus may continue with a fallback
plan-only lock.

## License And Attribution

This package is distributed under the Sustainable Use License Version 1.0
(`SUL-1.0`) to align with the upstream oh-my-openagent / oh-my-opencode
licensing model.

This project includes:

- [LICENSE.md](LICENSE.md) with SUL-1.0 terms.
- [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) with upstream attribution
 and modified-copy notice.

Keep those files with redistributed copies.
