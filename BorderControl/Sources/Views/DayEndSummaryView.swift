import SwiftUI

struct DayEndSummaryView: View {
    @EnvironmentObject var game: GameState

    private var willMakeRent: Bool { game.money >= game.rules.rentDue }

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("Day \(game.day) Complete")
                .font(.largeTitle).bold()

            VStack(alignment: .leading, spacing: 10) {
                summaryRow("Travelers processed", "\(game.applicantsProcessedToday)")
                summaryRow("Mistakes", "\(game.mistakesToday)")
                summaryRow("Money earned today", "\(game.moneyEarnedToday)")
                Divider()
                summaryRow("Total money", "\(game.money)")
                summaryRow("Rent due", "\(game.rules.rentDue)")
                Text(willMakeRent ? "You can cover rent." : "You cannot cover rent — your family will suffer.")
                    .font(.caption)
                    .foregroundStyle(willMakeRent ? .green : .red)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
            .padding(.horizontal)

            Spacer()

            Button(game.day >= DaysData.totalDays ? "Finish" : "Pay Rent & Continue") {
                game.finishDayEndPayRent()
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
    }

    private func summaryRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value).bold()
        }
    }
}
