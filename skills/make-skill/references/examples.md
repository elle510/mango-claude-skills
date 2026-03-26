# 좋은/나쁜 사례 모음

## Description 필드 사례

### 나쁜 예 (요약형)

```json
"description": "배포 관련 스킬"
"description": "FSD 아키텍처 리뷰를 수행한다"
"description": "커밋 메시지 생성 스킬"
"description": "스킬을 만드는 스킬"
```

문제: Claude가 "언제 써야 하는가"를 판단할 수 없다.

### 좋은 예 (트리거 조건형)

```json
"description": "사용자가 /commit을 입력하거나 git 변경사항을 커밋하고 싶다고 할 때 사용한다."

"description": "사용자가 FSD 규칙 확인, 아키텍처 리뷰, import 방향 검사, /fsd-review를 요청할 때 사용한다."

"description": "사용자가 새 스킬을 만들거나 기존 스킬을 개선하고 싶다고 할 때, 또는 /make-skill을 입력할 때 사용한다."

"description": "사용자가 서비스를 프로덕션에 배포하려 하거나, PR 머지 후 배포 상태를 확인하려 할 때 사용한다."
```

---

## Gotchas 섹션 사례

### 나쁜 예 (없거나 너무 범용적)

```markdown
## 주의사항

- 오류가 발생하면 사용자에게 알린다.
- 파일을 수정하기 전에 내용을 확인한다.
```

문제: 모든 스킬에 해당하는 범용 주의사항. 이 스킬에서만 발생하는 함정이 없다.

### 좋은 예 (구체적인 실수 케이스)

```markdown
## Gotchas

- **기존 스킬 덮어쓰기**: Write 도구는 기존 파일을 읽지 않으면 실패한다.
  수정 전 반드시 Read로 읽고 시작할 것.

- **settings.json 등록 누락**: 파일만 만들어도 `/skill-name`으로 호출되지 않는다.
  반드시 `/update-config`로 settings.json에 등록해야 한다.

- **단일 유형 규칙 위반**: 라이브러리 레퍼런스 + 코드 스캐폴딩처럼 두 유형을 한 스킬에 넣으면
  사용자가 언제 써야 할지 모른다. 유형을 하나만 선택하거나 두 스킬로 분리할 것.
```

---

## SKILL.md 구조 사례

### 나쁜 예 (모든 것을 한 파일에)

```markdown
# Skill: deploy

[500줄의 배포 절차, API 문서, 환경변수 목록, 트러블슈팅 가이드가 모두 포함됨]
```

문제: 컨텍스트 낭비. 대부분은 사용하지 않는 내용.

### 좋은 예 (점진적 공개)

```markdown
# Skill: deploy

## 발동 조건

사용자가 프로덕션 배포를 요청할 때.

## 참조 파일

| 파일                            | 내용              |
| ------------------------------- | ----------------- |
| `references/environments.md`    | 환경별 설정값     |
| `references/troubleshooting.md` | 배포 실패 시 대응 |
| `scripts/health-check.sh`       | 배포 후 헬스체크  |

## 절차 (요약)

1. 환경 확인 (`references/environments.md` 참고)
2. 빌드 실행
3. 배포
4. 헬스체크 (`scripts/health-check.sh` 실행)

## Gotchas

- 스테이징 없이 프로덕션 직접 배포 금지
- 헬스체크 통과 전까지 배포 완료 선언하지 말 것
```

---

## 스킬 폴더 구조 사례

### 단순한 스킬 (단일 파일 허용)

```
.claude/skills/commit/
└── SKILL.md    ← 절차가 짧고 참조 파일 불필요
```

### 복잡한 스킬 (폴더 구조 필요)

```
.claude/skills/deploy/
├── SKILL.md
├── references/
│   ├── environments.md
│   └── troubleshooting.md
├── assets/
│   └── deployment-checklist.md
└── scripts/
    └── health-check.sh
```

**판단 기준:** SKILL.md가 100줄 넘어가거나, 자주 참조되지 않는 상세 내용이 있으면 분리한다.
