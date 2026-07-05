import Foundation

enum DaysData {
    static let totalDays = 5

    static func rules(forDay day: Int) -> DayRules {
        let today = GameDate(year: 1982, month: 3, day: day)

        switch day {
        case 1:
            return DayRules(
                day: day, today: today, quota: 6, rentDue: 20,
                bannedNationalities: [],
                requireEntryPermit: false,
                requireIDCard: false,
                checkNameMatch: false,
                wantedPosters: []
            )
        case 2:
            return DayRules(
                day: day, today: today, quota: 8, rentDue: 25,
                bannedNationalities: [],
                requireEntryPermit: true,
                requireIDCard: false,
                checkNameMatch: true,
                wantedPosters: []
            )
        case 3:
            return DayRules(
                day: day, today: today, quota: 8, rentDue: 25,
                bannedNationalities: ["Kolechia"],
                requireEntryPermit: true,
                requireIDCard: false,
                checkNameMatch: true,
                wantedPosters: []
            )
        case 4:
            return DayRules(
                day: day, today: today, quota: 10, rentDue: 30,
                bannedNationalities: ["Kolechia"],
                requireEntryPermit: true,
                requireIDCard: true,
                checkNameMatch: true,
                wantedPosters: []
            )
        default:
            return DayRules(
                day: day, today: today, quota: 10, rentDue: 30,
                bannedNationalities: ["Kolechia"],
                requireEntryPermit: true,
                requireIDCard: true,
                checkNameMatch: true,
                wantedPosters: [
                    WantedPoster(descriptionText: "Wanted for smuggling. Approach with caution.",
                                 nationality: "Antegria", sexHint: "M", heightRangeCm: 178...188)
                ]
            )
        }
    }
}
