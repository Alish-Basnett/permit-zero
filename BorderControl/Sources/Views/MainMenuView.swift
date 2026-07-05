import SwiftUI

struct MainMenuView: View {
    @EnvironmentObject var game: GameState

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            VStack(spacing: 8) {
                Image(systemName: "flag.checkered")
                    .font(.system(size: 56))
                Text("GRENNSFORD")
                    .font(.largeTitle).bold()
                Text("Border Checkpoint")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button("Begin Shift") {
                game.startNewGame()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            Spacer()
        }
    }
}

struct EndOfGameView: View {
    @EnvironmentObject var game: GameState
    let title: String
    let message: String
    let isVictory: Bool

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: isVictory ? "checkmark.seal.fill" : "xmark.seal.fill")
                .font(.system(size: 48))
                .foregroundStyle(isVictory ? .green : .red)
            Text(title).font(.title).bold()
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 32)
            Spacer()
            Button("Return to Main Menu") {
                game.phase = .mainMenu
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
    }
}
