//
//  KitoNetURLProtocol.swift
//  KitoNetKit
//
//  Created by Wycliff on 9/19/26.
//  Copyright © 2026 wyksoftsinc.com. All rights reserved.
//

import Foundation

/// Intercepts requests matching a registered `KitoNetScenario` and answers
/// them locally — offline (fails with `URLError.notConnectedToInternet`),
/// delayed, timed out, or with a forced status/body — before they reach the
/// network. Requests with no matching scenario pass straight through to a
/// real `URLSession`, so this is safe to install unconditionally in DEBUG
/// and only bites when a scenario is actually set.
final class KitoNetURLProtocol: URLProtocol {
    private var passthroughTask: URLSessionDataTask?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let url = request.url, let scenario = KitoNetKit.scenario(for: url) else {
            passthrough()
            return
        }

        switch scenario.condition {
        case .offline:
            client?.urlProtocol(self, didFailWithError: URLError(.notConnectedToInternet))

        case .timeout:
            client?.urlProtocol(self, didFailWithError: URLError(.timedOut))

        case .latency(let seconds):
            Task {
                try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
                self.passthrough()
            }

        case .forcedResponse(let statusCode, let body):
            // HTTPURLResponse's initializer is failable (an out-of-range
            // statusCode or malformed httpVersion returns nil) — a caller
            // passing a bad status code must see a clear failure, not crash
            // the host app.
            guard let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: "HTTP/1.1", headerFields: nil) else {
                client?.urlProtocol(self, didFailWithError: KitoNetKitError.invalidForcedResponse(statusCode: statusCode))
                return
            }
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: body)
            client?.urlProtocolDidFinishLoading(self)
        }
    }

    override func stopLoading() {
        passthroughTask?.cancel()
    }

    /// Forwards to a plain `URLSession` so non-scenario traffic (and
    /// post-latency traffic) still reaches the real network.
    private func passthrough() {
        let session = URLSession(configuration: .default)
        passthroughTask = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self else { return }
            if let error {
                self.client?.urlProtocol(self, didFailWithError: error)
            } else if let response {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                if let data { self.client?.urlProtocol(self, didLoad: data) }
                self.client?.urlProtocolDidFinishLoading(self)
            }
        }
        passthroughTask?.resume()
    }
}
