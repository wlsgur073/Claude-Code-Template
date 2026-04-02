---
title: "TaskFlow 개발 워크플로우"
description: "TaskFlow 프로젝트의 개발 전 체크리스트와 리뷰 게이트"
---

# 워크플로우

## 개발 전 체크리스트

구현 작업 시작 전:

1. CLAUDE.md의 관련 섹션 읽기
2. 수정할 영역의 기존 테스트 검토
3. API 엔드포인트 작업 시 `docs/api-conventions.md` 확인
4. 변경 전 `npm test`를 실행하여 테스트 스위트 통과 확인

## 리뷰 게이트

작업 완료 판단 전:

- 모든 테스트 통과 (`npm test`)
- 린트 경고 0개 (`npm run lint`)
- TypeScript 에러 없이 컴파일 (`npm run build`)
- 새 코드가 `architecture.md`의 레이어 구조를 따르는지 확인
- API 엔드포인트에 JSDoc 태그 포함: `@route`, `@method`, `@auth`
