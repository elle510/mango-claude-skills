---
name: commit
description: 사용자가 /commit을 입력하거나 git 변경사항을 커밋하고 싶다고 할 때 사용한다. Conventional Commits 형식으로 메시지를 제안하고 사용자 확인 후 커밋을 실행한다.
---

# Skill: commit

## 호출 조건

사용자가 명시적으로 `/commit`을 입력했을 때만 실행한다.
Claude가 자동으로 판단하여 호출하지 않는다.

## 절차

### 0. 사전 점검 (브랜치 보호)

```bash
git branch --show-current
git status --short
ls .git/MERGE_HEAD .git/REBASE_HEAD .git/CHERRY_PICK_HEAD 2>/dev/null
```

다음 조건 중 하나라도 해당되면 **즉시 중단**하고 사용자에게 확인을 받는다.

- 현재 브랜치가 `main` 또는 `master` → 보호 브랜치 직접 커밋. `AskUserQuestion`으로 "보호 브랜치에 직접 커밋하시겠습니까? (권장: 새 브랜치 생성)"을 묻고, 명시적으로 "강행"이라고 답한 경우에만 진행.
- `.git/MERGE_HEAD` / `.git/REBASE_HEAD` / `.git/CHERRY_PICK_HEAD` 중 하나라도 존재 → 머지/리베이스/체리픽 진행 중. 사용자에게 알리고 종료(`/commit`은 일반 커밋 전용).

이상 없으면 1단계로 진행.

### 1. 변경사항 파악

```bash
git status --short
git diff HEAD
```

### 1-1. Staged 후보 파일 안전성 검증

`git add -A`로 포함될 파일 목록을 미리 확인한다.

```bash
git ls-files --others --exclude-standard   # untracked
git diff --name-only                       # modified (unstaged)
git diff --cached --name-only              # already staged
```

위 목록에서 **위험 패턴**이 하나라도 매치되면 즉시 중단하고 사용자에게 알린다.

**위험 패턴 (정규식):**

- `(^|/)\.env(\..+)?$` — `.env`, `.env.local`, `.env.production` 등 (`.env.example`은 제외)
- `(^|/)(node_modules|dist|build|\.next|\.turbo|coverage)/` — 빌드 산출물 / 의존성
- `\.(pem|key|p12|pfx|jks|keystore)$` — 인증서/키 파일
- `(^|/)(credentials|secrets?|service-account)\.(json|ya?ml)$` — 자격증명 파일
- `(^|/)\.DS_Store$` — macOS 메타데이터
- `(^|/)id_(rsa|ed25519|ecdsa)(\.pub)?$` — SSH 키

**대응:**

매치된 파일이 있으면 다음 형식으로 출력하고 **`AskUserQuestion`으로 명시적 확인을 받는다.**

```
⚠️  커밋에 포함될 예정인 의심 파일:

  - .env.local
  - dist/index.js

이 파일들을 정말로 커밋하시겠습니까?
  - "제외" → 해당 파일을 제외하고 나머지만 add
  - "포함" → 그대로 모두 add (주의: 시크릿/대용량 산출물일 수 있음)
  - "취소" → 커밋 중단
```

응답에 따라:

- **제외** → 4단계에서 `git add -A` 대신 `git add <파일들>`로 안전한 파일만 명시적으로 add
- **포함** → 4단계에서 `git add -A` 그대로 진행
- **취소** → 종료

매치된 파일이 없으면 검증 통과로 간주하고 2단계로 진행한다.

### 2. 커밋 메시지 제안

변경 내용을 분석해 **Conventional Commits** 형식으로 메시지를 제안한다.

```
<type>(<scope>): <subject>

[body - 필요한 경우만]
```

**type 규칙:**

- `feat` — 새 기능
- `fix` — 버그 수정
- `refactor` — 기능 변경 없는 코드 개선
- `style` — 포맷, CSS 변경 (로직 변경 없음)
- `docs` — 문서, 주석 (README, CLAUDE.md, JSDoc 등)
- `test` — 테스트 코드 추가/수정
- `chore` — 빌드, 설정, 의존성, 메타파일

**scope 규칙:** 변경된 디렉토리에 따라 아래 매핑을 사용한다.

| 변경 경로                                               | scope      |
| ------------------------------------------------------- | ---------- |
| `apps/web/**`                                           | `web`      |
| `apps/backend/**`                                       | `backend`  |
| `packages/ui/**`                                        | `ui`       |
| `packages/utils/**`                                     | `utils`    |
| `.claude/**`                                            | `claude`   |
| `.mcp.json`, `turbo.json`, 루트 `package.json`/`pnpm-*` | scope 생략 |
| 그 외 루트 설정 (`.gitignore`, `tsconfig*` 등)          | scope 생략 |

**여러 슬라이스 동시 변경 시:**

