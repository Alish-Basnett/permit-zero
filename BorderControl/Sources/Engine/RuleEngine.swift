import Foundation

enum RuleEngine {
    /// Determines the single governing violation for an applicant under the
    /// given day's rules. Order matters only for which explanation is shown
    /// when generation seeds exactly one problem at a time.
    static func evaluate(_ applicant: Applicant, against rules: DayRules) -> Violation {
        if applicant.passport.expirationDate < rules.today {
            return .expiredPassport
        }

        if rules.bannedNationalities.contains(applicant.passport.nationality) {
            return .bannedNationality
        }

        if rules.requireEntryPermit {
            guard let permit = applicant.entryPermit else { return .missingEntryPermit }
            if permit.expirationDate < rules.today { return .expiredEntryPermit }
            if rules.checkNameMatch && permit.name != applicant.passport.name { return .nameMismatch }
        }

        if rules.requireIDCard {
            guard let card = applicant.idCard else { return .missingIDCard }
            if rules.checkNameMatch && card.name != applicant.passport.name { return .nameMismatch }
        }

        if !rules.wantedPosters.isEmpty && applicant.isWanted {
            return .matchesWantedDescription
        }

        return .none
    }
}
