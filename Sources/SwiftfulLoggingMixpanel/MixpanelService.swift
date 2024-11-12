import Foundation
import Mixpanel
import SwiftfulLogging
import SendableDictionary

public struct MixpanelService: LogService {

    static var distinctId: String? {
        Mixpanel.mainInstance().distinctId
    }

    private var instance: MixpanelInstance {
        Mixpanel.mainInstance()
    }

    public init(token: String, loggingEnabled: Bool = false) {
        #if !os(OSX) && !os(watchOS)
        Mixpanel.initialize(token: token, trackAutomaticEvents: true)
        #else
        Mixpanel.initialize(token: token)
        #endif
        instance.loggingEnabled = loggingEnabled
    }

    public func identifyUser(userId: String, name: String?, email: String?) {
        instance.identify(distinctId: userId)

        if let name {
            instance.people.set(property: "$name", to: name)
        }
        if let email {
            instance.people.set(property: "$email", to: email)
        }
    }

    public func trackEvent(event: LoggableEvent) {
        // Mixpanel allows up to 5,000 User Properties, keys limited to 255 characters
        // https://docs.mixpanel.com/docs/data-structure/events-and-properties

        var properties: [String: MixpanelType] = [:]

        if let parameters = event.parameters {
            for (key, value) in parameters {
                let key = key.clipped(maxCharacters: 255)
                if let value = value as? MixpanelType {
                    properties[key] = value
                }
            }
        }

        Mixpanel.mainInstance().track(event: event.eventName, properties: properties.isEmpty ? nil : properties)
    }

    public func trackScreenView(event: any LoggableEvent) {
        trackEvent(event: event)
    }

    public func addUserProperties(dict: [String: Any], isHighPriority: Bool) {
        // Mixpanel allows up to 2,000 User Properties, keys limited to 255 characters
        // https://docs.mixpanel.com/docs/data-structure/user-profiles#
        
        var properties: [String: MixpanelType] = [:]

        for (key, value) in dict {
            let key = key.clipped(maxCharacters: 255)
            if let value = value as? MixpanelType {
                properties[key] = value
            }
        }
        
        if !properties.isEmpty {
            instance.people.set(properties: properties)
        }
    }

    public func deleteUserProfile() {
        instance.people.deleteUser()
    }
}
