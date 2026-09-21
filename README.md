# KitoNetKit

Simulates offline, high-latency, timeout, and forced-error-response network
conditions inside a running app, per endpoint, without touching the backend.
**Debug/QA tooling — never link into a release build.** See
[KitoDevKitDebug](https://github.com/WykSofts-Inc/KitoDevKitDebug) for the
umbrella and the release-safety rule.

## Install

```swift
#if DEBUG
.package(url: "https://github.com/WykSofts-Inc/KitoNetKit.git", from: "1.0.0"),
#endif
```

## Samples

**Install once at launch:**
```swift
let configuration = URLSessionConfiguration.default
#if DEBUG
KitoNetKit.install(on: configuration)
#endif
let session = URLSession(configuration: configuration)
```

**Simulate offline for one endpoint:**
```swift
#if DEBUG
KitoNetKit.setScenario(KitoNetScenario(urlPattern: "api/payments", condition: .offline))
#endif
```

**Simulate a slow connection:**
```swift
KitoNetKit.setScenario(KitoNetScenario(urlPattern: "api/products", condition: .latency(seconds: 3)))
```

**Force a specific error response, to test error-handling UI:**
```swift
let body = #"{"error":"insufficient_funds"}"#.data(using: .utf8)!
KitoNetKit.setScenario(KitoNetScenario(
    urlPattern: "api/payments/charge",
    condition: .forcedResponse(statusCode: 402, body: body)
))
```

**A debug-menu screen for QA to toggle scenarios without a rebuild:**
```swift
#if DEBUG
NavigationLink("Network Console") { KitoNetConsole() }
#endif
```

## License

MIT
