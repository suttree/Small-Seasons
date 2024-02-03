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
                NavigationLink(destination: WelcomeView()) {
                    Text("About")
                }
                
                NavigationLink(destination: InstructionsView()) {
                    Text("Installation")
                }
                
                Section(header: Text("All Seasons")
                        .font(.headline)
                        .padding(.top, 18)) {
                }
                .listStyle(GroupedListStyle())
            
                ForEach(allSeasons, id: \.id) { sekki in
                    Section(header: Text("\(sekki.kanji)" + (sekki.id == seasonData.id ? " — NOW" : ""))) {
                        SeasonCardView(seasonData: (id: sekki.id,
                                                    kanji: sekki.kanji,
                                                    notes: sekki.notes,
                                                    title: sekki.title,
                                                    description: sekki.description))
                    }
                    .listStyle(InsetGroupedListStyle())
                }

                Section {
                    Link(destination: URL(string: "https://smallseasons.guide")!) {
                        Text("https://smallseasons.guide")
                            .frame(maxWidth: .infinity, alignment: .center)
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
    
    struct WelcomeView: View {
        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Welcome to Small Seasons")
                        .font(.title)
                    
                    Text("In agricultural days, staying in-tune with the seasons was important. When should we plant seeds? When should we harvest? When will the rains come? Are they late this year? Knowing what was happening with nature was the difference between a plentiful harvest and a barren crop.")
                        .padding()
                    
                    Text("Prior to the Gregorian calendar, farmers in China and Japan broke each year down into 24 sekki or “small seasons.” These seasons didn't use dates to mark seasons, but instead, they divided up the year by natural phenomena.")
                        .padding()
                }
                .padding()
                .navigationBarTitle("About", displayMode: .inline)
            }
        }
    }

    struct InstructionsView: View {
        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Installation")
                        .font(.title)
                    
                    Text("To add Small Seasons to your home screen, press and hold on the screen until the apps enter editing mode, tap the plus icon, select 'Small Seasons' from the widget gallery, choose the desired size, and tap 'Add Widget'. Position it as preferred and press 'Done' to complete the setup.")
                        .padding()
                }
                .padding()
                .navigationBarTitle("Instructions", displayMode: .inline)
            }
        }
    }
}

// Custom card view for sekki
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
        .padding(18)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
