//
//  ContentView.swift
//  LiveActivityPOC
//
//  Created by Manav Gupta on 20/09/25.
//

import SwiftUI

// ContentView.swift
import SwiftUI
import ActivityKit

struct ContentView: View {
    @State private var activity: Activity<DemoActivityAttributes>? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Start Live Activity") {
                startLiveActivity()
            }
            .buttonStyle(.borderedProminent)
            
            Button("Stop Manually") {
                stopLiveActivity()
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
    
    private func startLiveActivity() {
        let endTime = Date().addingTimeInterval(120) // 30s for demo
        let initialState = DemoActivityAttributes.ContentState(endTime: endTime)
        let attributes = DemoActivityAttributes()
        
        do {
            let activity = try Activity<DemoActivityAttributes>.request(
                attributes: attributes,
                content: ActivityContent(state: initialState, staleDate: endTime),
                pushType: nil
            )
            
            self.activity = activity
            print("👉 Live Activity started at \(Date())")
            
            // ✅ Request background time so we can finish even if app goes to background
            var bgTaskID: UIBackgroundTaskIdentifier = .invalid
            bgTaskID = UIApplication.shared.beginBackgroundTask(withName: "EndLiveActivity") {
                // Expiration handler (called if system ends us early)
                UIApplication.shared.endBackgroundTask(bgTaskID)
                bgTaskID = .invalid
            }
            
            // Schedule auto-end
            Task {
                try? await Task.sleep(nanoseconds: 125 * 1_000_000_000) // wait ~35s
                let now = Date()
                let finalState = DemoActivityAttributes.ContentState(endTime: now)
                
                await activity.end(
                    ActivityContent(state: finalState, staleDate: now),
                    dismissalPolicy: .after(now.addingTimeInterval(5))
                )
                print("👉 Live Activity auto-ended at \(now)")
                
                // ✅ End background task
                UIApplication.shared.endBackgroundTask(bgTaskID)
                bgTaskID = .invalid
            }
            
        } catch {
            print("Error starting activity: \(error.localizedDescription)")
        }
    }
    
    private func stopLiveActivity() {
        Task {
            if let activity = activity {
                let now = Date()
                let finalState = DemoActivityAttributes.ContentState(endTime: now)
                
                await activity.end(
                    ActivityContent(state: finalState, staleDate: now),
                    dismissalPolicy: .immediate
                )
                
                print("Live Activity manually stopped at \(now)")
            } else {
                print("No active Live Activity to stop")
            }
        }
    }

}
