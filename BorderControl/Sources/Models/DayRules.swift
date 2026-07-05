import Foundation

/// The rulebook in effect for a given day. This is what the player can
/// consult mid-inspection, and what the RuleEngine checks applicants against.
struct DayRules {
    var day: Int
    var today: GameDate
    var quota: Int
    var rentDue: Int

    var bannedNationalities: [String]
    var requireEntryPermit: Bool
    var requireIDCard: Bool
    var checkNameMatch: Bool
    var wantedPosters: [WantedPoster]
}
