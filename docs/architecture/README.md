# Architecture

The application uses a feature-first structure. Each feature owns its data,
domain, and presentation code, so a feature can evolve without spreading changes
across global layer folders.

```text
lib/
├── app/                         # Application composition and routes
├── core/                        # Shared theme and reusable UI primitives
├── features/
│   ├── feed/
│   │   ├── data/                # Repository implementations and data sources
│   │   ├── domain/              # Entities and repository contracts
│   │   └── presentation/        # Controllers, pages, and widgets
│   └── shell/                   # Root tab navigation
└── main.dart                    # Process entry point
```

## Dependency rules

- `presentation` may depend on `domain`.
- `data` implements contracts declared by `domain`.
- `domain` must not depend on Flutter UI or infrastructure packages.
- Cross-feature imports should go through a feature's public domain contract.
- Code is promoted to `core` only after it is reused by more than one feature.

## Current composition

`ShortVideoApp` creates the app theme and route table. `MainShellPage` owns the
five root tabs. `VideoFeedPage` creates a `VideoFeedController` with the current
mock repository; dependency injection can replace this composition point when a
remote API is introduced.

The feed UI intentionally renders a placeholder background. The next player
iteration can consume `VideoPost.videoUrl` without changing the domain or page
navigation structure.
