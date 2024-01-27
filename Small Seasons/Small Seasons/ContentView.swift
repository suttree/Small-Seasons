import WidgetKit
import SwiftUI

struct ContentView: View {
    @State private var seasonData: (id: String, kanji: String, notes: String?, description: String?, title: String?) = ("", "", nil, nil, nil)
    @State private var allSeasons: [Sekki] = []

    private func loadSeason() {
        seasonData = loadSeasonData(for: .large)
    }

    private func loadAllSeasons() {
        allSeasons = loadAllSeasonData()
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(allSeasons, id: \.id) { sekki in
                        SeasonCardView(seasonData: (id: sekki.id,
                                                    kanji: sekki.kanji,
                                                    notes: sekki.notes,
                                                    title: sekki.title,
                                                    description: sekki.description))
                            .cornerRadius(6)
                            .border(sekki.id == seasonData.id ? Color.yellow : Color.clear, width: 2)
                    }
                }

                Section {
                    Link(destination: URL(string: "https://smallseasons.guide")!) {
                        Text("https://smallseasons.guide")
                            .frame(maxWidth: .infinity, alignment: .center) // Center-align the text
                            .foregroundColor(.primary)
                            .underline()
                    }
                }
                .listRowInsets(EdgeInsets())
            }
            .navigationBarTitle("Small Seasons", displayMode: .inline)
            .onAppear {
                loadSeason()
                loadAllSeasons()
            }
        }
    }
}

// Custom card view for the season data
struct SeasonCardView: View {
    var seasonData: (id: String, kanji: String, notes: String?, title: String?, description: String?)
    
    var body: some View {
        VStack() {
            Text(seasonData.id)
                .font(.headline)
                .foregroundColor(.primary)
            Text(seasonData.kanji)
                .foregroundColor(.primary)
            if let description = seasonData.description {
                Text(description)
                    .foregroundColor(.primary)
            }
        }
        .padding(28)
        .cornerRadius(6)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
