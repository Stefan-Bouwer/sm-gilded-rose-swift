import Testing
@testable import GildedRose

// MARK: Tags

extension Tag {
    @Tag static var ciUnstable: Self
}

@Suite
struct GildedRoseSwiftTests {
    // MARK: Playground
    
    @Suite
    struct PlaygroundTests {
        /// Conforming to `CustomStringConvertible` helps to see the exact test being run which is especially helpful
        /// if you're using this struct to group different parameters for your test that will run multiple times with the different parameters
        struct GildedRoseTestParameter: CustomTestStringConvertible {
            let sellIn: Int
            let quality: Int
            
            var testDescription: String {
                return "Testing with sellIn: \(sellIn) and quality: \(quality)"
            }
        }
        
        @Test(arguments: [
            GildedRoseTestParameter(sellIn: 10, quality: 2),
            GildedRoseTestParameter(sellIn: 20, quality: 4),
            GildedRoseTestParameter(sellIn: 30, quality: 6)
        ], [
            "Item One",
            "Item Two",
            "Item Three"
        ])
        func testMultipleParemeters(paremeter: GildedRoseTestParameter, name: String) async throws {
            let item = try #require(GildedRoseSwiftTests.optionalItem(Item(name: name, sellIn: paremeter.sellIn, quality: paremeter.quality), nullify: false))
            let expectedUpdatedItem = Item(name: name, sellIn: paremeter.sellIn - 1, quality: paremeter.quality - 1)
            
            try #require(GildedRose.sessionIsValid(true))
            
            let actualUpdatedItem = GildedRose.updateQuality([item])
            
            #expect([expectedUpdatedItem] == actualUpdatedItem)
        }
        
        @Test(arguments: zip([
            GildedRoseTestParameter(sellIn: 10, quality: 2),
            GildedRoseTestParameter(sellIn: 20, quality: 4),
            GildedRoseTestParameter(sellIn: 30, quality: 6)
        ], [
            "Item One",
            "Item Two",
            "Item Three"
        ]))
        func testZipMultipleParemeters(paremeter: GildedRoseTestParameter, name: String) async throws {
            let item = try #require(GildedRoseSwiftTests.optionalItem(Item(name: name, sellIn: paremeter.sellIn, quality: paremeter.quality), nullify: false))
            let expectedUpdatedItem = Item(name: name, sellIn: paremeter.sellIn - 1, quality: paremeter.quality - 1)
            
            try #require(GildedRose.sessionIsValid(true))
            
            let actualUpdatedItem = GildedRose.updateQuality([item])
            
            #expect([expectedUpdatedItem] == actualUpdatedItem)
        }
        
        /// Conforming to `CustomStringConvertible` helps to see the exact test being run which is especially helpful
        /// if you're using this struct to group different parameters for your test that will run multiple times with the different parameters
        struct GildedRoseWithNameTestParameter: CustomTestStringConvertible {
            let name: String
            let sellIn: Int
            let quality: Int
            
            var testDescription: String {
                return "Testing \(name) with sellIn: \(sellIn) and quality: \(quality)"
            }
        }
        
        @Test(arguments: [
            GildedRoseWithNameTestParameter(name: "Item One", sellIn: 10, quality: 2),
            GildedRoseWithNameTestParameter(name: "Item Two", sellIn: 20, quality: 4),
            GildedRoseWithNameTestParameter(name: "Item Three", sellIn: 30, quality: 6)
        ])
        func testSingleParemeters(paremeter: GildedRoseWithNameTestParameter) async throws {
            let item = try #require(GildedRoseSwiftTests.optionalItem(Item(name: paremeter.name, sellIn: paremeter.sellIn, quality: paremeter.quality), nullify: false))
            let expectedUpdatedItem = Item(name: paremeter.name, sellIn: paremeter.sellIn - 1, quality: paremeter.quality - 1)
            
            try #require(GildedRose.sessionIsValid(true))
            
            let actualUpdatedItem = GildedRose.updateQuality([item])
            
            #expect([expectedUpdatedItem] == actualUpdatedItem)
        }
        
        struct PassingTests {
            @Test("Test passes with all options")
            func testOne() async throws {
                let item = try #require(optionalItem(Item(name: "+5 Dexterity Vest", sellIn: 10, quality: 20), nullify: false))
                let expectedUpdatedItem = Item(name: "+5 Dexterity Vest", sellIn: 9, quality: 19)
                
                try #require(GildedRose.sessionIsValid(true))
                
                let actualUpdatedItem = GildedRose.updateQuality([item])
                
                #expect([expectedUpdatedItem] == actualUpdatedItem)
            }
            
            @Test("Only runs if session is valid",
                  .enabled(if: GildedRose.sessionIsValid(true)))
            func testFour() async throws {
                let item = try #require(optionalItem(Item(name: "+5 Dexterity Vest", sellIn: 10, quality: 20), nullify: false))
                let expectedUpdatedItem = Item(name: "+5 Dexterity Vest", sellIn: 9, quality: 19)
                
                let actualUpdatedItem = GildedRose.updateQuality([item])
                
                #expect([expectedUpdatedItem] == actualUpdatedItem)
            }
            
