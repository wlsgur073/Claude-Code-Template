# Generate Skill Refactoring

**Created:** 2026-03-30

## Goal

393줄짜리 단일 SKILL.md를 공식 플러그인 패턴(plugin-dev, superpowers)에 맞게 skills/ 하위 디렉토리로 분리. 기능 변화 없이 구조만 개선.

## Current

```
plugin/skills/generate/
└── SKILL.md (393 lines — 모든 로직이 하나의 파일에)
```

## Target

```
plugin/skills/generate/
├── SKILL.md              ← 핵심 흐름 (Phase 0 경로 결정 + Phase 4 마무리)
├── references/
│   └── best-practices.md ← Claude Code 설정 모범 사례 (생성 시 품질 기준)
└── templates/
    ├── starter.md        ← STARTER PATH 생성 규칙 (Phase 1S~3S)
    └── advanced.md       ← ADVANCED PATH 생성 규칙 (Phase 1A~3A)
```

## Steps

1. 현재 SKILL.md 분석 — 각 Phase의 경계와 의존성 파악
2. templates/starter.md 분리 — Phase 1S~3S (새 프로젝트 경로)
3. templates/advanced.md 분리 — Phase 1A~3A (기존 프로젝트 경로)
4. references/best-practices.md 작성 — 생성 품질 기준 (CLAUDE.md 200줄 제한 등)
5. SKILL.md 핵심 흐름만 유지 — Phase 0 + Phase 4 + 분리된 파일 참조
6. 검증 — 리팩토링 후 /claude-code-template:generate 정상 동작 확인
7. 버전 범프 — 구조 변경이므로 patch (2.2.1)

## Constraints

- 기능 변화 없음 — 사용자 관점에서 동일하게 동작해야 함
- SKILL.md에서 분리된 파일을 자연스럽게 참조하는 방식 확인 필요
- ko-KR 번역은 이 작업에 포함하지 않음 (별도 작업)

## Success Criteria

- /claude-code-template:generate 실행 시 starter/advanced 양쪽 경로 정상 동작
- SKILL.md가 200줄 이하로 축소
- 분리된 파일들이 공식 플러그인 하위 디렉토리 컨벤션 준수
