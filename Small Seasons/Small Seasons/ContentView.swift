import WidgetKit
import SwiftUI

struct ContentView: View {
    @State private var seasonData: (id: String, kanji: String, notes: String?, description: String?) = ("", "", nil, nil)

    // Load season data when the view appears
    private func loadSeason() {
        seasonData = loadSeasonData(for: .large)  // Choose the appropriate size
    }

    var body: some View {
        NavigationView {
            List {
                Section {
                    if !seasonData.kanji.isEmpty {
                        SeasonCardView(seasonData: seasonData)
                    }
                }
            }
            .navigationBarTitle("Small Seasons", displayMode: .inline)
            .onAppear {
                loadSeason()
            }
        }
    }
}

// Custom card view for the season data
struct SeasonCardView: View {
    var seasonData: (id: String, kanji: String, notes: String?, description: String?)
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(seasonData.id)
                .font(.headline)
                .foregroundColor(.primary) // Adapts to light/dark mode
            Text(seasonData.kanji)
                .foregroundColor(.primary) // Adapts to light/dark mode
            if let description = seasonData.description {
                Text(description)
                    .foregroundColor(.primary) // Adapts to light/dark mode
            }
            Link(destination: URL(string: "https://smallseasons.guide")!) {
                Text("https://smallseasons.guide")
                    .foregroundColor(.primary) // Adapts to light/dark mode
                    .underline()
            }
        }
        .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
        .cornerRadius(10)
        .listRowInsets(EdgeInsets())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
