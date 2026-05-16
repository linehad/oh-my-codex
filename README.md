# Oh My Codex

Oh My Codex는 Codex에서 agent-harness 스타일의 작업 오케스트레이션을 사용할 수 있게 해주는 스킬 팩입니다.
[oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent/tree/dev)의 역할 구분을 Codex 스킬 구조에 맞춰 옮겼습니다.

이 패키지는 사용자가 직접 호출하는 공개 스킬 4개를 설치합니다. 그 밖의 에이전트는 공개 스킬이 필요할 때 내부적으로 호출하는 역할 템플릿이며, 사용자가 직접 실행하는 스킬로 설치되지 않습니다.

## 한눈에 보기

| 공개 스킬 | 역할 | 기본 reasoning |
| --- | --- | --- |
| `sisyphus` | 전체 작업을 조율하는 메인 오케스트레이터 | `high` |
| `hephaestus` | 깊은 구현, 복잡한 디버깅, 아키텍처 중심 작업 담당 | `high` |
| `prometheus` | Plan Mode 전용 플랜 빌더 | `high` |
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
- `prometheus`: Plan Mode에서 먼저 계획, 범위, 리스크, 검증 기준을 정리해야 할 때 사용합니다.
- `atlas`: 이미 승인된 계획이나 체크리스트를 실제 작업으로 실행할 때 사용합니다.

예를 들어 `$sisyphus로 HTML 테트리스 만들어줘`처럼 공개 스킬을 명시해 비단순 작업을 요청하면, 해당 스킬의 에이전트 동작과 필요한 내부 에이전트 호출을 허용한 것으로 간주합니다. 사용자가 별도로 "에이전트 만들어서 해줘"라고 덧붙일 필요는 없습니다.

## 역할 경계

공개 스킬은 각자 맡는 일이 다릅니다.

- Sisyphus는 작업을 분류하고 전체 흐름을 조율합니다.
- Prometheus는 Plan Mode에서 계획을 작성하며, 구현하지 않습니다.
- Atlas는 승인된 계획을 체크리스트로 실행하고 검증합니다.
- Hephaestus는 명시적으로 깊은 구현이나 어려운 디버깅이 필요할 때 사용합니다.

Sisyphus와 Atlas는 직접 코드를 작성하는 역할이 아닙니다. 일반적인 구현은 내부 실행자인 Sisyphus Junior에게 위임하고, Hephaestus는 명시적인 deep-agent 작업이나 아키텍처 비중이 큰 구현에 사용합니다.

## 내부 에이전트

아래 에이전트들은 사용자에게 노출되는 스킬이 아닙니다. 공개 스킬이 필요할 때 별도 Codex 에이전트로 호출해 사용하는 내부 역할입니다.

| 내부 에이전트 | Codex agent type | 용도 | 기본 reasoning |
| --- | --- | --- | --- |
| Oracle | `default` | 아키텍처, 디버깅 가설, 보안, 성능, 트레이드오프 검토 | `high` |
| Librarian | `explorer` | 문서, API, 라이브러리 동작, 외부 자료 조사 | `medium` |
| Explore | `explorer` | 로컬 코드베이스 검색, 파일 구조와 패턴 파악 | `low` |
| Multimodal Looker | `default` | 스크린샷, PDF, 다이어그램, 시각적 QA 확인 | `medium` |
| Metis | `default` | 모호한 요구사항, 숨은 가정, 누락된 성공 기준 점검 | `high` |
| Momus | `default` | 계획, 완료된 작업, 검증 증거, 잔여 리스크 리뷰 | `xhigh` |
| Sisyphus Junior | `worker` | 한 가지 목표에 집중하는 제한 범위 실행자 | `medium` |

내부 에이전트 정의는 재사용 가능한 템플릿입니다. 작업이 자연스럽게 나뉘면 같은 내부 에이전트를 여러 번 호출할 수 있습니다. 예를 들어 Oracle을 보안 검토와 성능 검토로 나누거나, Sisyphus Junior를 서로 다른 파일 그룹별 구현 작업으로 나눌 수 있습니다.

## GPT Pro 기준 설정과 조정

