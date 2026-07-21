# Short Video

A Flutter short-video application built as an interview case study. The project
focuses on vertical video playback, playback lifecycle management, preload and
cache strategies, feed state, and cross-platform behavior.

## Run

```bash
flutter pub get
flutter run
```

VS Code workspace settings enable auto-save and hot reload during an active
Flutter debug session.

## Project status

The initial feature-first architecture and feed shell are in place. Feed data is
currently provided by a mock repository, while the visual surface reserves the
integration point for the video player.

See [`docs/architecture/README.md`](docs/architecture/README.md) for dependency
rules and directory ownership.