            @Test("Applicable for certain OS's")
            @available(macOS 13.0, *)
            func testSeven() async throws {
                let item = try #require(optionalItem(Item(name: "+5 Dexterity Vest", sellIn: 10, quality: 20), nullify: false))
                let expectedUpdatedItem = Item(name: "+5 Dexterity Vest", sellIn: 9, quality: 19)
                
                let actualUpdatedItem = GildedRose.updateQuality([item])
                
                #expect([expectedUpdatedItem] == actualUpdatedItem)
            }
            
            @Test("Test with a specific time limit",
                  .timeLimit(.minutes(1)))
            func testEight() async throws {
                let item = try #require(optionalItem(Item(name: "+5 Dexterity Vest", sellIn: 10, quality: 20), nullify: false))
                let expectedUpdatedItem = Item(name: "+5 Dexterity Vest", sellIn: 9, quality: 19)
                
                let actualUpdatedItem = GildedRose.updateQuality([item])
                
                #expect([expectedUpdatedItem] == actualUpdatedItem)
            }
        }
        
        struct FailingTests {
            @Test("Fails due to #require throwing due to Bool")
            func testTwo() async throws {
                let item = Item(name: "+5 Dexterity Vest", sellIn: 10, quality: 20)
                let expectedUpdatedItem = Item(name: "+5 Dexterity Vest", sellIn: 9, quality: 19)
                
                try #require(GildedRose.sessionIsValid(false))
                
                let actualUpdatedItem = GildedRose.updateQuality([item])
                
                #expect([expectedUpdatedItem] == actualUpdatedItem)
            }
            
            @Test("Fails due to #require throwing due to optional value")
            func testThree() async throws {
                let item = try #require(optionalItem(Item(name: "+5 Dexterity Vest", sellIn: 10, quality: 20), nullify: true))
                let expectedUpdatedItem = Item(name: "+5 Dexterity Vest", sellIn: 9, quality: 19)
                
                let actualUpdatedItem = GildedRose.updateQuality([item])
                
                #expect([expectedUpdatedItem] == actualUpdatedItem)
            }
        }
        
        struct SkippedTests {
            @Test("Only runs if session isn't valid",
                  .enabled(if: GildedRose.sessionIsValid(false)))
            func testFive() async throws {
                let item = try #require(optionalItem(Item(name: "+5 Dexterity Vest", sellIn: 10, quality: 20), nullify: false))
                let expectedUpdatedItem = Item(name: "+5 Dexterity Vest", sellIn: 9, quality: 19)
                
                let actualUpdatedItem = GildedRose.updateQuality([item])
                
                #expect([expectedUpdatedItem] == actualUpdatedItem)
            }
            
            @Test("Disabled due to instability",
                  .disabled())
            func testSix() async throws {
                let item = try #require(optionalItem(Item(name: "+5 Dexterity Vest", sellIn: 10, quality: 20), nullify: false))
                let expectedUpdatedItem = Item(name: "+5 Dexterity Vest", sellIn: 9, quality: 19)
                
                let actualUpdatedItem = GildedRose.updateQuality([item])
                
                #expect([expectedUpdatedItem] == actualUpdatedItem)
            }
            
            @Test("Marked as known issue, instead of commenting or disabling")
            func testNine() async throws {
                let item = try #require(optionalItem(Item(name: "+5 Dexterity Vest", sellIn: 10, quality: 20), nullify: false))
                let expectedUpdatedItem = Item(name: "+5 Dexterity Vest", sellIn: 9, quality: 19)
                
                let actualUpdatedItem = GildedRose.updateQuality([item])
                
                withKnownIssue("Test fails due to a known issue") {
                    #expect([expectedUpdatedItem] != actualUpdatedItem)
                }
            }
            
            @Test("Marked as known issue due to intermittent CI failures",
                  .tags(.ciUnstable))
            func testTen() async throws {
                let item = try #require(optionalItem(Item(name: "+5 Dexterity Vest", sellIn: 10, quality: 20), nullify: false))
                let expectedUpdatedItem = Item(name: "+5 Dexterity Vest", sellIn: 9, quality: 19)
                
                let actualUpdatedItem = GildedRose.updateQuality([item])
                
                withKnownIssue("Test intermittently fails on CI", isIntermittent: true) {
                    #expect([expectedUpdatedItem] != actualUpdatedItem)
                }
            }
        }
    }
    
    @Suite
    struct ReformedGildedRoseTests {
        // MARK: Gilded Rose Tests
        
        // TODO: Add tags to test that test similar behaviours
        
        // TODO: Refactor into tests that could be repeatable with different parameters.
        
        // TODO: Have a test that tests error paths as well... For example:
        
        struct Normal {
            
        }
        
        struct AgedBrie {
            
        }
        
        struct Sulfuras {
            
        }
        
        struct BackstagePasses {
            
        }
        
        struct Conjured {
            
        }
    }
}

// MARK: Helpers

extension GildedRoseSwiftTests {
    static func optionalItem(_ item: Item, nullify: Bool) -> Item? {
        if nullify {
            return nil
        }
        return item
    }
}