Oh My Codex의 기본값은 GPT Pro 구독을 전제로 설계되어 있습니다. 그래서 주요 에이전트는 넉넉한 이성 수준(reasoning)을 쓰도록 `high` 또는 `xhigh`가 기본값으로 잡혀 있습니다.

사용량, 속도, 구독 플랜에 맞춰 이성 수준이나 agent type을 조절하고 싶다면 아래 파일을 수정하면 됩니다.

| 설정 위치 | 바꾸는 내용 |
| --- | --- |
| `manifest.json` | 공개 스킬의 기본 reasoning 값 |
| `skills/<skill-name>/SKILL.md` | 공개 스킬의 reasoning profile, 내부 에이전트의 agent type과 reasoning 지침 |
| `skills/<skill-name>/agents/openai.yaml` | Codex UI에 보이는 표시 이름, 짧은 설명, 기본 프롬프트 |

Codex agent type은 보통 다음 기준으로 고릅니다.

- `default`: 판단, 계획, 리뷰, 종합처럼 일반 추론이 필요한 역할
- `explorer`: 파일 탐색, 코드베이스 매핑, 문서 조사처럼 읽기 중심 역할
- `worker`: 구현, 수정, 테스트 작성처럼 실제 작업을 수행하는 역할

이성 수준(reasoning)은 `low`, `medium`, `high`, `xhigh` 순서로 무거워집니다. 기본값보다 가볍게 쓰고 싶다면 다음처럼 낮춰서 시작하는 편이 무난합니다.

- `Momus`: `xhigh`에서 `high` 또는 `medium`
- `Oracle`, `Metis`: `high`에서 `medium`
- `Hephaestus`, `Prometheus`: `high`에서 `medium`
- `Explore`: 이미 `low`라 그대로 유지
- `Sisyphus Junior`, `Atlas`, `Librarian`, `Multimodal Looker`: 기본 `medium` 유지

설정을 바꾼 뒤에는 설치 스크립트를 다시 실행하고 Codex를 재시작해야 반영됩니다. 기존 스킬을 덮어써야 한다면 PowerShell에서는 `-Force`, macOS/Linux에서는 `--force`를 사용합니다.

## 설치

자세한 설치 방법은 [INSTALL.md](https://github.com/linehad/oh-my-codex/blob/main/INSTALL.md)를 참고하세요.

가장 쉬운 방법은 Codex에게 설치를 맡기는 것입니다. Codex에 아래 내용을 그대로 넘기면 됩니다.

```text
https://github.com/linehad/oh-my-codex/blob/main/INSTALL.md

Follow INSTALL.md and install Oh My Codex.
```

직접 설치하려면 운영체제에 맞는 스크립트를 실행합니다.

```powershell
.\scripts\install.ps1
```

```bash
./scripts/install.sh
```

설치하거나 업데이트한 뒤에는 Codex를 재시작해야 새 스킬이 반영됩니다.

## 사용 예시

조사부터 구현, 검증까지 한 번에 맡기고 싶다면 다음처럼 요청합니다.

```text
$sisyphus로 이 작업을 처음부터 끝까지 진행해줘
```

Plan Mode에서 구현 전에 방향을 잡고 싶다면 Prometheus를 사용합니다.

```text
$prometheus로 구현 전에 실행 계획부터 세워줘
```

이미 정해둔 계획을 실행하려면 Atlas를 사용합니다.

```text
$atlas로 승인된 체크리스트를 단계별로 실행해줘
```

복잡한 구현이나 깊은 디버깅이 필요하다면 Hephaestus를 사용합니다.

```text
$hephaestus로 이 버그를 깊게 분석하고 수정해줘
```

Prometheus는 Codex Plan Mode에서만 동작합니다. Plan Mode가 꺼져 있으면 Plan Mode를 켠 뒤 다시 요청해야 합니다.

## 라이선스와 출처

이 패키지는 upstream [oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent/tree/dev) 라이선스 모델과 맞추기 위해 Sustainable Use License Version 1.0 (`SUL-1.0`)으로 배포됩니다.

관련 파일은 다음과 같습니다.

- [LICENSE.md](LICENSE.md): SUL-1.0 라이선스 전문
- [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md): upstream 출처와 수정 고지

재배포할 때는 위 파일들을 함께 유지해 주세요.
