import SwiftUI

struct ContentView: View {
    @EnvironmentObject var game: GameState

    var body: some View {
        NavigationStack {
            Group {
                switch game.phase {
                case .mainMenu:
                    MainMenuView()
                case .story:
                    StoryView().id(game.day)
                case .booth:
                    BoothView()
                case .dayEnd:
                    DayEndSummaryView()
                case .gameOver(let reason):
                    EndOfGameView(title: "Dismissed", message: reason, isVictory: false)
                case .victory:
                    EndOfGameView(
                        title: "Contract Complete",
                        message: "You served all \(DaysData.totalDays) days at the Grennsford checkpoint without losing your post.",
                        isVictory: true
                    )
                }
            }
        }
    }
}
