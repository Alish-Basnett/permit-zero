import Foundation

enum ApplicantGenerator {
    private static let firstNames = [
        "Jorji", "Mikhail", "Yuri", "Vera", "Olga", "Dmitri", "Katarzyna", "Ivan",
        "Nadia", "Stepan", "Anya", "Boris", "Elena", "Pavel", "Zofia", "Marek"
    ]
    private static let lastNames = [
        "Kostov", "Vishinsky", "Lukashenko", "Petrov", "Kowalski", "Novak",
        "Antonov", "Sokolov", "Halvard", "Brezhnev", "Rodin", "Yevchenko"
    ]
    private static let nationalities = ["Arstotzka", "Antegria", "Kolechia", "Republia", "Obristan"]
    private static let cities = ["Grennsford", "Yurko City", "Paradizna", "West Grestin", "Skal"]
    private static let purposes = ["Tourism", "Work", "Visiting Family", "Transit"]

    static func generate(for rules: DayRules) -> Applicant {
        let name = "\(firstNames.randomElement()!) \(lastNames.randomElement()!)"
        let nationality = nationalities.randomElement()!
        let sex = Bool.random() ? "M" : "F"
        let dob = GameDate(year: Int.random(in: 1930...1965), month: Int.random(in: 1...12), day: Int.random(in: 1...28))

        var violation: Violation = .none
        // ~45% of travelers have a problem; pick only from violations this
        // day's rules can actually surface, so the puzzle is always solvable.
        var possible: [Violation] = [.expiredPassport]
        if rules.requireEntryPermit { possible.append(.missingEntryPermit); possible.append(.expiredEntryPermit) }
        if rules.checkNameMatch { possible.append(.nameMismatch) }
        if !rules.bannedNationalities.isEmpty { possible.append(.bannedNationality) }
        if rules.requireIDCard { possible.append(.missingIDCard) }
        if !rules.wantedPosters.isEmpty { possible.append(.matchesWantedDescription) }

        if Int.random(in: 0..<100) < 45 {
            violation = possible.randomElement() ?? .none
        }

        let futureExpiry = GameDate(year: rules.today.year + Int.random(in: 1...3), month: rules.today.month, day: rules.today.day)
        let pastExpiry = GameDate(year: rules.today.year - 1, month: rules.today.month, day: max(1, rules.today.day - 1))

        var passportNationality = nationality
        if violation == .bannedNationality, let banned = rules.bannedNationalities.randomElement() {
            passportNationality = banned
        }

        let passport = Passport(
            name: name,
            nationality: passportNationality,
            sex: sex,
            dateOfBirth: dob,
            expirationDate: violation == .expiredPassport ? pastExpiry : futureExpiry,
            issuingCity: cities.randomElement()!,
            passportNumber: randomDocNumber()
        )

        var entryPermit: EntryPermit?
        if rules.requireEntryPermit {
            if violation == .missingEntryPermit {
                entryPermit = nil
            } else {
                let permitName = violation == .nameMismatch ? mutateName(name) : name
                entryPermit = EntryPermit(
                    name: permitName,
                    passportNumber: passport.passportNumber,
                    purpose: purposes.randomElement()!,
                    expirationDate: violation == .expiredEntryPermit ? pastExpiry : futureExpiry
                )
            }
        }

        var idCard: IDCard?
        if rules.requireIDCard {
            if violation == .missingIDCard {
                idCard = nil
            } else {
                idCard = IDCard(
                    name: name,
                    dateOfBirth: dob,
                    heightCm: Int.random(in: 155...195),
                    weightKg: Int.random(in: 50...100),
                    nationality: passportNationality
                )
            }
        }

        let isWanted = violation == .matchesWantedDescription

        return Applicant(
            passport: passport,
            entryPermit: entryPermit,
            idCard: idCard,
            isWanted: isWanted,
            line: purposes.randomElement()!
        )
    }

    private static func mutateName(_ name: String) -> String {
        let parts = name.split(separator: " ")
        guard parts.count == 2 else { return name + "e" }
        return "\(parts[0]) \(lastNames.filter { $0 != String(parts[1]) }.randomElement() ?? String(parts[1]) + "v")"
    }

    private static func randomDocNumber() -> String {
        String((0..<8).map { _ in "0123456789".randomElement()! })
    }
}
