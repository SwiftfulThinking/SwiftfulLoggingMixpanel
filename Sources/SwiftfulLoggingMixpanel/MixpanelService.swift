import Foundation
import Mixpanel
import SwiftfulLogging
import SendableDictionary

struct MixpanelProvider: LogService {

    private var instance: MixpanelInstance {
        Mixpanel.mainInstance()
    }

    init(token: String) {
        #if !os(OSX) && !os(watchOS)
        Mixpanel.initialize(token: token, trackAutomaticEvents: true)
        #else
        Mixpanel.initialize(token: token)
        #endif
        instance.loggingEnabled = false
    }

    func identifyUser(userId: String, name: String?, email: String?) {
        instance.identify(distinctId: userId)

        if let name {
            instance.people.set(property: "$name", to: name)
        }
        if let email {
            instance.people.set(property: "$email", to: email)
        }
    }

    func trackEvent(event: LoggableEvent) {
        let properties = event.parameters?.mapValues({ $0 as? MixpanelType })
        Mixpanel.mainInstance().track(event: event.eventName, properties: properties)
    }

    func trackScreenView(event: any LoggableEvent) {
        trackEvent(event: event)
    }

    func addUserProperties(dict: SendableDict) {
        let properties = dict.dict.mapValues({ $0 as? MixpanelType })
        instance.people.set(properties: properties)
    }

    func deleteUserProfile() {
        instance.people.deleteUser()
    }
}
