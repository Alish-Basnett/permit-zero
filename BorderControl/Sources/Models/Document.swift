import Foundation

struct Passport: Identifiable {
    let id = UUID()
    var name: String
    var nationality: String
    var sex: String
    var dateOfBirth: GameDate
    var expirationDate: GameDate
    var issuingCity: String
    var passportNumber: String
}

struct EntryPermit: Identifiable {
    let id = UUID()
    var name: String
    var passportNumber: String
    var purpose: String
    var expirationDate: GameDate
}

struct IDCard: Identifiable {
    let id = UUID()
    var name: String
    var dateOfBirth: GameDate
    var heightCm: Int
    var weightKg: Int
    var nationality: String
}

/// A simplified physical-description bulletin posted at the booth.
struct WantedPoster: Identifiable {
    let id = UUID()
    var descriptionText: String
    var nationality: String
    var sexHint: String
    var heightRangeCm: ClosedRange<Int>
}

/// A simple in-game calendar date; deliberately not tied to the real calendar
/// so day-lengths and "today" can be whatever the ruleset needs.
struct GameDate: Equatable, Comparable {
    var year: Int
    var month: Int
    var day: Int

    static func < (lhs: GameDate, rhs: GameDate) -> Bool {
        (lhs.year, lhs.month, lhs.day) < (rhs.year, rhs.month, rhs.day)
    }

    var formatted: String {
        String(format: "%02d.%02d.%d", day, month, year)
    }
}
