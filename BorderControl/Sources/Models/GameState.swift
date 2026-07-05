import Foundation
import SwiftUI

enum GamePhase {
    case mainMenu
    case story
    case booth
    case dayEnd
    case gameOver(reason: String)
    case victory
}

@MainActor
final class GameState: ObservableObject {
    @Published var phase: GamePhase = .mainMenu

    @Published var day: Int = 1
    @Published var money: Int = 0
    @Published var strikes: Int = 0
    @Published var suspicion: Int = 0 // rises with bribes/corruption choices
    @Published var familyHealth: Int = 100 // falls if rent/food can't be paid

    @Published var applicantsProcessedToday: Int = 0
    @Published var mistakesToday: Int = 0
    @Published var moneyAtStartOfDay: Int = 0
    @Published var currentApplicant: Applicant?
    @Published var lastVerdictWasCorrect: Bool?
    @Published var lastExplanation: String = ""

    var rules: DayRules = DaysData.rules(forDay: 1)

    let maxStrikes = 6
    let payPerCorrectApplicant = 5
    let penaltyPerMistake = 4

    var moneyEarnedToday: Int { money - moneyAtStartOfDay }

    func startNewGame() {
        day = 1
        money = 0
        strikes = 0
        suspicion = 0
        familyHealth = 100
        beginDay()
    }

    func beginDay() {
        rules = DaysData.rules(forDay: day)
        applicantsProcessedToday = 0
        mistakesToday = 0
        moneyAtStartOfDay = money
        currentApplicant = nil
        lastVerdictWasCorrect = nil
        phase = .story
    }

    func enterBooth() {
        phase = .booth
        nextApplicant()
    }

    func nextApplicant() {
        if applicantsProcessedToday >= rules.quota {
            phase = .dayEnd
            return
        }
        currentApplicant = ApplicantGenerator.generate(for: rules)
        lastVerdictWasCorrect = nil
    }

    /// Player taps Approve or Deny; `approved` is what they chose.
    func submitVerdict(approved: Bool) {
        guard let applicant = currentApplicant else { return }
        let violation = RuleEngine.evaluate(applicant, against: rules)
        let shouldApprove = (violation == .none)
        let correct = (approved == shouldApprove)

        lastVerdictWasCorrect = correct
        lastExplanation = correct ? "Correct." : "Incorrect — \(violation.explanation)"

        if correct {
            money += payPerCorrectApplicant
        } else {
            mistakesToday += 1
            strikes += 1
            money = max(0, money - penaltyPerMistake)
        }

        applicantsProcessedToday += 1

        if strikes >= maxStrikes {
            phase = .gameOver(reason: "You were dismissed after too many processing errors.")
        }
    }

    func finishDayEndPayRent() {
        if money >= rules.rentDue {
            money -= rules.rentDue
        } else {
            familyHealth -= 25
            money = 0
        }

        if familyHealth <= 0 {
            phase = .gameOver(reason: "Your family could not make it through the winter.")
            return
        }

        if day >= DaysData.totalDays {
            phase = .victory
            return
        }

        day += 1
        beginDay()
    }

    func applyStoryChoice(_ effect: StoryChoiceEffect) {
        money += effect.moneyDelta
        suspicion += effect.suspicionDelta
        familyHealth += effect.familyHealthDelta
        familyHealth = min(100, familyHealth)
    }
}
