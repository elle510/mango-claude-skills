---
name: commit
description: 사용자가 /commit을 입력하거나 git 변경사항을 커밋하고 싶다고 할 때 사용한다. Conventional Commits 형식으로 메시지를 제안하고 사용자 확인 후 커밋을 실행한다.
---

# Skill: commit

## 호출 조건

사용자가 명시적으로 `/commit`을 입력했을 때만 실행한다.
Claude가 자동으로 판단하여 호출하지 않는다.

## 절차

### 1. 변경사항 파악

```bash
git status --short
git diff HEAD
```

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
- `style` — 포맷, CSS 변경
- `chore` — 빌드, 설정, 의존성

**scope 규칙:** 변경된 레이어/패키지 (예: `ui`, `web`, `shared`, `dashboard`)

**subject 규칙:**

- 한국어로 작성
- 50자 이내
- 마침표 없음

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

`git add -A && git commit -m "<최종 메시지>"` 실행.

## Gotchas

- **`git add -A`의 범위**: untracked 파일(`.env`, 빌드 산출물 등)도 포함된다. staged 되는 파일 목록을 1단계에서 반드시 확인하고 이상한 파일이 있으면 사용자에게 알릴 것.
- **N 응답 후 형식 검증 없음**: 사용자가 직접 입력한 메시지는 Conventional Commits 형식이 아닐 수 있다. 형식이 맞지 않으면 커밋 전에 한 번 더 확인한다.
- **빈 diff**: 변경사항이 없는데 `/commit`을 호출한 경우 — 커밋 없이 "변경된 파일이 없습니다"를 출력하고 종료한다.
