//
//  SeasonsWidget.swift
//  SeasonsWidget
//
//  Created by Duncan Gough on 27/01/2024.
//
import Foundation
import WidgetKit
import SwiftUI

struct Sekki: Decodable {
    let id: String
    let kanji: String
    let notes: String
    let description: String
    let startDate: String
}

struct SeasonsData: Decodable {
    let sekki: [Sekki]
}

enum WidgetSize {
    case small, medium, large
}

func loadSeasonData(for size: WidgetSize) -> (id: String, kanji: String, notes: String?, description: String?) {
    guard let url = Bundle.main.url(forResource: "content", withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let seasonsData = try? JSONDecoder().decode(SeasonsData.self, from: data) else {
        return ("", "", nil, nil)
    }

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let currentYear = Calendar.current.component(.year, from: Date())
    let today = Date()  // Use current date

    var mostRecentSeason: Sekki? = nil
    for season in seasonsData.sekki {
        guard let seasonStartDateThisYear = formatter.date(from: "\(currentYear)-\(season.startDate)") else {
            continue
        }

        if seasonStartDateThisYear <= today {
            mostRecentSeason = season
            if formatter.string(from: seasonStartDateThisYear) == formatter.string(from: today) {
                break
            }
        }
    }

    if mostRecentSeason == nil {
        mostRecentSeason = seasonsData.sekki.last
    }

    guard let season = mostRecentSeason else {
        return ("", "", nil, nil)
    }

    switch size {
    case .small:
        return (season.id, season.kanji, nil, nil)
    case .medium:
        return (season.id, season.kanji, season.notes, nil)
    case .large:
        return (season.id, season.kanji, season.notes, season.description)
    }
}

func textForWidget(widgetSize: WidgetSize) -> String {
    switch widgetSize {
    case .small:
        let smallWidgetData = loadSeasonData(for: .small)
        return smallWidgetData.id
    case .medium:
        let mediumWidgetData = loadSeasonData(for: .medium)
        let mediumWidgetText = """
        \(mediumWidgetData.id) \n\
        \(mediumWidgetData.notes ?? "")
        """
        return mediumWidgetText
    case .large:
        let largeWidgetData = loadSeasonData(for: .large)
        let largeWidgetText = """
        \(largeWidgetData.kanji) \n\
        \(largeWidgetData.id) \n\
        \(largeWidgetData.notes ?? "")
        """
        return largeWidgetText
    }
}

struct SmallSeasonsWidgetEntryView: View {
    var entry: SimpleEntry

    // This environment variable tells us what size the widget is
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
            Group {
                switch widgetFamily {
                case .systemSmall:
                    let smallWidgetText = textForWidget(widgetSize: .small)

                    VStack {
                        Text(smallWidgetText)
                            .font(.system(.body, design: .serif).italic())
                            .foregroundColor(Color(white: 0.2))
                            .multilineTextAlignment(.center)
                            .padding(.top, 5)
                    }

                case .systemMedium:
                    let mediumWidgetText = textForWidget(widgetSize: .medium)
                    
                    Text(mediumWidgetText)
                        .font(.system(.body, design: .serif).italic())
                        .foregroundColor(Color(white: 0.2))
                        .padding(.top, 5)

                case .systemLarge:
                    let largeWidgetText = textForWidget(widgetSize: .large)
                    
                    Text(largeWidgetText)
                        .font(.system(.body, design: .serif).italic())
                        .foregroundColor(Color(white: 0.2))
                        .padding(.top, 5)

                default:
                    let smallWidgetText = textForWidget(widgetSize: .small)

                    VStack {
                        Text(smallWidgetText)
                            .font(.system(.body, design: .serif).italic())
                            .foregroundColor(Color(white: 0.2))
                            .multilineTextAlignment(.center)
                            .padding(.top, 5)
                    }
                }
            }
        .containerBackground(for: .widget) {
            Color(white: 0.95)
        }
    }
}

struct SmallSeasonsProvider: TimelineProvider {
    typealias Entry = SimpleEntry
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), sekki: Sekki(id: "Loading", kanji: "", notes: "", description: "", startDate: ""))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), sekki: loadCurrentSekki())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let nextUpdateDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        let entry = SimpleEntry(date: currentDate, sekki: loadCurrentSekki())

        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        completion(timeline)
    }

    private func loadCurrentSekki() -> Sekki {
        // Assuming loadSeasonData already returns the current Sekki based on today's date.
        let currentSekkiData = loadSeasonData(for: .large)  // Choose size based on your widget design
        return Sekki(id: currentSekkiData.id, kanji: currentSekkiData.kanji, notes: currentSekkiData.notes ?? "", description: currentSekkiData.description ?? "", startDate: "")
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let sekki: Sekki
}

/*
struct SeasonsWidgetEntryView : View {
    var entry: SimpleEntry

    var body: some View {
        Text(entry.sekki.kanji)
        // Add more UI elements as needed based on your design
    }
}
 
@main
struct SeasonsWidget: Widget {
    let kind: String = "SeasonsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SeasonsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Small Seasons")
        .description("Shows the current season based on traditional Japanese calendar.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
*/