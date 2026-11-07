# Architecture

The repository is a two-app portfolio project:

- `mobile/` — Flutter client
- `backend/` — FastAPI API
- `docs/` — setup and design notes

This document describes the **foundation** only. Feature modules are not implemented yet.

## Mobile

The Flutter app uses a feature-first layout with shared core code:

```text
mobile/lib/
├── main.dart
├── app/                 # composition root
│   ├── app.dart
│   ├── router.dart
│   └── di/injection.dart
├── core/                # shared infrastructure
└── features/            # empty folders reserved for later modules
```

| Concern | Choice |
| --- | --- |
| State management | `flutter_bloc` (feature BLoCs will be added later) |
| Navigation | `go_router` |
| Dependency injection | `get_it` |
| HTTP | `Dio` via `DioClient` |
| Local persistence | Drift + SQLite (`AppDatabase`) |
| Secure tokens | `flutter_secure_storage` |
| Connectivity hint | `connectivity_plus` (`NetworkInfo`) |

**Offline-first intent:** writes and reads should go to Drift first. The API is used to sync when a connection *appears* available. `NetworkInfo.hasConnectionHint` is only a hint; a request can still fail. Failures are mapped from `AppException` to `Failure` and returned as `Result<T>`.

Domain layers for features will follow:

`presentation (Bloc/UI) → application (use cases) → domain → data (API + Drift)`

Do not put HTTP or SQL types in presentation code.

## Backend

FastAPI is split by responsibility:

| Layer | Location |
| --- | --- |
| HTTP routes | `app/api/` |
| Settings, logging, JWT/password helpers | `app/core/` |
| Engine and sessions | `app/db/` |
| SQLAlchemy models | `app/models/` |
| Pydantic request/response schemas | `app/schemas/` |
| Business rules | `app/services/` |
| Database access | `app/repositories/` |

`main.py` only creates the app, attaches CORS, and includes routers. It does not contain business logic.

SQLAlchemy engines are created lazily. Importing and starting the API does **not** require PostgreSQL to be running. A live database is required only when a database-backed endpoint (or Alembic) is used.

## Authentication foundation

Password hashing (`bcrypt`) and JWT helpers exist in `app/core/security.py`. Auth routes, user tables, and login screens are **not** implemented in this foundation pass.
