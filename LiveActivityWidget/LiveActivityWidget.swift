// LiveActivityWidget.swift
import WidgetKit
import SwiftUI
import ActivityKit

struct DemoActivityWidgetBundle: WidgetBundle {
    var body: some Widget {
        DemoActivityWidget()
    }
}

struct DemoActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DemoActivityAttributes.self) { context in
            // Lock Screen UI
            VStack {
                if context.state.endTime > Date() {
                    Text("Live Activity Running")
                    Text("Ends at \(context.state.endTime.formatted(date: .omitted, time: .standard))")
                } else {
                    Text("Live Activity Ended")
                }
            }
            .padding()
            
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    if context.state.endTime > Date() {
                        Text("Running until \(context.state.endTime.formatted(date: .omitted, time: .shortened))")
                    } else {
                        Text("Ended")
                    }
                }
            } compactLeading: {
                Text("⏱")
            } compactTrailing: {
                Text(context.state.endTime > Date() ? "On" : "Off")
            } minimal: {
                Text("⏱")
            }
        }
    }
}