1. 변경이 논리적으로 분리 가능하면 — `AskUserQuestion`으로 "분할 커밋을 권장합니다. 분할하시겠습니까?"를 묻는다.
2. 분할 거부 또는 단일 변경(예: 모노레포 전체 설정 정리)이면 — **변경 라인 수가 가장 많은 디렉토리의 scope 하나**를 사용하고, body에 다른 영향 범위를 적는다.
3. scope 두 개를 쉼표/슬래시로 합쳐 쓰지 않는다 (`web,ui` ❌).

**subject 규칙:**

- 한국어로 작성
- **50자 이내** (한국어 글자 수 기준, 바이트 아님). 초과 시 차단하고 재작성 요청.
- 마침표 없음
- 명령형 어조 (예: "추가", "수정", "갱신" — "추가했음" ❌)

### 3. 사용자 확인

AskUserQuestion으로 다음 형식으로 묻는다:

```
아래 메시지로 커밋할까요?

  <제안 메시지>

[Y/n]
```

응답 처리:

- 빈 응답 또는 `Y` / `y` → 4단계로 바로 이동
- `N` / `n` → 아래 텍스트를 출력하고 사용자의 다음 입력을 커밋 메시지로 사용:

수정할 메시지를 입력해주세요:

```
<제안 메시지>
```

사용자가 입력한 메시지로 4단계 실행.

### 4. 커밋 실행

1-1단계 검증 결과에 따라 분기:

- **위험 파일 없음** 또는 **"포함" 선택** → `git add -A && git commit -m "<최종 메시지>"`
- **"제외" 선택** → `git add <안전한 파일 1> <안전한 파일 2> ... && git commit -m "<최종 메시지>"`
  - 파일명에 공백/특수문자가 있을 수 있으므로 각 인자는 따옴표로 감쌀 것

**금지 사항 (사용자가 명시 요청한 경우에만 예외):**

- `--amend` 사용 금지 — 항상 새 커밋을 만든다.
- `--no-verify` / `--no-gpg-sign` 사용 금지 — pre-commit hook을 우회하지 않는다.
- 커밋 메시지에 `Co-Authored-By` 라인을 **붙이지 않는다.** 이 레포의 컨벤션에 맞춤(최근 커밋들에 모두 없음).

### 5. Pre-commit hook 실패 처리

`git commit`이 hook 실패로 종료되면:

1. **hook이 자동 수정한 파일이 있는지** 확인 (`git status --short`).
   - 있으면 — 수정 내용을 사용자에게 보여주고 staging에 다시 추가.
2. **hook이 보고한 에러를 사용자에게 그대로 출력**하고 어떻게 고칠지 안내.
3. 에러 수정 후 → 재staging → **새 `git commit -m ...`을 다시 실행** (절대 `--amend` 사용 금지).
4. hook 실패 시점에는 커밋이 만들어지지 않았으므로 `--amend`는 **이전** 커밋을 수정하게 되어 위험하다.

## Gotchas

- **`git add -A` 사용 전 1-1단계 검증 필수**: 위험 패턴 매치 시 사용자 확인 없이 `git add -A`를 실행하지 말 것. 시크릿(`.env`)이나 대용량 산출물(`dist/`, `node_modules/`)을 커밋하면 되돌리기 어렵다.
- **`.gitignore` 신뢰 금지**: `.gitignore`가 있어도 이미 tracked된 파일은 무시되지 않는다. `git ls-files --others --exclude-standard`로 실제로 add될 파일만 확인하므로 ignore 규칙과 별개로 위험 패턴은 매번 검증한다.
- **`.env.example`은 안전**: `.env`로 시작해도 예시 파일은 커밋 대상이다. 위험 패턴 정규식이 `.env.example`을 제외하는지 확인할 것.
- **보호 브랜치 직접 커밋**: `main`/`master`에서 `/commit` 호출은 0단계에서 차단된다. 정말로 hotfix가 필요한 경우에만 "강행" 응답으로 진행한다.
- **`--amend` 절대 금지**: hook 실패로 커밋이 만들어지지 않은 상태에서 `--amend`를 쓰면 **이전** 커밋을 수정한다. 항상 새 커밋으로 처리한다.
- **`--no-verify` 절대 금지**: pre-commit hook이 막는 것은 보통 진짜 문제다. 우회하지 말고 원인을 고친다. 사용자가 명시적으로 요청한 경우에만 예외.
- **`Co-Authored-By` 미부착**: 시스템 기본 동작은 이 라인을 자동으로 붙이려 하지만 이 레포 컨벤션에는 없다. 메시지 작성 시 절대 추가하지 말 것.
- **N 응답 후 형식 검증 없음**: 사용자가 직접 입력한 메시지는 Conventional Commits 형식이 아닐 수 있다. 형식이 맞지 않으면 커밋 전에 한 번 더 확인한다.
- **subject 50자 검증**: 한국어 글자 수 기준(바이트 ❌). `[...subject].length`로 카운트한다.
- **빈 diff**: 변경사항이 없는데 `/commit`을 호출한 경우 — 커밋 없이 "변경된 파일이 없습니다"를 출력하고 종료한다.
