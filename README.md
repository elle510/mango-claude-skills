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

**호출:** `/commit`

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

`.claude/settings.json`에서 `enabledPlugins` 항목을 비웁니다:

```json
{
  "enabledPlugins": {}
}
```

`.claude/settings.local.json` 파일을 삭제합니다:

```bash
rm .claude/settings.local.json
```

### Auto-update 설정

> 이 설정은 플러그인을 **설치한 사용자**가 자신의 Claude Code에서 직접 합니다.

서드파티 마켓플레이스는 auto-update가 기본 **비활성화**입니다. 활성화하면 Claude Code 시작 시 마켓플레이스 갱신 + 설치된 플러그인 업데이트가 자동으로 실행됩니다.

**설정 방법 (UI):**

1. `/plugin` 실행
2. `Marketplaces` 탭 선택
3. `mango-claude-skills` 선택
4. `Enable auto-update` 선택
