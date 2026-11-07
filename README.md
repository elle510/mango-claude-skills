# mango-claude-skills

Claude Code 개발 워크플로우 스킬 모음.

## 설치

먼저 마켓플레이스에 등록합니다 (전역 설정으로 저장되므로 **한 번만** 실행하면 됩니다):

```bash
/plugin marketplace add elle510/mango-claude-skills
```

### 전체 설치 (번들)

```bash
/plugin install mango-skills@mango-claude-skills
```

### 개별 설치

```bash
/plugin install commit@mango-claude-skills
/plugin install claudemd-review@mango-claude-skills
/plugin install make-skill@mango-claude-skills
```

## 스킬 목록

### `commit`

git 변경사항을 분석해 Conventional Commits 형식으로 메시지를 제안하고 커밋을 실행한다.
보호 브랜치(`main`/`master`) 직접 커밋을 차단하고, `.env` · 인증서 · 빌드 산출물(`dist/`, `node_modules/` 등) 같은 위험 파일을 사전 스캔해 사용자 확인 후에만 add 한다.

**호출:** `/commit` 또는 "커밋해줘"

### `claudemd-review`

프로젝트 내 모든 CLAUDE.md 파일을 Claude Code 공식 원칙 6가지 기준으로 감사한다.

**호출:** `/claudemd-review` 또는 "CLAUDE.md 검토해줘"

### `make-skill`

새 Claude Code 스킬 생성, 기존 스킬 수정/개선, 스킬 구조 리뷰를 수행한다.

**호출:** `/make-skill` 또는 "스킬 만들어줘"

## 업데이트

### 플러그인 내용 업데이트

마켓플레이스 카탈로그 갱신과 플러그인 실제 내용 업데이트는 별개의 커맨드입니다.

**전체 번들 업데이트:**

```bash
claude plugin update mango-skills@mango-claude-skills
```

**개별 스킬 업데이트:**

```bash
claude plugin update commit@mango-claude-skills
claude plugin update claudemd-review@mango-claude-skills
claude plugin update make-skill@mango-claude-skills
```

**마켓플레이스 카탈로그만 갱신** (새 플러그인 추가 여부 반영):

```bash
/plugin marketplace update
```

### Auto-update 설정

> 이 설정은 플러그인을 **설치한 사용자**가 자신의 Claude Code에서 직접 합니다.

서드파티 마켓플레이스는 auto-update가 기본 **비활성화**입니다. 활성화하면 Claude Code 시작 시 마켓플레이스 갱신 + 설치된 플러그인 업데이트가 자동으로 실행됩니다.

**설정 방법 (UI):**

1. `/plugin` 실행
2. `Marketplaces` 탭 선택
3. `mango-claude-skills` 선택
4. `Enable auto-update` 선택

## 삭제

**플러그인 삭제:**

```bash
/plugin uninstall mango-skills@mango-claude-skills
```

**개별 스킬 삭제:**

```bash
/plugin uninstall commit@mango-claude-skills
/plugin uninstall claudemd-review@mango-claude-skills
/plugin uninstall make-skill@mango-claude-skills
```

**마켓플레이스 등록 해제** (등록된 소스 제거 + 해당 마켓플레이스에서 설치한 플러그인도 함께 제거):

```bash
/plugin marketplace remove mango-claude-skills
```

**설정 파일 수동 정리** (커맨드로 제거가 안 될 경우):

설치 범위에 따라 아래 설정 파일 중 하나의 `enabledPlugins`에 항목이 남아 있습니다.

| 설치 범위 | 파일 |
| --------- | ---- |
| user (기본) | `~/.claude/settings.json` |
| project | `.claude/settings.json` |
| local | `.claude/settings.local.json` |

해당 파일에서 `@mango-claude-skills`로 끝나는 키만 지웁니다. 다른 플러그인 항목이나 권한 설정은 그대로 둡니다 (파일 전체를 삭제하거나 `enabledPlugins`를 통째로 비우지 마세요).

```jsonc
{
  "enabledPlugins": {
    "mango-skills@mango-claude-skills": true   // ← 이 줄만 삭제
  }
}
```
