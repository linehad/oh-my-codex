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
Momus according to the routing rules, without requiring the user to add
"에이전트 만들어서".

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

Primary skills coordinate; they do not absorb specialist work into local
self-analysis when agent tools are available:

- Sisyphus routes end-to-end work to Sisyphus Junior, Oracle, Librarian,
  Explore, Multimodal Looker, Metis, and Momus as needed.
- Prometheus plans by using Explore/Librarian for evidence, Metis for gaps,
  Oracle for architecture or implementation strategy, then Momus for review.
- Atlas executes accepted plans by delegating code-writing, bug fixing, tests,
  and commits to Sisyphus Junior or named specialists, then verifies.
- Hephaestus may lead deep implementation, but for non-trivial work it should
  still use Explore for code mapping, Oracle for high-risk decisions, bounded
  Sisyphus Junior tasks for edits, and Momus before the final answer.
- Browser-visible UI, game, canvas, screenshot, PDF, or diagram work should run
  Multimodal Looker before Momus so final review sees visual/runtime evidence.

## Internal Agents

These are not installed as separate user-facing skills. The four user-facing
skills invoke them as real Codex agents with injected role-specific prompts.

| Agent | Purpose | Default reasoning |
| --- | --- | --- |
| Oracle | Read-only architecture, debugging, risk, and tradeoff advisor | high |
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

Internal agent definitions are templates, not singletons. A primary skill must
assume every internal agent can be spawned multiple times, including Sisyphus
Junior, Oracle, Explore, Librarian, Multimodal Looker, Metis, and Momus. Use
multiple instances whenever the work naturally splits into independent bounded
scopes; the user does not need to explicitly request parallel agents. Keep the
assigned name the same and put the difference in a `Scope:` line, for example
two `Oracle` instances for security and performance, multiple `Explore`
instances for separate directories, or multiple `Sisyphus Junior` instances for
disjoint implementation slices. Do not invent decorated user-facing variants of
the assigned agent names.

Multiple instances are normal internal task calls, not Team Mode membership.
Do not put Oracle, Librarian, Explore, Multimodal Looker, Metis, Momus, or
Prometheus into Team Mode slots; invoke them through internal routing.

Every injected agent prompt should include the assigned agent name:

```text
You are working for this parent task.
Do not call any other agent.
Return findings only to the parent.

Agent: Momus
Role: independent reviewer for plans, completed work, verification evidence, blockers, and residual risk.
Scope: final review of the completed implementation
```

Routing follows the upstream orchestration guide: primary agents are selected
directly, while internal agents are invoked through typed task routing or
category dispatch. Category dispatch always goes to Sisyphus Junior.
Official built-in categories include `visual-engineering`, `artistry`,
`ultrabrain`, `deep`, `quick`, `unspecified-low`, `unspecified-high`,
`writing`, `quick-rust`, `quick-zig`, and `git`. Use `visual-engineering` for
frontend, UI, game, canvas, HTML/CSS, and browser-visible work. Do not invent
categories such as `frontend`. Non-trivial flows also run Momus review before
the final answer.

Prometheus does not solo-plan non-trivial work when agent tools are available.
For technical app/game/UI planning, it should use Explore for existing files,
Oracle for architecture or implementation strategy, and Momus before presenting
the final plan. Metis and Librarian are added when ambiguity or external docs
matter.

Oracle is not the file-search agent. Explore owns file discovery, codebase grep,
symbol mapping, and local pattern collection. Oracle receives the user's goal
and the relevant context, then advises on architecture, debugging hypotheses,
security, performance, and tradeoffs. If Oracle needs a code map, the parent
skill should spawn Explore and pass the findings to Oracle.

In large projects, split Oracle by decision domain rather than file search:
architecture boundaries, security, performance, data migration, deployment, or
debugging hypotheses. The parent skill synthesizes conflicting Oracle findings
and may ask another scoped Oracle pass only for conflict resolution.

Split Sisyphus Junior by ownership scope: one instance per independent
implementation slice, file group, package, or checklist item. Multiple Sisyphus
Junior instances must have disjoint write scopes, must be told they are not
alone in the codebase, and must report changed files and verification evidence
back to the parent.

Sisyphus Junior cannot call other agents. It must keep its own task tracking,
complete every assigned item before returning, verify with the strongest local
diagnostics available, and avoid modifying `.sisyphus/` plan files unless that
is the explicit owned deliverable.

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
