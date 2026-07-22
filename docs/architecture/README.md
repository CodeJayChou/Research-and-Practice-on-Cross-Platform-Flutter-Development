# Architecture

The application uses a feature-first structure. Each feature owns its data,
domain, and presentation code, so a feature can evolve without spreading changes
across global layer folders.

```text
lib/
├── app/                         # Application composition
│   ├── app.dart                 # Root MaterialApp
│   └── router/                  # Central route names and route table
├── core/                        # Code shared by multiple features
│   ├── theme/                   # Global application theme
│   └── utils/                   # Shared stateless utilities
├── features/
│   ├── home/                    # Home feature
│   ├── shop/                    # Shop feature
│   ├── publish/                 # Publishing feature
│   ├── messages/                # Messaging feature
│   ├── profile/                 # Profile feature
│   └── shell/                   # Root navigation composition
│       └── presentation/
│           ├── pages/           # Main shell page
│           └── widgets/         # Bottom navigation bar
└── main.dart                    # Process entry point
test/                             # Mirrors the lib feature structure
```

Each feature starts with only the folders it needs. Add `domain/` for business
entities and contracts, and `data/` for data sources and implementations when
the feature gains real business logic. Avoid empty architectural layers.

## Dependency rules

- `presentation` may depend on `domain`.
- `data` implements contracts declared by `domain`.
- `domain` must not depend on Flutter UI or infrastructure packages.
- Cross-feature business dependencies should go through public domain contracts.
- `shell` is a composition feature and may import root pages from other features.
- Code is promoted to `core` only after it is reused by more than one feature.

## Current composition

`CrossPlatformApp` configures the theme and centralized route table.
`MainShellPage` owns root-tab selection and composes the five feature pages.
`MainBottomNavigationBar` contains only bottom-navigation presentation. The
feature pages are intentionally minimal and can grow independently.
