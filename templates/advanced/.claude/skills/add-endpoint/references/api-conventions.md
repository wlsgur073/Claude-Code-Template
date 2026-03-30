# TaskFlow API Conventions

Quick reference for the add-endpoint skill. See `docs/api-conventions.md` for the full specification.

## Route Patterns

- Collection: `GET /api/<resource>` — list with pagination
- Single: `GET /api/<resource>/:id` — fetch by ID
- Create: `POST /api/<resource>` — validate body with Zod schema
- Update: `PATCH /api/<resource>/:id` — partial update
- Delete: `DELETE /api/<resource>/:id` — soft delete (set `deleted_at`)

## Response Envelope

All responses use `sendSuccess()` or `sendError()` from `src/api/response.ts`:

```json
{ "ok": true, "data": { ... } }
{ "ok": false, "error": { "code": "NOT_FOUND", "message": "..." } }
```

## File Naming

- Handler: `src/api/<resource>.ts`
- Service: `src/services/<resource>-service.ts`
- Repository: `src/repos/<resource>-repo.ts`
- Model: `src/models/<resource>.ts`
- Tests: `tests/services/<resource>-service.test.ts`, `tests/api/<resource>.test.ts`
