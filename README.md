# mango-claude-skills

Claude Code 개발 워크플로우 스킬 모음.

## 설치

```bash
/plugin marketplace add elle510/mango-claude-skills
/plugin install mango-skills@mango-claude-skills
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

```bash
/plugin marketplace update
```
