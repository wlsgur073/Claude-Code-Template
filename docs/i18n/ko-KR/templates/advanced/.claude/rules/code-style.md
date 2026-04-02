---
title: "TaskFlow 코드 스타일 규칙"
description: "TaskFlow 프로젝트의 TypeScript 컨벤션"
---

# 코드 스타일

## 네이밍
- 변수와 함수: camelCase
- 클래스와 인터페이스: PascalCase
- 상수: UPPER_SNAKE_CASE
- 파일명: kebab-case (예: `user-service.ts`)
- 데이터베이스 컬럼: snake_case

## 포매팅
- 2칸 들여쓰기
- 최대 줄 길이: 100자
- 여러 줄 배열과 객체에 trailing comma
- 세미콜론 필수

## Import
- Import 그룹화: Node 빌트인, 외부 패키지, 내부 모듈
- named export 사용: `export { UserService }` (not `export default`)
- path alias 사용: `@/services/user-service` (not `../../../services/user-service`)

## 타입
- 객체 형태에는 type alias보다 interface 선호
- Zod 스키마를 원본으로 사용; `z.infer`로 TypeScript 타입 파생
- `any` 사용 금지 — `unknown`을 사용하고 타입 가드로 좁힐 것
