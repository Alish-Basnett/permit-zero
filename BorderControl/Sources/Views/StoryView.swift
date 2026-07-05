import SwiftUI

struct StoryView: View {
    @EnvironmentObject var game: GameState
    @State private var beat: StoryBeat
    @State private var lineIndex = 0
    @State private var choiceMade = false

    init() {
        _beat = State(initialValue: StoryData.beat(forDay: 1))
    }

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(alignment: .leading, spacing: 12) {
                Text(beat.speaker)
                    .font(.caption)
                    .bold()
                    .foregroundStyle(.secondary)
                Text(beat.lines[lineIndex])
                    .font(.title3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
            .padding(.horizontal)

            Spacer()

            if lineIndex < beat.lines.count - 1 {
                Button("Continue") { lineIndex += 1 }
                    .buttonStyle(.borderedProminent)
            } else if !beat.choices.isEmpty && !choiceMade {
                VStack(spacing: 10) {
                    ForEach(beat.choices) { choice in
                        Button(choice.text) {
                            game.applyStoryChoice(choice.effect)
                            choiceMade = true
                        }
                        .buttonStyle(.bordered)
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
            } else {
                Button("Begin Inspection") { game.enterBooth() }
                    .buttonStyle(.borderedProminent)
            }

            Spacer()
        }
        .onAppear { beat = StoryData.beat(forDay: game.day) }
        .navigationBarBackButtonHidden(true)
    }
}
