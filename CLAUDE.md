# CLAUDE.md — mango-claude-skills

Claude Code 스킬 공개 배포 레포지토리. elle510의 개발 워크플로우 스킬 3종을 `/plugin` 시스템으로 배포한다.

## 레포 구조

```
mango-claude-skills/
├── .claude-plugin/
│   └── marketplace.json   # 플러그인 등록 설정
├── skills/
│   ├── commit/            # git 커밋 자동화
│   ├── claudemd-review/   # CLAUDE.md 감사
│   └── make-skill/        # 스킬 제작 도우미
└── README.md
```

## 플러그인 구성 결정사항

- **마켓플레이스 이름**: `mango-claude-skills`
- **번들 플러그인**: `mango-skills` — 3개 스킬 전체 포함
- **개별 플러그인**: `commit`, `claudemd-review`, `make-skill` — 각각 독립 설치 가능

설치 커맨드:

```bash
# 마켓플레이스 등록 (전역 설정 — 한 번만 실행)
/plugin marketplace add elle510/mango-claude-skills

# 전체 설치
/plugin install mango-skills@mango-claude-skills

# 개별 설치
/plugin install commit@mango-claude-skills
/plugin install claudemd-review@mango-claude-skills
/plugin install make-skill@mango-claude-skills
```

## SKILL.md 작성 규칙

- 상단에 반드시 frontmatter (`name`, `description`) 포함
- `description`은 요약이 아닌 트리거 조건으로 작성: "사용자가 X를 할 때 사용한다"
- `Gotchas` 섹션 필수
- 상세 내용은 `references/`, `assets/`로 분리 (점진적 공개)

## GitHub

- **레포**: https://github.com/elle510/mango-claude-skills
- **브랜치**: main
- 스킬 수정 후 push하면 `/plugin marketplace update`로 사용자 갱신 가능
