//
//  KitoNetScenario.swift
//  KitoNetKit
//
//  Created by Wycliff on 9/19/26.
//  Copyright © 2026 wyksoftsinc.com. All rights reserved.
//

import Foundation

/// A network condition to simulate for requests matching `urlPattern`. This
/// is debug/QA-only tooling — never linked into a release build; see
/// KitoDevKitDebug's README for the distribution rule.
public struct KitoNetScenario: Identifiable, Sendable {
    public let id: UUID
    public var urlPattern: String
    public var condition: Condition

    public enum Condition: Sendable {
        case offline
        case latency(seconds: Double)
        case timeout
        case forcedResponse(statusCode: Int, body: Data)
    }

    public init(id: UUID = UUID(), urlPattern: String, condition: Condition) {
        self.id = id
        self.urlPattern = urlPattern
        self.condition = condition
    }

    func matches(_ url: URL) -> Bool {
        url.absoluteString.range(of: urlPattern, options: .regularExpression) != nil
    }
}
