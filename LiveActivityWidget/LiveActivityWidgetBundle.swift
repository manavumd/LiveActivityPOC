//
//  LiveActivityWidgetBundle.swift
//  LiveActivityWidget
//
//  Created by Manav Gupta on 20/09/25.
//

import WidgetKit
import SwiftUI

@main
struct LiveActivityWidgetBundle: WidgetBundle {
    var body: some Widget {
        DemoActivityWidget()
        LiveActivityWidgetControl()
        LiveActivityWidgetLiveActivity()
    }
}
