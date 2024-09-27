# Mixpanel for SwiftfulLogging ✅

Add Mixpanel support to a Swift application through SwiftfulLogging framework.

See documentation in the parent repo: https://github.com/SwiftfulThinking/SwiftfulLogging

## Example configuration:
```swift
// Example
#if DEBUG
let logger = LogManager(services: [ConsoleService()])
#else
let logger = LogManager(services: [MixpanelService(), FirebaseAnalyticsService(), AnotherDependencyService()])
#endif
```

## Example actions:

You may call identifyUser every app launch.

```swift
logger.trackEvent(eventName: String)
logger.trackScreenView(eventName: String)
logger.identifyUser(userId: String, name: String?, email: String?)
logger.addUserProperties(dict: [String: Any])
logger.deleteUserProfile()
```

## TODO

- [ ] Add alias support?
