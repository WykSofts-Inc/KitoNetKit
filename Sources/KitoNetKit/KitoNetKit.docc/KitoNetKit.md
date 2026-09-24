# ``KitoNetKit``

Simulate offline, slow, timed-out and forced-error network conditions per endpoint inside a running app.

## Overview

KitoNetKit intercepts `URLSession` requests with a custom URL protocol and
applies a simulated condition to any request whose URL matches a scenario's
pattern — without touching the backend. Use it to exercise loading, retry and
error-handling UI during development and QA.

> Important: KitoNetKit is debug and QA tooling. Never link it into a release
> build; wrap the package dependency and every call site in `#if DEBUG`.

Install it once on the `URLSessionConfiguration` your networking layer uses, then
register scenarios. A scenario's `urlPattern` is matched against the request's
absolute URL as a regular expression, and registering a scenario replaces any
existing one with the same pattern.

```swift
let configuration = URLSessionConfiguration.default
#if DEBUG
KitoNetKit.install(on: configuration)
KitoNetKit.setScenario(KitoNetScenario(urlPattern: "api/payments", condition: .offline))
KitoNetKit.setScenario(KitoNetScenario(urlPattern: "api/products", condition: .latency(seconds: 3)))
#endif
let session = URLSession(configuration: configuration)
```

``KitoNetConsole`` is a ready-made debug-menu screen that lets QA toggle
scenarios without a rebuild.

## Topics

### Essentials

- ``KitoNetKit/KitoNetKit``
- ``KitoNetScenario``

### Debug Console

- ``KitoNetConsole``

### Errors

- ``KitoNetKitError``
