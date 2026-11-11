# NativeTwitch

NativeTwitch is an open-source native macOS app that lists the live Twitch streams that the user follows. It uses SwiftUI, Metal shaders, and the Twitch Helix API, with no third-party packages. Status: shipped through GitHub Releases, current line v4.

## Commands

| Task | Command |
|------|---------|
| Build | `xcodebuild -project NativeTwitch.xcodeproj -scheme NativeTwitch build` |
| Release build | `xcodebuild -project NativeTwitch.xcodeproj -scheme NativeTwitch -configuration Release archive` |

There is no test target. The `swift.yml` workflow runs only `swift package init` and does not build the app.

## Architecture

| Part | Role |
|------|------|
| `ViewModels/TwitchDeviceAuth.swift` | Twitch OAuth device-code flow (start, then poll for the token) |
| `ViewModels/TwitchVM.swift` | Login, logout, user ID lookup, and the followed-streams fetch |
| `Models/Constants.swift` | Helix endpoints, the public client ID, and the OAuth scopes |
| `Helpers/KeychainHelper.swift` | Stores the access token in the Keychain (`KeychainSwift.shared`) |
| `Shaders/` | Metal shaders for the generative preview backgrounds |

- Default branch: `v4` (there is no `main`).
- Bundle ID: `com.aayush.opensource.NativeTwitch`. Deployment target: macOS 14.
- Related app: `../NativeChat` is the Twitch chat client.

## Rules

- This repository is public. Keep tokens in the Keychain only. The Twitch client ID in `Constants` is public and is not a secret.
- Sign releases with the current Developer ID team (Optimal Life Technologies). Set `MARKETING_VERSION` in the project before a release.
- Publish a release as a notarized build on the GitHub Releases page. The README tells users to run `xattr -c` when Gatekeeper blocks the app.
- Use `Logger` from `Extensions/Logger+Extensions.swift`, not `print`.
