# Oh My Codex

Oh My Codex는 Codex에서 agent-harness 스타일의 작업 오케스트레이션을 사용할 수 있게 해주는 스킬 팩입니다.
`oh-my-openagent` / `oh-my-opencode` 계열의 역할 구분을 Codex 스킬 구조에 맞춰 옮겼습니다.

이 패키지는 사용자가 직접 호출하는 공개 스킬 4개를 설치합니다. 그 밖의 에이전트는 공개 스킬이 필요할 때 내부적으로 호출하는 역할 템플릿이며, 사용자가 직접 실행하는 스킬로 설치되지 않습니다.

## 한눈에 보기

| 공개 스킬 | 역할 | 기본 reasoning |
| --- | --- | --- |
| `sisyphus` | 전체 작업을 조율하는 메인 오케스트레이터 | `high` |
| `hephaestus` | 깊은 구현, 복잡한 디버깅, 아키텍처 중심 작업 담당 | `high` |
| `prometheus` | 구현 전에 계획을 세우는 플랜 빌더 | `high` |
| `atlas` | 승인된 계획을 체크리스트로 실행하는 플랜 실행자 | `medium` |

추천 표시 이름은 다음과 같습니다.

```text
Sisyphus - Ultraworker
Hephaestus - Deep Agent
Prometheus - Plan Builder
Atlas - Plan Executor
```

## 언제 어떤 스킬을 쓰나요?

- `sisyphus`: 조사, 구현, 리뷰, 검증까지 한 번에 조율해야 하는 일반적인 큰 작업에 사용합니다.
- `hephaestus`: 여러 파일을 건드리는 깊은 구현, 어려운 버그 추적, 아키텍처 판단이 필요한 작업에 사용합니다.
- `prometheus`: 바로 구현하지 않고 먼저 계획, 범위, 리스크, 검증 기준을 정리해야 할 때 사용합니다.
- `atlas`: 이미 승인된 계획이나 체크리스트를 실제 작업으로 실행할 때 사용합니다.

예를 들어 `$sisyphus로 HTML 테트리스 만들어줘`처럼 공개 스킬을 명시해 비단순 작업을 요청하면, 해당 스킬의 에이전트 동작과 필요한 내부 에이전트 호출을 허용한 것으로 간주합니다. 사용자가 별도로 "에이전트 만들어서 해줘"라고 덧붙일 필요는 없습니다.

## 역할 경계

공개 스킬은 각자 맡는 일이 다릅니다.

- Sisyphus는 작업을 분류하고 전체 흐름을 조율합니다.
- Prometheus는 계획을 작성하며, 기본적으로 구현하지 않습니다.
- Atlas는 승인된 계획을 체크리스트로 실행하고 검증합니다.
- Hephaestus는 명시적으로 깊은 구현이나 어려운 디버깅이 필요할 때 사용합니다.

Sisyphus와 Atlas는 직접 코드를 작성하는 역할이 아닙니다. 일반적인 구현은 내부 실행자인 Sisyphus Junior에게 위임하고, Hephaestus는 명시적인 deep-agent 작업이나 아키텍처 비중이 큰 구현에 사용합니다.

## 내부 에이전트

아래 에이전트들은 사용자에게 노출되는 스킬이 아닙니다. 공개 스킬이 필요할 때 별도 Codex 에이전트로 호출해 사용하는 내부 역할입니다.

| 내부 에이전트 | 용도 | 기본 reasoning |
| --- | --- | --- |
| Oracle | 아키텍처, 디버깅 가설, 보안, 성능, 트레이드오프 검토 | `high` |
| Librarian | 문서, API, 라이브러리 동작, 외부 자료 조사 | `medium` |
| Explore | 로컬 코드베이스 검색, 파일 구조와 패턴 파악 | `low` |
| Multimodal Looker | 스크린샷, PDF, 다이어그램, 시각적 QA 확인 | `medium` |
| Metis | 모호한 요구사항, 숨은 가정, 누락된 성공 기준 점검 | `high` |
| Momus | 계획, 완료된 작업, 검증 증거, 잔여 리스크 리뷰 | `xhigh` |
| Sisyphus Junior | 한 가지 목표에 집중하는 제한 범위 실행자 | `medium` |

내부 에이전트 정의는 싱글턴이 아니라 재사용 가능한 템플릿입니다. 작업이 자연스럽게 나뉘면 같은 내부 에이전트를 여러 번 호출할 수 있습니다. 예를 들어 Oracle을 보안 검토와 성능 검토로 나누거나, Sisyphus Junior를 서로 다른 파일 그룹별 구현 작업으로 나눌 수 있습니다.

## 설치

### PowerShell

```powershell
.\scripts\install.ps1
```

기존 스킬을 덮어쓰려면 다음처럼 실행합니다.

```powershell
.\scripts\install.ps1 -Force
```

설치 위치를 직접 지정하려면 `-Destination`을 사용합니다.

```powershell
.\scripts\install.ps1 -Destination "C:\path\to\codex\skills"
```

### macOS / Linux

```bash
./scripts/install.sh
```

기존 스킬을 덮어쓰려면 다음처럼 실행합니다.

```bash
./scripts/install.sh --force
```

설치 위치를 직접 지정하려면 `--dest`를 사용합니다.

```bash
./scripts/install.sh --dest /path/to/codex/skills
```

기본 설치 위치는 `$CODEX_HOME/skills`입니다. `CODEX_HOME`이 설정되어 있지 않으면 `~/.codex/skills`에 설치합니다.

설치하거나 업데이트한 뒤에는 Codex를 재시작해야 새 스킬이 반영됩니다.

## 사용 예시

전체 작업을 오케스트레이션하려면 다음처럼 요청합니다.

```text
$sisyphus 로 이 작업을 끝까지 오케스트레이션해줘
```

계획부터 세우고 싶다면 Prometheus를 사용합니다.

```text
$prometheus 로 구현 전에 계획부터 작성해줘
```

승인된 계획을 실행하려면 Atlas를 사용합니다.

```text
$atlas 로 이 체크리스트를 실행해줘
```

복잡한 구현이나 깊은 디버깅이 필요하다면 Hephaestus를 사용합니다.

```text
$hephaestus 로 이 버그를 깊게 분석하고 수정해줘
```

Prometheus는 Codex Plan Mode를 자동으로 켤 수 없습니다. Plan Mode가 꺼져 있으면 사용자에게 Plan Mode를 켜 달라고 요청한 뒤 멈추는 것이 기본 동작입니다. 사용자가 명시적으로 Plan Mode를 사용하지 않겠다고 하면, 대체 plan-only 흐름으로 계속할 수 있습니다.

## 라이선스와 출처

이 패키지는 upstream `oh-my-openagent` / `oh-my-opencode` 라이선스 모델과 맞추기 위해 Sustainable Use License Version 1.0 (`SUL-1.0`)으로 배포됩니다.

관련 파일은 다음과 같습니다.

- [LICENSE.md](LICENSE.md): SUL-1.0 라이선스 전문
- [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md): upstream 출처와 수정 고지

재배포할 때는 위 파일들을 함께 유지해 주세요.
