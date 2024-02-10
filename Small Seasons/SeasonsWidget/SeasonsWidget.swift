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
    let title: String
    let description: String
    let startDate: String
}

struct SeasonsData: Decodable {
    let sekki: [Sekki]
}

enum WidgetSize {
    case small, medium, large
}

func loadAllSeasonData() -> ([Sekki]) {
    guard let url = Bundle.main.url(forResource: "content", withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let seasonsData = try? JSONDecoder().decode(SeasonsData.self, from: data) else {
        return []
    }
    return seasonsData.sekki
}

func loadSeasonData(for size: WidgetSize) -> (id: String, kanji: String, notes: String?, description: String?, title: String?) {
    guard let url = Bundle.main.url(forResource: "content", withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let seasonsData = try? JSONDecoder().decode(SeasonsData.self, from: data) else {
        return ("", "", nil, nil, nil)
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
        return ("", "", nil, nil, nil)
    }

    return (season.id, season.kanji, season.notes, season.description, season.title)
}

func textForWidget(widgetSize: WidgetSize) -> String {
    switch widgetSize {
    case .small:
        let smallWidgetData = loadSeasonData(for: .large)
        let smallWidgetText = """
        \(smallWidgetData.kanji)
        \(smallWidgetData.id) \n\
        \(smallWidgetData.title ?? "")
        """
        return smallWidgetText
    case .medium:
        let mediumWidgetData = loadSeasonData(for: .large)
        let mediumWidgetText = """
        \(mediumWidgetData.kanji) \n\
        \(mediumWidgetData.id) \n\
        \(mediumWidgetData.notes ?? "")
        """
        return mediumWidgetText
    case .large:
        let largeWidgetData = loadSeasonData(for: .large)
        let largeWidgetText = """
        \(largeWidgetData.kanji) \n\
        \(largeWidgetData.id) \n\
        \(largeWidgetData.title ?? "") \n\
        \(largeWidgetData.description ?? "")
        """
        return largeWidgetText
    }
}

struct SmallSeasonsWidgetEntryView: View {
    var entry: SimpleEntry

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
                            .lineSpacing(6)
                            .padding(.top, 6)
                    }

                case .systemMedium:
                    let sekki = loadSeasonData(for: .medium)
                        
                    VStack {
                        Text(sekki.kanji)
                            .font(.system(.title2, design: .serif))
                            .italic()
                            .lineSpacing(4)
                            .padding(4)
                        
                        Text(sekki.id)
                            .font(.system(.body, design: .serif))
                            .italic()
                            .lineSpacing(4)
                            .padding(4)
                        
                        Text(sekki.notes ?? "")
                            .font(.system(.body, design: .serif))
                            .italic()
                            .lineSpacing(4)
                            .padding(6)
                    }
                    .foregroundColor(Color(white: 0.2))
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
                    .padding(.bottom, 2)

                case .systemLarge:
                    let sekki = loadSeasonData(for: .large)
                        
                    VStack {
                        Text(sekki.kanji)
                            .font(.system(.title2, design: .serif))
                            .italic()
                            .lineSpacing(4)
                            .padding(4)
                        
                        Text(sekki.id)
                            .font(.system(.body, design: .serif))
                            .italic()
                            .lineSpacing(4)
                            .padding(4)
                        
                        Text(sekki.title ?? "")
                            .font(.system(.body, design: .serif))
                            .italic()
                            .lineSpacing(4)
                            .padding(6)
                        
                        Text(sekki.description ?? "")
                            .font(.system(.body, design: .serif))
                            .italic()
                            .lineSpacing(4)
                    }
                    .foregroundColor(Color(white: 0.2))
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .padding(.bottom, 6)

                default:
                    let smallWidgetText = textForWidget(widgetSize: .small)

                    VStack {
                        Text(smallWidgetText)
                            .font(.system(.body, design: .serif).italic())
                            .foregroundColor(Color(white: 0.2))
                            .multilineTextAlignment(.center)
                            .padding(.top, 6)
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
        SimpleEntry(date: Date(), sekki: loadCurrentSekki())
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
        let currentSekkiData = loadSeasonData(for: .large)  // Choose size based on your widget design
        return Sekki(id: currentSekkiData.id, kanji: currentSekkiData.kanji, notes: currentSekkiData.notes ?? "", title: currentSekkiData.title ?? "", description: currentSekkiData.description ?? "", startDate: "")
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let sekki: Sekki
}
