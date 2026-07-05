import Foundation

/// Everything one person hands you at the window, plus the "ground truth"
/// about whether they should be let through.
struct Applicant: Identifiable {
    let id = UUID()
    var passport: Passport
    var entryPermit: EntryPermit?
    var idCard: IDCard?
    var isWanted: Bool
    var line: String
}

enum Violation: Equatable {
    case expiredPassport
    case expiredEntryPermit
    case missingEntryPermit
    case missingIDCard
    case nameMismatch
    case bannedNationality
    case matchesWantedDescription
    case none

    var explanation: String {
        switch self {
        case .expiredPassport: return "Passport is expired."
        case .expiredEntryPermit: return "Entry permit is expired."
        case .missingEntryPermit: return "Entry permit is required but missing."
        case .missingIDCard: return "ID card is required but missing."
        case .nameMismatch: return "Names do not match across documents."
        case .bannedNationality: return "Nationality is not permitted entry today."
        case .matchesWantedDescription: return "Matches a wanted bulletin description."
        case .none: return "No issues found."
        }
    }
}
