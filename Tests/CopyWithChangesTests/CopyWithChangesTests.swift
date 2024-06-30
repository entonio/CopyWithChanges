import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import CopyWithChanges

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(CopyWithChangesMacros)
import CopyWithChangesMacros

let testMacros: [String: Macro.Type] = [
    "CopyWithChanges": CopyWithChangesMacro.self,
]
#endif

final class CopyWithChangesTests: XCTestCase {
    func testMacro() throws {
        #if canImport(CopyWithChangesMacros)
        assertMacroExpansion(
            """
            @CopyWithChanges
            struct Report {
                let venue: String
                let sponsor: String?
                let drinks: [String]
                let complexStructure: [Date: [(String, Int)]]
                let characters: [String]?
                let budget: Double
            }
            """,
            expandedSource: """
            struct Report {
                let venue: String
                let sponsor: String?
                let drinks: [String]
                let complexStructure: [Date: [(String, Int)]]
                let characters: [String]?
                let budget: Double

                public func with(venue: String? = nil, sponsor: String?? = .some(nil), drinks: [String]? = nil, complexStructure: [Date: [(String, Int)]]? = nil, characters: [String]?? = .some(nil), budget: Double? = nil) -> Self {
                    Self (
                        venue: venue ?? self.venue,
                        sponsor: sponsor == .none ? nil : self.sponsor,
                        drinks: drinks ?? self.drinks,
                        complexStructure: complexStructure ?? self.complexStructure,
                        characters: characters == .none ? nil : self.characters,
                        budget: budget ?? self.budget
                    )
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
