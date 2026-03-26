#!/bin/bash
# validate-skill.sh — 스킬 폴더 구조와 필수 항목 검증
# 사용법: bash skills/make-skill/scripts/validate-skill.sh skills/{skill-name}

set -e

SKILL_DIR="${1:-}"
PASS=0
FAIL=0

if [ -z "$SKILL_DIR" ]; then
  echo "사용법: $0 <skill-dir>"
  echo "예시:   $0 skills/my-skill"
  exit 1
fi

if [ ! -d "$SKILL_DIR" ]; then
  echo "오류: 디렉토리를 찾을 수 없습니다 — $SKILL_DIR"
  exit 1
fi

check() {
  local label="$1"
  local result="$2"  # "pass" or "fail"
  local hint="$3"

  if [ "$result" = "pass" ]; then
    echo "  [OK]  $label"
    PASS=$((PASS + 1))
  else
    echo "  [!!]  $label"
    [ -n "$hint" ] && echo "        -> $hint"
    FAIL=$((FAIL + 1))
  fi
}

echo ""
echo "=== 스킬 검증: $SKILL_DIR ==="
echo ""

# 1. SKILL.md 존재 여부
if [ -f "$SKILL_DIR/SKILL.md" ]; then
  check "SKILL.md 존재" "pass"
else
  check "SKILL.md 존재" "fail" "SKILL.md 파일을 만들어야 합니다."
fi

SKILL_MD="$SKILL_DIR/SKILL.md"

# 2. frontmatter name 필드
if grep -q "^name:" "$SKILL_MD" 2>/dev/null; then
  check "frontmatter name 필드 있음" "pass"
else
  check "frontmatter name 필드 있음" "fail" "SKILL.md 상단에 'name:' frontmatter를 추가하세요."
fi

# 3. frontmatter description 필드
if grep -q "^description:" "$SKILL_MD" 2>/dev/null; then
  check "frontmatter description 필드 있음" "pass"
else
  check "frontmatter description 필드 있음" "fail" "SKILL.md 상단에 'description:' frontmatter를 추가하세요."
fi

# 4. 발동 조건 섹션
if grep -q "발동 조건\|호출 조건\|트리거\|Trigger" "$SKILL_MD" 2>/dev/null; then
  check "발동 조건 섹션 있음" "pass"
else
  check "발동 조건 섹션 있음" "fail" "'## 발동 조건' 섹션을 추가하세요."
fi

# 5. Description이 요약형인지 체크 (단순 경고만)
if grep -qi "이 스킬은.*한다\|스킬입니다" "$SKILL_MD" 2>/dev/null; then
  check "Description이 트리거 조건형" "fail" \
    "발동 조건이 요약형으로 보입니다. '사용자가 X를 할 때' 형식으로 바꾸세요."
else
  check "Description이 트리거 조건형" "pass"
fi

# 6. Gotchas 섹션
if grep -q "Gotchas\|gotchas\|주의\|함정" "$SKILL_MD" 2>/dev/null; then
  check "Gotchas 섹션 있음" "pass"
else
  check "Gotchas 섹션 있음" "fail" "'## Gotchas' 섹션을 추가하세요. 처음엔 짧아도 됩니다."
fi

# 7. SKILL.md 길이 (100줄 초과 시 분리 권고)
if [ -f "$SKILL_MD" ]; then
  LINE_COUNT=$(wc -l < "$SKILL_MD")
  if [ "$LINE_COUNT" -le 100 ]; then
    check "SKILL.md 길이 적정 (${LINE_COUNT}줄)" "pass"
  else
    check "SKILL.md 길이 적정 (${LINE_COUNT}줄)" "fail" \
      "100줄 초과. 상세 내용을 references/ 또는 assets/로 분리하세요."
  fi
fi

# 8. references/ 폴더 (SKILL.md에 포인터가 있는데 폴더가 없는 경우)
if grep -q "references/" "$SKILL_MD" 2>/dev/null; then
  if [ -d "$SKILL_DIR/references" ]; then
    check "references/ 폴더 존재 (포인터 있음)" "pass"
  else
    check "references/ 폴더 존재 (포인터 있음)" "fail" \
      "SKILL.md에 references/ 포인터가 있는데 폴더가 없습니다."
  fi
fi

# 9. assets/ 폴더 (SKILL.md에 포인터가 있는데 폴더가 없는 경우)
if grep -q "assets/" "$SKILL_MD" 2>/dev/null; then
  if [ -d "$SKILL_DIR/assets" ]; then
    check "assets/ 폴더 존재 (포인터 있음)" "pass"
  else
    check "assets/ 폴더 존재 (포인터 있음)" "fail" \
      "SKILL.md에 assets/ 포인터가 있는데 폴더가 없습니다."
  fi
fi

# 결과 요약
echo ""
echo "=== 결과: ${PASS}개 통과 / ${FAIL}개 실패 ==="
echo ""

if [ "$FAIL" -eq 0 ]; then
  echo "모든 항목 통과. 스킬이 준비되었습니다."
else
  echo "위 항목을 보완하고 다시 실행하세요."
  exit 1
fi
