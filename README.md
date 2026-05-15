# Oh My Codex

Codex skill pack for agent-harness style orchestration, aligned with the
oh-my-openagent / oh-my-opencode project family.

The package installs four public Oh My Codex skills. Other Oh My OpenAgent
agents are private internal subagents invoked by those four skills; they are not
installed as user-facing skills and should not be invoked directly by users.

Invoking any public Oh My Codex skill for a non-trivial task is intended to
count as an explicit request for that skill's agent behavior, including private
internal subagents when useful. For example, `$sisyphus로 HTML 테트리스 만들어줘`
should let Sisyphus use category-based delegation to a private Sisyphus Junior
worker, and real private subagents such as Explore, Multimodal Looker, or Momus
when needed, without requiring the user to add "서브 에이전트 만들어서".

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
execution, they delegate implementation by category to private Sisyphus
Junior-style workers. Hephaestus is reserved for explicit deep-agent use or
architecture-heavy implementation.

## Private Internal Subagents

These are not installed as separate user-facing skills. They are private
subagent profiles that the four public skills invoke as real Codex subagents
with an injected role-specific prompt. They are private because users do not
select them directly.

| Internal role | Purpose | Default reasoning |
| --- | --- | --- |
| Oracle | Read-only architecture, debugging, and review consultant | high |
| Librarian | Docs, API, library, and external research | medium |
| Explore | Fast local codebase exploration | low |
| Multimodal Looker | Screenshots, PDFs, diagrams, and visual QA | medium |
| Metis | Pre-plan ambiguity and risk analysis | high |
| Momus | Practical plan review | xhigh |
| Sisyphus Junior | Focused one-objective executor | medium |

Internal subagents must never be listed as user-facing skills. If a public skill
uses one, it must spawn a separate subagent when subagent tools are available.
The prompt should clearly say it is a private subagent for the parent task and
must return findings/results to the parent.

Every private subagent prompt should include an explicit injected identity:

```text
You are a private internal subagent for this parent task.
Do not call or create Sisyphus, Hephaestus, Prometheus, Atlas, or any other agent.
Return findings only to the parent.

Private internal subagent: Momus
Role: independent reviewer for plans, completed work, verification evidence, blockers, and residual risk.
```

Routing follows the upstream orchestration guide: primary agents are selected
directly, while subagents are invoked privately through `task(subagent_type=...)`
or category dispatch. Category dispatch such as `visual-engineering`, `quick`,
or `deep` goes to a real private Sisyphus Junior-style worker. Non-trivial
flows also run a separate Momus-style private review subagent before the final
answer.

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

The planner should clarify scope, write a plan, define verification, and wait
for approval before execution.

## License And Attribution

This package is distributed under the Sustainable Use License Version 1.0
(`SUL-1.0`) to align with the upstream oh-my-openagent / oh-my-opencode
licensing model.

This project includes:

- [LICENSE.md](LICENSE.md) with SUL-1.0 terms.
- [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) with upstream attribution
  and modified-copy notice.

Keep those files with redistributed copies.
