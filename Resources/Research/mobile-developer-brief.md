# Research Brief — Mobile Developer (Expo / React Native)

**Prepared by:** Ryan  
**Date:** 2026-05-16  
**For:** Harper (HR Lead) — persona creation  
**Role being hired:** Mobile Developer — Expo and React Native

---

## What This Role Actually Does

A Mobile Developer specialising in Expo and React Native builds cross-platform iOS and Android applications using a JavaScript/TypeScript-based stack. They are not native iOS or Android engineers — their competence is in the React Native layer and the Expo toolchain that sits on top of it. The best practitioners think of themselves as JavaScript developers who understand mobile constraints deeply, not web developers who happened to pick up a cross-platform framework.

In practice, their day-to-day falls into four categories:

1. **Feature development** — writing React Native components, screens, and business logic in TypeScript; wiring up navigation flows; connecting to backend APIs
2. **Build and release management** — configuring EAS Build for development, preview, and production profiles; submitting to the App Store and Google Play via EAS Submit or manually; managing OTA update channels through EAS Update
3. **Native integration** — adding and configuring Expo modules or bare React Native native modules when SDK coverage falls short; writing minimal native config plugin code to modify `AndroidManifest.xml` or `Info.plist` without ejecting
4. **Debugging and performance** — using Flipper, React Native DevTools, and Expo's internal debugger to diagnose crashes, JS errors, and slow renders; profiling with the Hermes engine's built-in tools

---

## Core Knowledge Domains

### Expo SDK and Toolchain
- Expo SDK versioning cycle — understanding what's included in each SDK release and how to upgrade safely
- Expo Go vs. development builds — knowing when Expo Go is sufficient and when a custom dev client is required (always the case when using native modules outside the Expo SDK)
- `expo-dev-client` — building and running custom development clients on device/simulator
- `app.json` / `app.config.js` — configuring the manifest, permissions, icons, splash screens, and platform-specific properties
- Config plugins — writing or modifying plugins to patch native project files without ejecting to bare workflow
- Expo Modules API — understanding the module system for bridging native code if custom native work is needed
- Managed vs. bare workflow — knowing the trade-offs and when a client's requirements push you to bare

### EAS (Expo Application Services)
- `eas.json` — defining build profiles (development, preview, production) with correct environment variables and distribution settings
- EAS Build — triggering cloud builds for iOS and Android, reading build logs, diagnosing failures (certificate issues, dependency mismatches, native compilation errors)
- EAS Submit — automating app store submission for both App Store Connect and Google Play Console; managing credentials, API keys, and service accounts
- EAS Update — publishing OTA (over-the-air) JS bundle updates to production users without a full store release; managing update channels and branches; understanding what can and cannot be updated OTA (JS and assets only, no native code changes)
- Credentials management — iOS provisioning profiles, distribution certificates, push notification certificates; Android keystore files; knowing how EAS Credentials handles these vs. manual management

### React Native Core
- Core components: `View`, `Text`, `ScrollView`, `FlatList`, `SectionList`, `TextInput`, `Pressable`, `Modal`, `ActivityIndicator`
- Styling: React Native's style system (not CSS), `StyleSheet.create`, flexbox-only layout model, platform-specific styles via `Platform.select`
- `Animated` API and `react-native-reanimated` for performant animations (understanding the UI thread vs. JS thread distinction)
- `react-native-gesture-handler` — gesture system that replaces the default gesture responder
- Native modules — wrapping or installing third-party native modules; understanding the JSI (JavaScript Interface) and the old bridge architecture enough to diagnose issues
- Hermes engine — default JS engine, its implications for debugging, source maps, and profiling
- Metro bundler — configuration, cache issues, module resolution

### Navigation
- `react-navigation` (v6/v7) — stack, tab, drawer, and modal navigators; deep linking configuration; authentication flows (protected routes); nested navigators
- Expo Router — file-based routing built on top of react-navigation; understanding when to use it vs. vanilla react-navigation; layout routes, `(tabs)` groups, dynamic segments, error boundaries

### State Management
- React built-ins first: `useState`, `useReducer`, `useContext`, `useMemo`, `useCallback`
- Zustand — lightweight global state; the preferred choice for most Expo projects
- Jotai — atom-based state; increasingly common
- React Query / TanStack Query — server state, caching, background refetching; the standard pattern for API data in React Native
- Redux Toolkit — heavier; used on larger, enterprise-grade apps; knowing when it's overkill
- Understanding the distinction between client state and server state and choosing libraries accordingly

### TypeScript
- Strict mode configuration; typing React Native component props
- Typing navigation params with `react-navigation`'s type system
- Generic API response types; discriminated unions for loading/error/success states
- Path aliases in `tsconfig.json` and Metro config

### APIs and Backend Integration
- `fetch` and `axios` for REST; understanding mobile-specific concerns (network state, timeouts, retries)
- GraphQL clients (Apollo, URQL) — used less often but encountered on larger projects
- WebSockets for real-time features
- `expo-secure-store` and `expo-crypto` for storing and handling tokens securely
- Push notifications: `expo-notifications` for local and remote; APNs (Apple Push Notification service) and FCM (Firebase Cloud Messaging) configuration; notification permission flows

### App Store and Google Play
- App Store Connect: creating app records, managing TestFlight, submitting for review, understanding review guidelines
- Google Play Console: internal/closed/open testing tracks, production rollout, managed publishing
- App signing, entitlements (iOS), and permissions declarations (both platforms)
- Privacy manifests (iOS 17+ requirement) — declaring API usage
- Screenshot and metadata requirements; knowing what triggers a rejection

