# API Package

Express REST server for TaskFlow. Owns src/routes/, src/repos/.

## Conventions

- Async handlers wrapped with asyncHandler
- Errors extend AppError
- Repositories in src/repos/ — no DB access in route handlers
