import SwiftUI

struct RuleBookView: View {
    let rules: DayRules

    var body: some View {
        NavigationStack {
            List {
                Section("Requirements") {
                    ruleRow("Passport must not be expired", true)
                    ruleRow("Entry Permit required", rules.requireEntryPermit)
                    ruleRow("ID Card required", rules.requireIDCard)
                    ruleRow("Names must match across documents", rules.checkNameMatch)
                }
                if !rules.bannedNationalities.isEmpty {
                    Section("Banned Nationalities") {
                        ForEach(rules.bannedNationalities, id: \.self) { nation in
                            Label(nation, systemImage: "xmark.octagon.fill").foregroundStyle(.red)
                        }
                    }
                }
                if !rules.wantedPosters.isEmpty {
                    Section("Wanted Bulletins") {
                        ForEach(rules.wantedPosters) { poster in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(poster.descriptionText).font(.subheadline)
                                Text("Nationality: \(poster.nationality), Sex: \(poster.sexHint), Height: \(poster.heightRangeCm.lowerBound)-\(poster.heightRangeCm.upperBound) cm")
                                    .font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                Section {
                    HStack {
                        Text("Today's date")
                        Spacer()
                        Text(rules.today.formatted).bold()
                    }
                }
            }
            .navigationTitle("Rulebook — Day \(rules.day)")
        }
    }

    private func ruleRow(_ text: String, _ active: Bool) -> some View {
        Label(text, systemImage: active ? "checkmark.circle.fill" : "circle")
            .foregroundStyle(active ? .green : .secondary)
    }
}
