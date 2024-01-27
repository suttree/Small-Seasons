//
//  SeasonsWidgetBundle.swift
//  SeasonsWidget
//
//  Created by Duncan Gough on 27/01/2024.
//

import WidgetKit
import SwiftUI

@main
struct SeasonsWidgetBundle: WidgetBundle {
    var body: some Widget {
        SeasonsWidget()
        //SeasonsWidgetLiveActivity()
    }
}

// Widget and Provider Registration
struct SeasonsWidget: Widget {
    let kind: String = "SmallSeasonsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SmallSeasonsProvider()) { entry in
            SmallSeasonsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Small Seasons")
        .description("Small Seasons")
    }
}


