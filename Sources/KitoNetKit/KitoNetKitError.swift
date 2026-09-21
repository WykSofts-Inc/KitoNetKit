//
//  KitoNetKitError.swift
//  KitoNetKit
//
//  Created by Wycliff on 9/19/26.
//  Copyright © 2026 wyksoftsinc.com. All rights reserved.
//

import Foundation

public enum KitoNetKitError: Error, LocalizedError {
    case invalidForcedResponse(statusCode: Int)

    public var errorDescription: String? {
        switch self {
        case .invalidForcedResponse(let statusCode):
            return "KitoNetScenario.forcedResponse used an invalid HTTP status code (\(statusCode))."
        }
    }
}