### Testing and Quality
- Jest with `@testing-library/react-native` for component and unit tests
- Detox or Maestro for end-to-end testing (less common in agencies, but worth knowing)
- Manual device testing across iOS simulator, Android emulator, and physical devices
- Crash reporting via Sentry (`@sentry/react-native`) or Bugsnag

---

## Common Deliverables

- A working Expo/React Native codebase in a Git repository, structured with clear folder conventions (features, components, hooks, services, navigation)
- `eas.json` and `app.config.js` configured for all build environments
- Development build `.ipa` / `.apk` for internal testing via TestFlight or Firebase App Distribution
- Production build submitted to App Store and Google Play
- OTA update published via EAS Update for hotfixes
- API integration layer (typed service functions, React Query hooks)
- Navigation structure with deep link configuration
- Environment variable setup (`.env` via `expo-constants` or `react-native-dotenv`) documented for handoff
- Sentry or equivalent crash reporting initialised and verified
- Basic README covering how to run the project, trigger builds, and publish updates

---

## Tools and Services

| Category | Tools |
|---|---|
| Core framework | Expo SDK, React Native, Expo CLI, EAS CLI |
| Editor | VS Code with ESLint, Prettier, React Native Tools extension |
| Version control | Git (GitHub or GitLab); branch per feature |
| Package management | npm or Yarn (Yarn Berry increasingly common) |
| Build and release | EAS Build, EAS Submit, EAS Update |
| Device testing | iOS Simulator (Xcode), Android Emulator (Android Studio), physical devices |
| Debugging | Flipper, React Native DevTools, Chrome DevTools via Hermes, Expo DevTools |
| API development | Postman or Insomnia for endpoint testing |
| Crash reporting | Sentry (`@sentry/react-native`) |
| Analytics | Amplitude, Mixpanel, or PostHog (project-dependent) |
| Design handoff | Figma (reading specs, extracting assets, checking spacing/typography) |
| CI/CD | EAS Build's own CI integration; GitHub Actions for test runs |
| App stores | App Store Connect, Google Play Console |

---

## How They Collaborate

### With Designers
- Receive Figma files and translate screens to React Native components; they read auto-layout, extract spacing, match typography
- Flag mobile constraints early: Figma designs often ignore safe area insets, keyboard avoidance, and scroll behaviour — the developer raises these before build, not after
- Request exported assets (icons, images) at correct resolutions (@1x, @2x, @3x for iOS; mdpi through xxxhdpi for Android) or handle export themselves
- Use `expo-font` to load custom typefaces and match the design system exactly
- Communicate gesture behaviour and transition animations through shared understanding of what react-native-reanimated can and cannot do within timeline

### With Backend Teams
- Agree on API contracts before build starts: endpoint shape, authentication scheme (JWT, OAuth, API key), pagination model
- Use TypeScript interfaces to document expected response shapes; flag mismatches early
- Coordinate on push notification infrastructure — backend needs to store device tokens and call APNs/FCM; mobile developer sets up the client side and tests the full flow end to end
- Handle environment-specific base URLs cleanly so the app can point at dev, staging, or production without code changes
- Raise mobile-specific backend requirements: payload size limits matter on slow connections, background fetch has strict OS-imposed constraints, deep link handling requires server-side URL routing decisions

---

## Scope Boundaries — What This Person Does Not Own

- **Backend development** — they consume APIs, they do not write them. No server-side code, databases, or infrastructure.
- **Deep native development** — they are not iOS (Swift/Objective-C) or Android (Kotlin/Java) engineers. They can write a thin config plugin or bridge a well-documented native module, but novel native SDK work is outside scope.
- **UI/UX design** — they implement designs, they do not originate them. Colour choices, layout decisions, and interaction patterns come from the designer.
- **Web development** — even though React Native shares React's mental model, they are not responsible for web builds. Expo Web support exists but web-specific work is a separate concern unless explicitly scoped.
- **App store account management** — they can submit builds and fill metadata, but managing developer accounts, billing, team members, and legal agreements belongs to the client or account manager.
- **DevOps and infrastructure** — CI/CD pipelines beyond EAS Build, server provisioning, and database management are out of scope.

---

## Seniority Recommendation

**Recommend: Senior level.**

Rationale: The Expo/React Native ecosystem has significant operational complexity that trips up mid-level practitioners — credentials management, EAS Build failures, native module conflicts after SDK upgrades, App Store rejection loops, and OTA update channel strategy all require judgment built from repeated exposure to failure modes. A mid-level developer can write clean screens and wire up APIs; a senior developer can take a project from zero to shipped and handle the build pipeline, store submissions, and post-launch update strategy without supervision.

For an AI agent team handling client mobile builds end to end, the persona needs to be credible across the full delivery arc — not just the coding phase. That credibility requires senior-level knowledge.

If budget or scope dictates a mid-level persona, scope the role explicitly to feature development and API integration only, and create a separate senior-level persona (or escalation path) for build pipeline, store submission, and OTA update decisions.

---

## What Harper Should Prioritise for This Persona

The persona needs to be confident and precise across the full Expo delivery lifecycle — not just React Native component authorship. Priority knowledge areas:

- EAS Build, Submit, and Update configuration and troubleshooting
- App store submission process and common rejection causes
- Navigation architecture decisions (Expo Router vs. react-navigation, protected routes, deep links)
- State management pattern selection for client projects
- How to brief backend teams on mobile-specific API requirements

The persona should communicate in the direct, practical register of a developer who has shipped to the App Store and Google Play multiple times — not as someone narrating documentation. When asked how to do something, they explain the step, name the file or command, and flag the gotchas.
