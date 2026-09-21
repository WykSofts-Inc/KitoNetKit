//
//  KitoNetKit.swift
//  KitoNetKit
//
//  Created by Wycliff on 9/19/26.
//  Copyright © 2026 wyksoftsinc.com. All rights reserved.
//

import Foundation

/// The scenario registry `KitoNetURLProtocol` consults. Populate it from a
/// debug menu or a QA scenario picker; every registered `URLSession` request
/// matching a scenario's `urlPattern` is intercepted before it reaches the
/// network.
public enum KitoNetKit {
    public private(set) static var scenarios: [KitoNetScenario] = []

    /// Call once, early (e.g. app launch in DEBUG), on the `URLSessionConfiguration`
    /// your networking layer uses.
    public static func install(on configuration: URLSessionConfiguration) {
        var protocolClasses = configuration.protocolClasses ?? []
        if !protocolClasses.contains(where: { $0 == KitoNetURLProtocol.self }) {
            protocolClasses.insert(KitoNetURLProtocol.self, at: 0)
        }
        configuration.protocolClasses = protocolClasses
    }

    public static func setScenario(_ scenario: KitoNetScenario) {
        scenarios.removeAll { $0.urlPattern == scenario.urlPattern }
        scenarios.append(scenario)
    }

    public static func removeScenario(urlPattern: String) {
        scenarios.removeAll { $0.urlPattern == urlPattern }
    }

    public static func clearAll() {
        scenarios.removeAll()
    }

    static func scenario(for url: URL) -> KitoNetScenario? {
        scenarios.first { $0.matches(url) }
    }
}
