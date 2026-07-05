import Foundation

/// A small, self-contained narrative: you're an inspector at the Grennsford
/// border checkpoint, trying to keep your family fed while the state keeps
/// adding rules. Nothing branches wildly, but a few choices nudge your
/// suspicion and family-health stats.
enum StoryData {
    static func beat(forDay day: Int) -> StoryBeat {
        switch day {
        case 1:
            return StoryBeat(
                speaker: "Ministry Notice",
                lines: [
                    "Congratulations on your appointment to the Grennsford checkpoint.",
                    "Today's rules are simple: check that every passport is valid and unexpired.",
                    "Your family is counting on this wage. Do not make mistakes."
                ],
                choices: []
            )
        case 2:
            return StoryBeat(
                speaker: "Supervisor Halvard",
                lines: [
                    "Good work yesterday. Starting today, travelers also need an Entry Permit.",
                    "Check that the permit hasn't expired and matches the name on the passport."
                ],
                choices: []
            )
        case 3:
            return StoryBeat(
                speaker: "Radio Bulletin",
                lines: [
                    "By order of the Ministry, entry from Kolechia is suspended until further notice.",
                    "Any Kolechian passport must be denied, regardless of other paperwork."
                ],
                choices: [
                    StoryChoice(text: "Post the notice as instructed.", effect: StoryChoiceEffect()),
                    StoryChoice(text: "A stranger offers you money to look the other way on this one. Take it.",
                                effect: StoryChoiceEffect(moneyDelta: 15, suspicionDelta: 20))
                ]
            )
        case 4:
            return StoryBeat(
                speaker: "Supervisor Halvard",
                lines: [
                    "Rent has gone up again. Effective today, an ID Card is required alongside the passport.",
                    "Make sure the name on the ID matches the passport exactly."
                ],
                choices: [
                    StoryChoice(text: "\"Understood, sir.\"", effect: StoryChoiceEffect()),
                    StoryChoice(text: "\"This is getting harder to keep up with.\"",
                                effect: StoryChoiceEffect(familyHealthDelta: -5))
                ]
            )
        default:
            return StoryBeat(
                speaker: "Ministry Notice",
                lines: [
                    "A wanted bulletin has been posted at your booth.",
                    "Compare each traveler's description against it. Detain — deny entry to — anyone who matches."
                ],
                choices: []
            )
        }
    }
}
