import Foundation
import CopyWithChanges

@CopyWithChanges
struct Report {
    let venue: String
    let sponsor: String?
    let drinks: [String]
    let complexStructure: [Date: [(String, Int)]]
    let characters: [String]?
    let budget: Double
}

let r1 = Report(venue: "Grapefruit", sponsor: "Oumaouma", drinks: ["soda", "tea"], complexStructure: [Date(): [("Blunt!", 200)]], characters: [], budget: 12_345_678.9)

let r2 = r1.with(
    characters: ["Jane Doe"]
)

print("r2 \(r2) has a sponsor because it uses the same as r1 \(r1)")

let r3 = r1.with(
    sponsor: nil,
    complexStructure: [:],
    budget: 0
)

print("r3 \(r3) has no sponsor because `nil` was provided")
