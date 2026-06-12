# brain_box

# 🧠 Brain Box

<p align="center">
  <img src="assets/images/logo.png" alt="Brain Box Logo" width="150"/>
</p>

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

| Category | Package / Technology |
|---|---|
| **Framework** | Flutter (Dart) — portrait-only mobile app |
| **State Management** | `flutter_bloc` / `bloc` — Cubit pattern throughout |
| **Navigation** | `go_router` — declarative routing with named routes |
| **Local Storage** | `hive` / `hive_flutter` — NoSQL key-value persistence |
| **Dependency Injection** | `get_it` — service locator pattern |
| **Audio** | `audioplayers` — background music & SFX with dual players |
| **Responsive Layout** | `sizer` — screen-size-adaptive sizing units (`px`) |
| **Splash Screen** | `flutter_native_splash` — native splash with lifecycle preserve |
| **Equality** | `equatable` — value equality for BLoC states |
| **String Utils** | `characters` — grapheme-cluster-aware string iteration (typing game) |
| **Localisation** | `intl` / `flutter_localizations` — i18n scaffold (English baseline) |
| **Architecture** | Clean Architecture — `data / domain / presentation` layers per feature |

---

## 🗂️ Project Structure

```
lib/
├── main.dart                        # Entry point, Hive init, system UI setup
├── locator.dart                     # GetIt dependency injection setup
├── app/
│   ├── app.dart                     # Root App widget, theme & audio lifecycle
│   └── app_bloc_provider.dart       # Global BlocProvider tree
├── generated/                       # Intl generated localisation files
├── l10n/                            # ARB localisation strings
└── src/
    ├── api/                         # API client, interceptor, endpoints (scaffold)
    ├── config/
    │   ├── constants/               # AppString, AppColor, Assets paths
    │   └── router/                  # GoRouter config + Routes enum
    └── core/
    │   ├── animations/              # 10 reusable animation widgets
    │   ├── bloc/                    # Global cubits: AudioCubit, HapticsCubit
    │   ├── database/                # Hive Storage singleton + StorageStrings
    │   ├── entity/                  # Base entity classes
    │   ├── extensions/              # ColorExtension helpers
    │   ├── formatters/              # Input formatters
    │   ├── model/                   # Shared base models
    │   ├── screens/                 # Shared screen base classes
    │   ├── services/                # AudioService, ThemeService, HapticsService,
    │   │                            #   ConnectivityService, DeviceInfoService, etc.
    │   ├── usecase/                 # Base UseCase abstraction
    │   ├── utils/                   # Logging utilities
    │   └── widgets/                 # 20+ custom reusable Flutter widgets
    └── features/
        ├── home/                    # Home hub screen + HomeSelectionCubit
        ├── onboarding/              # Splash + Onboarding screens
        ├── setting/                 # Settings, Theme, Privacy, About screens
        ├── jurassic_journey/        # Dino runner game
        ├── kings_gambit/            # Full chess game with AI
        ├── piece_by_piece/          # Jigsaw puzzle game
        ├── slide_mastermind/        # 15-tile sliding puzzle
        ├── tic_tac_twist/           # Tic-Tac-Toe game
        └── quick_type_quest/        # Typing speed test
```

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

## 🚀 Installation & Run Instructions

### Prerequisites

- Flutter SDK **3.x** or later ([install guide](https://docs.flutter.dev/get-started/install))
- Dart SDK **3.x** (bundled with Flutter)
- Android Studio / Xcode (for device/emulator)
- A physical device or emulator (portrait orientation required)

### Steps

```bash
# 1. Clone the repository
git clone https://github.com/your-org/brain_box.git
cd brain_box

# 2. Install dependencies
flutter pub get

# 3. Generate Hive adapters (if needed)
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Run on a connected device or emulator
flutter run

# 5. Build a release APK (Android)
flutter build apk --release

# 6. Build for iOS
flutter build ios --release
```

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
