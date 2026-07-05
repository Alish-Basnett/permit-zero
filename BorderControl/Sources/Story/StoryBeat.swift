import Foundation

struct StoryChoiceEffect {
    var moneyDelta: Int = 0
    var suspicionDelta: Int = 0
    var familyHealthDelta: Int = 0
}

struct StoryChoice: Identifiable {
    let id = UUID()
    var text: String
    var effect: StoryChoiceEffect
}

struct StoryBeat: Identifiable {
    let id = UUID()
    var speaker: String
    var lines: [String]
    var choices: [StoryChoice]
}
