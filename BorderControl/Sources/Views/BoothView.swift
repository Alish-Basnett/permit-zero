import SwiftUI

struct BoothView: View {
    @EnvironmentObject var game: GameState
    @State private var showRuleBook = false

    var body: some View {
        VStack(spacing: 0) {
            header

            if let applicant = game.currentApplicant {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("\"\(applicant.line).\"")
                            .italic()
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)

                        DocumentCardView(applicant: applicant)
                            .padding(.horizontal)

                        if let correct = game.lastVerdictWasCorrect {
                            Text(game.lastExplanation)
                                .font(.subheadline)
                                .bold()
                                .foregroundStyle(correct ? .green : .red)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            } else {
                Spacer()
                Text("No traveler at the window.")
                Spacer()
            }

            stampBar
        }
        .sheet(isPresented: $showRuleBook) {
            RuleBookView(rules: game.rules)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showRuleBook = true
                } label: {
                    Label("Rulebook", systemImage: "book.closed")
                }
            }
        }
    }

    private var header: some View {
        HStack {
            Label("\(game.money)", systemImage: "banknote")
            Spacer()
            Text("Day \(game.day)")
                .bold()
            Spacer()
            Label("\(game.applicantsProcessedToday)/\(game.rules.quota)", systemImage: "person.2")
            Spacer()
            Label("\(game.strikes)/\(game.maxStrikes)", systemImage: "exclamationmark.triangle")
                .foregroundStyle(game.strikes > 0 ? .orange : .secondary)
        }
        .font(.footnote)
        .padding()
        .background(.thinMaterial)
    }

    private var stampBar: some View {
        HStack(spacing: 20) {
            if game.lastVerdictWasCorrect != nil {
                Button {
                    game.nextApplicant()
                } label: {
                    stampLabel("NEXT TRAVELER", color: .blue)
                }
            } else {
                Button {
                    game.submitVerdict(approved: false)
                } label: {
                    stampLabel("DENY", color: .red)
                }

                Button {
                    game.submitVerdict(approved: true)
                } label: {
                    stampLabel("APPROVE", color: .green)
                }
            }
        }
        .padding()
        .background(.thinMaterial)
    }

    private func stampLabel(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(color, lineWidth: 2))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
