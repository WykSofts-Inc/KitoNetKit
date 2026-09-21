//
//  KitoNetConsole.swift
//  KitoNetKit
//
//  Created by Wycliff on 9/19/26.
//  Copyright © 2026 wyksoftsinc.com. All rights reserved.
//

import SwiftUI
import KitoCore

/// A themed debug screen listing active scenarios, so QA can toggle network
/// conditions without touching code. Wire it behind a shake gesture or a
/// debug-menu button — never ship it reachable from a release build.
public struct KitoNetConsole: View {
    @Environment(\.kitoTheme) private var theme
    @State private var scenarios: [KitoNetScenario] = KitoNetKit.scenarios

    public init() {}

    public var body: some View {
        List {
            if scenarios.isEmpty {
                Text("No active scenarios")
                    .font(theme.typography.body)
                    .foregroundStyle(theme.colors.onBackground.opacity(0.5))
            }
            ForEach(scenarios) { scenario in
                VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                    Text(scenario.urlPattern).font(theme.typography.bodyEmphasized)
                    Text(describe(scenario.condition))
                        .font(theme.typography.caption)
                        .foregroundStyle(theme.colors.onBackground.opacity(0.6))
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    KitoNetKit.removeScenario(urlPattern: scenarios[index].urlPattern)
                }
                scenarios = KitoNetKit.scenarios
            }

            if !scenarios.isEmpty {
                Button("Clear all", role: .destructive) {
                    KitoNetKit.clearAll()
                    scenarios = []
                }
            }
        }
        .navigationTitle("Network Console")
        .onAppear { scenarios = KitoNetKit.scenarios }
    }

    private func describe(_ condition: KitoNetScenario.Condition) -> String {
        switch condition {
        case .offline: return "Offline"
        case .latency(let seconds): return "Latency: \(seconds)s"
        case .timeout: return "Timeout"
        case .forcedResponse(let code, _): return "Forced response: \(code)"
        }
    }
}
