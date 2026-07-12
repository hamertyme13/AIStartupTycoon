# Architecture

AI Startup Tycoon is a SwiftUI game organized around a central observable `GameManager` and small model/view modules.

## App Entry

- `Views/Shared/AIStartupTycoonApp.swift`
  - App entry point.
  - Rogue Circuit theme tokens and card styling.
  - Opening presentation scene.

- `Views/Dashboard/MainTabView.swift`
  - Main tab layout.
  - Sheets for new game setup, events, reports, and outcomes.

## State

- `Managers/Core/GameManager.swift`
  - Owns game state and high-level actions.
  - Advances time and months.
  - Applies events, outcomes, economy updates, customer churn, customer success, and monthly pulse.

- `Models/Company/Company.swift`
  - Main company data model.
  - Derived metrics such as health, runway, monthly profit, product quality, support capacity, and customer success cost.

- `Managers/Persistence/SaveManager.swift`
  - Encodes a snapshot of the game into local JSON.
  - Includes schema versioning so future builds can migrate saves safely.

## Simulation

- `Managers/Simulation/EventManager.swift`
  - Random player-choice events.
  - Events can affect cash, valuation, customers, research, reputation, market share, and satisfaction.

- `Managers/Simulation/NewsManager.swift`
  - Contextual monthly headlines.
  - Falls back to competitor headlines when company-specific news is less relevant.

- `Managers/Simulation/GameManager+CompetitorSimulation.swift`
  - Monthly competitor growth.
  - Competitor hiring, funding, marketing, research spend, model releases, and share normalization.

## Gameplay Modules

- `Managers/Core/GameManager+Employees.swift`
- `Managers/Core/GameManager+Research.swift`
- `Managers/Core/GameManager+AIModels.swift`
- `Managers/Core/GameManager+Investors.swift`
- `Managers/Core/GameManager+Products.swift`
- `Managers/Core/GameManager+Market.swift`
- `Managers/Core/GameManager+Reports.swift`

These extensions keep feature-specific behavior discoverable while sharing the same company state.

## Views

- `Views/Dashboard`
  - Company overview, launch checklist, objectives, projections, news, and time controls.

- `Views/Company`
  - Employees, products, office, board, and investor-related company management.

- `Views/Innovation`
  - Research and AI model progression.

- `Views/Industry`
  - Market, marketing, customer success, and competitor-facing surfaces.

## Validation

Fast syntax check:

```bash
swiftc -parse $(rg --files -g '*.swift')
```

Full local iOS build:

```bash
env DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild -project AIStartupTycoon.xcodeproj -scheme AIStartupTycoon -configuration Debug -destination generic/platform=iOS -derivedDataPath /tmp/AIStartupTycoonDerivedData CODE_SIGNING_ALLOWED=NO build
```

## Feature Placement Guide

- New player choices belong in `EventManager` when they are random dilemmas.
- New monthly background behavior belongs near `nextMonth()` in `GameManager`.
- New persistent state must be added to `Company`, `SaveManager.CompanySnapshot`, and restore logic.
- New dashboard summaries should be cards, not modal-only information.
- New App Store or design process notes belong in `Documentation/Roadmap.md` or `Documentation/Changelog.md`.
