# TestFlight QA Checklist

Use this checklist before each TestFlight upload and during the first internal beta cycle.

## Build Gate

- Confirm the branch has only intentional changes staged.
- Run `swiftc -parse $(rg --files -g '*.swift')`.
- Run `git diff --check`.
- Run a generic iOS Debug build with signing disabled.
- Run a generic iOS Release archive validation with signing disabled.
- Create a signed Release archive in Xcode for App Store Connect upload.

## Device Matrix

- Small iPhone: first-session flow, dashboard, employee cards, product cards, investors, and modal sheets.
- Large iPhone: long company names, monthly reports, opening scene, and tab navigation.
- iPad: split layouts, landscape, wide cards, and modal presentation.
- Dark mode: all core screens must remain readable.
- Reduced Motion: opening scene should remain understandable and not block play.

## First Session

- Fresh install shows the opening scene.
- New game setup asks for founder name and company name.
- Empty founder name falls back to `Founder`.
- Empty company name falls back to `Rogue AI Labs`.
- Starting a new game replays the opening scene.
- Launch checklist can be completed through normal play.

## Save And Reset

- Existing saves migrate without crashing.
- Schema version `4` saves and restores founder name.
- Resetting the game returns to new game setup.
- Starting a second new game clears old events, reports, outcome state, and stale company data.
- Closing and reopening the app restores the current game.

## Core Loop

- Hiring, firing, morale, burnout, loyalty, and poaching are understandable.
- Product strategy changes affect revenue, satisfaction, and research as expected.
- Research costs money and competitors are affected by research spending.
- Contracts and enterprise pilots provide useful early/mid-game cash without trivializing runway.
- Investors have distinct contributions, personalities, ownership stakes, and relationship pressure.
- Competitors feel active but not unfair.

## Balance Pass

- Play one conservative bootstrapped run.
- Play one aggressive VC run.
- Play one AI Winter recovery run.
- Play one Open Source War run.
- Check at least one IPO route.
- Check at least one acquisition route.
- Check at least one frontier lab or AGI route.
- Note any dead ends, money exploits, or impossible goals.

## App Store Connect

- Bundle ID matches `com.roguecircuit.AIStartupTycoon`.
- Version and build number are incremented for upload.
- App icon appears correctly.
- Privacy policy URL is public.
- Support URL or support email is ready.
- Beta app description is clear.
- Beta review notes explain that the game is a local startup tycoon sim.
- Test information tells testers what to focus on.
- External testing is added only after the first TestFlight beta review is approved.

## Privacy Review

- Current beta stores gameplay locally on device.
- If Game Center is enabled, update privacy disclosures and App Store Connect configuration.
- If analytics or crash tooling is added, document what is collected.
- If cloud saves are added, update privacy disclosures and support documentation.
- If user-generated content or multiplayer is added, add moderation and reporting plans.

## Exit Criteria For External Beta

- No known launch blockers.
- No clipped dashboard text on small iPhones.
- No broken new-game or reset flow.
- Save migration verified.
- At least three full early-game runs completed.
- Privacy/support links are live.
- Signed Release archive uploads to App Store Connect.
