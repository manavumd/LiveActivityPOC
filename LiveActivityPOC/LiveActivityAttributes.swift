//
//  LiveActivityAttributes.swift
//  LiveActivityPOC
//
//  Created by Manav Gupta on 20/09/25.
//

// LiveActivityAttributes.swift
import ActivityKit
import Foundation

struct DemoActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var endTime: Date
    }
}
