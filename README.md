# 🧠 Brain Box
<p align="center">
<img width="150" height="150" alt="logo"  src="https://github.com/user-attachments/assets/50b24409-ed06-4b91-96a7-7517f175dce4" />
</p>

<!-- <p align="center">
  <img src="<img width="720" height="720" alt="logo" src="https://github.com/user-attachments/assets/f750da51-8584-4dc8-827f-b4535c50b63c" />
" alt="Brain Box Logo" width="150"/>
</p> -->

<p align="center">
  A multi-game Flutter puzzle & brain-training app featuring six unique mini-games, rich theming, background music, haptic feedback, and a clean BLoC architecture.
</p>

---

## 📖 Table of Contents

- [Game Overview](#game-overview)
- [Game Description](#game-description)
- [Features](#features)
- [Mini-Games](#mini-games)
- [Gameplay Mechanics](#gameplay-mechanics)
- [Animations Used](#animations-used)
- [Controls](#controls)
- [Screens & Navigation Flow](#screens--navigation-flow)
- [Technologies Used](#technologies-used)
- [Project Structure](#project-structure)
- [Project Requirements & Configuration](#project-requirements--configuration)
- [Installation & Run Instructions](#installation--run-instructions)
- [Future Improvements](#future-improvements)

---

## 🎮 Game Overview

**Brain Box** is a Flutter-based mobile brain-training app that bundles six diverse mini-games into one polished experience. From a dinosaur runner and chess engine to jigsaw puzzles and a typing speed test, Brain Box challenges reflexes, memory, logic, and language — all wrapped in a themeable, animated UI with persistent local storage.

---

## 📝 Game Description

Brain Box presents players with a curated home screen from which they can jump into any of the six mini-games. Each game is self-contained with its own BLoC state management, settings, and scoring system. A global settings screen lets users personalise the app's theme, toggle background music, sound effects, and haptic feedback. Progress such as chess win/loss records is persisted across sessions using Hive local storage.

---

## ✨ Features

- **Six distinct mini-games** accessible from a single home hub
- **Four visual themes** — Default, Dark, Light, and Cosmic — with real-time switching
- **Background music** with per-session and lifecycle-aware playback (pauses on app background)
- **Sound effects** fully independent of background music
- **Haptic feedback** toggle for tactile responses
- **Persistent local storage** via Hive for game settings and chess statistics
- **Portrait-only lock** for consistent gameplay layout
- **Custom animated page transitions** (fade + horizontal slide) on every route
- **Smooth entrance animations** throughout the UI (slide, fade, scale, stagger)
- **Responsive layout** using the `sizer` package (adapts to any screen size)
- **Custom reusable widget library** (buttons, icons, images, text, dialogs, app bar)
- **Onboarding screen** for first-time users
- **Native splash screen** integration
- **Settings screen** with About, Privacy Policy, and Terms & Conditions sub-screens
- **Edge-to-edge display** with transparent status and navigation bars

---

## 🕹️ Mini-Games

### 1. 🦖 Jurassic Journey
An endless side-scrolling dinosaur runner inspired by the classic Chrome offline game. The dino runs automatically and the player must jump or duck to avoid cacti and pterodactyls. Difficulty increases as speed accelerates over time. Includes a **physics debug dialog** so players (or developers) can tune gravity, acceleration, jump velocity, and run velocity in real time.

### 2. ♟️ King's Gambit
A full chess implementation with:
- **vs AI** mode using a minimax algorithm with piece-square tables and opening book
- **vs Friend** (local two-player) mode
- **Puzzle** mode for tactical training
- Configurable AI difficulty, time limits, and player side
- Undo/Redo move support
- Promotion dialog for pawn promotion
- Persistent win/loss/draw statistics and recent game history
- Customisable piece themes and board appearance

### 3. 🧩 Piece by Piece
A jigsaw puzzle game where players reassemble cut-up images. Features:
- Multiple puzzle categories loaded from a JSON asset file
- Selectable difficulty levels (controlling number of pieces)
- Custom jigsaw-shaped piece clipping with interlocking tab/blank shapes
- Drag-and-drop piece placement with snap detection
- Completion screen with solve-time statistics

### 4. 🔢 Slide Mastermind
A classic **15-puzzle** (4×4 sliding tile puzzle). Players slide numbered tiles to arrange them in order. Features a live countdown timer and move counter to track performance.

### 5. ❌⭕ Tic-Tac-Twist
A two-player local Tic-Tac-Toe game on a 3×3 grid. Tracks cumulative X wins, O wins, and draws across sessions in a scoreboard. Cells animate with `AnimatedContainer` on each move.

### 6. ⌨️ Quick Type Quest
A typing speed and accuracy test. Players type a passage of generated words against a countdown timer. Results screen shows:
- Words Per Minute (WPM)
- Accuracy percentage
- Total and correct characters
- Time elapsed
Supports difficulty presets (Easy / Medium / Hard) and a custom time setting via a settings dialog.

---

## ⚙️ Gameplay Mechanics

| Game | Core Mechanic | Win Condition |
|---|---|---|
| Jurassic Journey | Physics simulation (gravity, velocity, acceleration) driving sprite movement | Survive as long as possible; score increases with time |
| King's Gambit | Minimax AI with piece-square table evaluation + opening book | Checkmate opponent or solve puzzle |
| Piece by Piece | Drag-and-drop jigsaw pieces with custom clipper shapes | All pieces placed in correct positions |
| Slide Mastermind | Slide tiles into adjacent empty space | Tiles arranged 1–15 in order |
| Tic-Tac-Twist | Alternate cell taps on 3×3 grid | Three marks in a row, column, or diagonal |
| Quick Type Quest | Real-time character-by-character comparison against generated text | Highest WPM/accuracy within time limit |

---

## 🎬 Animations Used

Brain Box has a rich custom animation library located in `lib/src/core/animations/`:

| Animation Class | Description | Usage |
|---|---|---|
| `SlideFromLeftAnimation` | Slides child in from the left with optional delay | Logo and titles on Home & Onboarding screens |
| `SlideFromRightAnimation` | Slides child in from the right with optional delay | Subtitles and paired elements |
| `SlideFromBottomAnimation` | Slides child in from the bottom with optional delay | Action buttons and bottom content |
| `FadeInAnimation` | Fades child from transparent to opaque | Soft content reveals |
| `ScaleAnimation` | Scales child from a small size to full with delay | Hero elements appearing on screen |
| `PulseAnimation` | Repeating scale pulse (press feedback) | Selected game cards and interactive indicators |
| `SmoothScaleAnimation` | Press-and-release scale shrink on tap | Primary tappable buttons and cards |
| `ScaleOnTap` | Lightweight scale-down on press | Icon buttons |
| `DialogEntranceAnimation` | Combined fade + scale + optional slide for dialogs | All modal dialogs (physics, settings, theme picker) |
| `StaggeredListAnimation` | Sequential entrance of list items with per-item delay | Game lists and card grids on home screen |
| **Route transitions** | Custom `FadeTransition` + `SlideTransition` (offset 0.06) | Every page navigation via `GoRouter` |
| `AnimatedContainer` | Flutter built-in, used for cell colour transitions | Tic-Tac-Twist board cells |

---

## 🎮 Controls

| Game | Control | Action |
|---|---|---|
| Jurassic Journey | Tap anywhere on screen | Jump / start game |
| Jurassic Journey | — | Duck (not yet implemented) |
| King's Gambit | Tap a piece, then tap destination | Move chess piece |
| King's Gambit | Tap undo/redo buttons | Undo / redo last move |
| Piece by Piece | Drag piece | Move jigsaw piece |
| Slide Mastermind | Tap a tile adjacent to the blank | Slide tile into blank space |
| Tic-Tac-Twist | Tap an empty cell | Place X or O mark |
| Quick Type Quest | Hardware/software keyboard | Type characters to match displayed text |

---

## 📱 Screens & Navigation Flow

```
Splash Screen
    └── Onboarding Screen
            └── Home Screen
                    ├── Jurassic Journey Screen
                    ├── King's Gambit Screen
                    │       ├── King's Gambit Puzzle Screen
                    │       └── King's Gambit Settings Screen
                    ├── Piece by Piece → Choose Your Puzzle Screen
                    │       └── Select Difficulty Screen
                    │               └── Piece by Piece Screen
                    │                       └── Puzzle Completed Screen
                    ├── Slide Mastermind Screen
                    ├── Tic-Tac-Twist Screen
                    ├── Quick Type Quest Screen
                    │       └── Quick Type Quest Result Screen
                    └── Settings Screen
                            ├── About Game Screen
                            ├── Privacy Policy Screen
                            └── Terms & Conditions Screen
```

---

## 🛠️ Technologies Used

| Category | Package / Technology | Version |
|---|---|---|
| **Framework** | Flutter (Dart) — portrait-only mobile app | `3.35.5` |
| **Language** | Dart | `^3.8.1` |
| **State Management** | `flutter_bloc` / `bloc` — Cubit pattern throughout | `^8.1.6` |
| **Navigation** | `go_router` — declarative routing with named routes | `^16.0.0` |
| **Local Storage** | `hive` / `hive_flutter` — NoSQL key-value persistence | `^2.2.3` / `^1.1.0` |
| **Dependency Injection** | `get_it` — service locator pattern | `^8.0.3` |
| **Audio** | `audioplayers` — background music & SFX with dual players | `^6.5.1` |
| **Game Engine** | `flame` + `flame_audio` — game loop & audio for Jurassic Journey | `^1.19.0` / `^2.1.0` |
| **Responsive Layout** | `sizer` — screen-size-adaptive sizing units (`px`) | `^3.0.5` |
| **Splash Screen** | `flutter_native_splash` — native splash with lifecycle preserve | `^2.4.7` |
| **Networking** | `dio` — HTTP client for API calls | `^5.8.0+1` |
| **Connectivity** | `connectivity_plus` — network status monitoring | `^6.1.4` |
| **Device Info** | `device_info_plus` — platform device metadata | `^11.5.0` |
| **Permissions** | `permission_handler` — runtime permission requests | `^12.0.0+1` |
| **Image** | `cached_network_image`, `image_picker` | `^3.4.1` / `^1.1.2` |
| **UI Extras** | `shimmer`, `toastification`, `carousel_slider`, `flutter_staggered_grid_view` | various |
| **Equality** | `equatable` — value equality for BLoC states | `^2.0.7` |
| **Localisation** | `flutter_localizations` / `intl_translation` — i18n scaffold | `^0.20.1` |
| **Architecture** | Clean Architecture — `data / domain / presentation` layers per feature | — |

---

Each feature follows **Clean Architecture** with three layers:

```
feature/
├── data/
│   ├── datasource/      # Local or remote data sources
│   ├── model/           # JSON-serialisable models
│   └── repository/      # Repository implementations
├── domain/
│   ├── entity/          # Pure Dart entity classes
│   ├── repository/      # Abstract repository interfaces
│   └── usecase/         # Business logic use cases
└── presentation/
    ├── bloc/            # Cubit + State files
    ├── screen/          # Full-page screen widgets
    └── widget/          # Feature-specific sub-widgets
```

---

## ⚙️ Project Requirements & Configuration

### 🔧 SDK & Tooling Versions

| Tool | Version |
|---|---|
| **Flutter** | `3.35.5` |
| **Dart** | `^3.8.1` |
| **Kotlin** | `2.1.0` |
| **JVM target** | `VERSION_11` |
| **Gradle** | `8.12` |
| **Android Gradle Plugin** | `8.7.3` |
| **Swift** | `5.0` |

---

### 📦 All Dependencies (`pubspec.yaml`)

#### Production Dependencies

| Package | Version | Purpose |
|---|---|---|
| `sizer` | `^3.0.5` | Responsive UI sizing |
| `flutter_native_splash` | `^2.4.7` | Native splash screen |
| `flutter_bloc` | `^8.1.6` | BLoC / Cubit state management |
| `equatable` | `^2.0.7` | Value equality for states |
| `connectivity_plus` | `^6.1.4` | Network connectivity monitoring |
| `shimmer` | `^3.0.0` | Shimmer loading placeholders |
| `dio` | `^5.8.0+1` | HTTP client for REST API calls |
| `http_parser` | `^4.1.2` | HTTP content-type parsing |
| `path_provider` | `^2.1.5` | Platform file-system paths |
| `hive_flutter` | `^1.1.0` | Hive Flutter integration |
| `hive` | `^2.2.3` | NoSQL local key-value storage |
| `device_info_plus` | `^11.5.0` | Device & OS metadata |
| `permission_handler` | `^12.0.0+1` | Runtime permission requests |
| `cached_network_image` | `^3.4.1` | Network image caching |
| `image_picker` | `^1.1.2` | Camera & gallery image picking |
| `path` | `^1.9.1` | File path utilities |
| `loading_animation_widget` | `^1.3.0` | Loading animation widgets |
| `lazy_load_scrollview` | `^1.3.0` | Paginated lazy scroll loading |
| `toastification` | `^3.0.3` | Toast / snackbar notifications |
| `go_router` | `^16.0.0` | Declarative navigation routing |
| `get_it` | `^8.0.3` | Service locator / DI container |
| `flutter_localization` | `^0.3.3` | Localisation utilities |
| `intl_translation` | `^0.20.1` | i18n message extraction |
| `flutter_advanced_switch` | `^3.1.0` | Custom toggle switch widget |
| `dropdown_button2` | `^2.3.9` | Enhanced dropdown button |
| `audioplayers` | `^6.5.1` | Background music & sound effects |
| `flame` | `^1.19.0` | 2D game engine (Jurassic Journey) |
| `flame_audio` | `^2.1.0` | Audio integration for Flame |
| `provider` | `^6.1.2` | Lightweight state / DI provider |
| `async` | `^2.11.0` | Async utilities (`unawaited`, etc.) |
| `flutter_masonry_view` | `^0.0.2` | Masonry/waterfall grid layout |
| `masonry_grid` | `^1.0.0` | Masonry grid layout helper |
| `flutter_staggered_grid_view` | `^0.7.0` | Staggered grid view |
| `carousel_slider` | `^5.1.1` | Horizontal carousel / slider |
| `cupertino_icons` | `^1.0.8` | iOS-style icon set |

#### Dev Dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter_test` | SDK | Widget & unit testing framework |
| `flutter_lints` | `^5.0.0` | Recommended lint rules |

---

### Prerequisites

- **Flutter `3.35.5`** — use [FVM](https://fvm.app/) (`fvm install 3.35.5 && fvm use 3.35.5`) or install manually from [flutter.dev](https://docs.flutter.dev/get-started/install)
- **Dart `^3.8.1`** (bundled with Flutter 3.35.5)
- **Android Studio** with Android SDK (API level 35) for Android builds
- **Xcode 15+** with CocoaPods for iOS builds (`sudo gem install cocoapods`)
- A physical device or emulator running **Android 5.0+ (API 21+)** or **iOS 14.0+**

### Notes

- The app is **portrait-only** — landscape mode is disabled at runtime.
- Hive storage is initialised automatically on first launch; no manual database setup is required.
- Asset files (images, audio, JSON puzzle data) must be present in the `assets/` directory and registered in `pubspec.yaml`.

---

## 🔮 Future Improvements

- **Online multiplayer** for King's Gambit and Tic-Tac-Twist via WebSocket
- **Leaderboard / high-score system** with cloud sync
- **Additional puzzle packs** for Piece by Piece (downloadable content)
- **Duck mechanic** for Jurassic Journey (currently stubbed)
- **Achievements & badges** system across all games
- **Animated splash / intro cutscene** replacing the static splash
- **Accessibility support** — screen reader labels and larger tap targets
- **Localisation** — full multi-language support (ARB scaffold already in place)
- **Push notifications** for daily challenges
- **Tablet / landscape layout** support for larger screens
- **Unit & widget tests** for BLoC cubits and game logic

---

<p align="center">Made with ❤️ using Flutter</p>
