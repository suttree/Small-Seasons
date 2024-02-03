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
                Section(header: Text("Welcome")) {
                    Text("Prior to the Gregorian calendar, farmers in China and Japan broke each year down into 24 sekki or “small seasons.” These seasons didn't use dates to mark seasons, but instead, they divided up the year by natural phenomena.")
                        .padding()
                        .lineSpacing(4)
                }
                
                Section(header: Text("Installation")) {
                    Text("To add Small Seasons to your home screen, press and hold on the screen until the apps enter editing mode, tap the plus icon, select 'Small Seasons' from the widget gallery, choose the desired size, and tap 'Add Widget'. Position it as preferred and press 'Done' to complete the setup.")
                        .padding()
                        .lineSpacing(4)
                }

                ForEach(allSeasons, id: \.id) { sekki in
                    Section(header: Text(sekki.kanji)) {
                        SeasonCardView(seasonData: (id: sekki.id,
                                                    kanji: sekki.kanji,
                                                    notes: sekki.notes,
                                                    title: sekki.title,
                                                    description: sekki.description))
                            .border(sekki.id == seasonData.id ? Color.yellow : Color.clear, width: 1)
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
                .foregroundColor(Color(white: 0.2))
                .lineSpacing(6)
                .multilineTextAlignment(.leading)
            if let description = seasonData.description {
                Text(description)
                    .foregroundColor(.primary)
                    .foregroundColor(Color(white: 0.2))
                    .lineSpacing(4)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(14)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
