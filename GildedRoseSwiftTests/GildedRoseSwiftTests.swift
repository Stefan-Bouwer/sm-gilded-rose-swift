import Testing
@testable import GildedRose

// MARK: Tags

extension Tag {
    @Tag static var ciUnstable: Self
}

@Suite
struct GildedRoseSwiftTests {
    /// Conforming to `CustomStringConvertible` helps to see the exact test being run
    /// helpful if you need to group different parameters together,
    /// especially for test with multiple arguments
    struct GildedRoseTestParameter: CustomTestStringConvertible {
        let sellIn: Int
        let quality: Int
        
        var testDescription: String {
            return "Testing with sellIn: \(sellIn) and quality: \(quality)"
        }
    }
    
    /// Conforming to `CustomStringConvertible` helps to see the exact test being run
    /// helpful if you need to group different parameters together,
    /// especially for test with multiple arguments
    struct GildedRoseWithNameTestParameter: CustomTestStringConvertible {
        let name: String
        let sellIn: Int
        let quality: Int
        
        var testDescription: String {
            return "Testing \(name) with sellIn: \(sellIn) and quality: \(quality)"
        }
    }
    
    /*
     Tests are organised into group and subgroups
     */
    
    // MARK: Playground
    @Suite
    struct PlaygroundTests {
        /// Test with paremeters
        ///
        /// - Shows usage of `#require`
        /// - Shows one possible usage of requiring `sessionIsValid`
        /// - Shows usage of `#expect`
        ///
        /// Xcode will automatically create 3 different instances of the same test for each parameter.
        /// Each test variation also means a brand new instance of the `PlaygroundTests` suite it is in.
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
        
        /// Test multiple parameters
        ///
        /// - Shows usage of `#require`
        /// - Shows one possible usage of requiring `sessionIsValid`
        /// - Shows usage of `#expect`
        ///
        /// Xcode will automatically match up the first parameter to each possible use case of the second, which results in 9 tests.
        /// This is amazing as we as developers don't have to manually come up with all the different scenarios to be tested. Xcode does it for us.
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
            let itemToBeUpdated = Item(name: name, sellIn: paremeter.sellIn, quality: paremeter.quality)
            let expectedUpdatedItem = Item(name: name, sellIn: paremeter.sellIn - 1, quality: paremeter.quality - 1)
            
            try #require(GildedRose.sessionIsValid(true))
            let requiredItem = try #require(GildedRoseSwiftTests.optionalItem(itemToBeUpdated, nullify: false))
            
            let actualUpdatedItem = GildedRose.updateQuality([requiredItem])
            
            #expect([expectedUpdatedItem] == actualUpdatedItem)
        }
        
        /// Test multiple parameters - zipped
        ///
        /// - Shows usage of `#require`
        /// - Shows one possible usage of requiring `sessionIsValid`
        /// - Shows usage of `#expect`
        ///
        /// Xcode will automatically match up each parameter at index x, which results in 3 tests
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
        
        /// Shows how to break out of a test early
        @Test
        func recordAnIssue() {
            Issue.record("This is a test issue")
        }
    }
    
    // MARK: PassingTests
    struct PassingTests {
        /// A passing test with a custom test description trait
        @Test("Test passes with all options")
        func testOne() async throws {
            let item = try #require(optionalItem(Item(name: "+5 Dexterity Vest", sellIn: 10, quality: 20), nullify: false))
            let expectedUpdatedItem = Item(name: "+5 Dexterity Vest", sellIn: 9, quality: 19)
            
            try #require(GildedRose.sessionIsValid(true))
            
            let actualUpdatedItem = GildedRose.updateQuality([item])
            
            #expect([expectedUpdatedItem] == actualUpdatedItem)
        }
        
        /// A passing test with a custom test description trait
        /// which is also only enabled if the `GildedRose` session is valid.
        ///
        /// If the session isn't valid, the test is not executed, but still compiled.
        @Test("Only runs if session is valid",
              .enabled(if: GildedRose.sessionIsValid(true)))
        func testFour() async throws {
            let item = try #require(optionalItem(Item(name: "+5 Dexterity Vest", sellIn: 10, quality: 20), nullify: false))
            let expectedUpdatedItem = Item(name: "+5 Dexterity Vest", sellIn: 9, quality: 19)
            
            let actualUpdatedItem = GildedRose.updateQuality([item])
            
            #expect([expectedUpdatedItem] == actualUpdatedItem)
        }
        
        /// A passing test with a custom test description trait
        ///
        /// The `@available` works with tests as well
        @Test("Applicable for certain OS's")
        @available(macOS 13.0, *)
        func testSeven() async throws {
            let item = try #require(optionalItem(Item(name: "+5 Dexterity Vest", sellIn: 10, quality: 20), nullify: false))
            let expectedUpdatedItem = Item(name: "+5 Dexterity Vest", sellIn: 9, quality: 19)
            
            let actualUpdatedItem = GildedRose.updateQuality([item])
            
            #expect([expectedUpdatedItem] == actualUpdatedItem)
        }
        
        /// A passing test with a custom test description trait
        /// which also has a time limit trait of 1 minute. If the test takes
        /// longer than 1 minute to run, the test will fail.
        @Test("Test with a specific time limit",
              .timeLimit(.minutes(1)))
        func testEight() async throws {
            let item = try #require(optionalItem(Item(name: "+5 Dexterity Vest", sellIn: 10, quality: 20), nullify: false))
            let expectedUpdatedItem = Item(name: "+5 Dexterity Vest", sellIn: 9, quality: 19)
            
            let actualUpdatedItem = GildedRose.updateQuality([item])
            
            #expect([expectedUpdatedItem] == actualUpdatedItem)
        }
    }

    // MARK: FailingTests
    struct FailingTests {
        /// A test completely breaks out of the test if the `#require` check fails.
        /// This check fails due to a `false` bool
        @Test("Fails due to #require throwing due to Bool")
        func testTwo() async throws {
            let item = Item(name: "+5 Dexterity Vest", sellIn: 10, quality: 20)
            let expectedUpdatedItem = Item(name: "+5 Dexterity Vest", sellIn: 9, quality: 19)
            
            try #require(GildedRose.sessionIsValid(false))
            
            let actualUpdatedItem = GildedRose.updateQuality([item])
            
            #expect([expectedUpdatedItem] == actualUpdatedItem)
        }
        
        /// A test completely breaks out of the test if the `#require` check fails.
        /// This check fails due to an optional that failed to unwrap.
        @Test("Fails due to #require throwing due to optional value")
        func testThree() async throws {
            let item = try #require(optionalItem(Item(name: "+5 Dexterity Vest", sellIn: 10, quality: 20), nullify: true))
            let expectedUpdatedItem = Item(name: "+5 Dexterity Vest", sellIn: 9, quality: 19)
            
            let actualUpdatedItem = GildedRose.updateQuality([item])
            
            #expect([expectedUpdatedItem] == actualUpdatedItem)
        }
    }
    
    // MARK: SkippedTests
    struct SkippedTests {
        /// A skipped test with a custom test description trait
        /// which is also only enabled if the `GildedRose` session is valid.
        ///
        /// If the session isn't valid, the test is not executed, but still compiled.
        @Test("Only runs if session isn't valid",
              .enabled(if: GildedRose.sessionIsValid(false)))
        func testFive() async throws {
            let item = try #require(optionalItem(Item(name: "+5 Dexterity Vest", sellIn: 10, quality: 20), nullify: false))
            let expectedUpdatedItem = Item(name: "+5 Dexterity Vest", sellIn: 9, quality: 19)
            
            let actualUpdatedItem = GildedRose.updateQuality([item])
            
            #expect([expectedUpdatedItem] == actualUpdatedItem)
        }
        
        /// A skipped test with a custom test description trait
        ///
        /// What would be a good candidate to forcefully mark a test just as `.disabled()`?
        /// Still better than commenting it out
        @Test("Disabled due to instability",
              .disabled())
        func testSix() async throws {
            let item = try #require(optionalItem(Item(name: "+5 Dexterity Vest", sellIn: 10, quality: 20), nullify: false))
            let expectedUpdatedItem = Item(name: "+5 Dexterity Vest", sellIn: 9, quality: 19)
            
            let actualUpdatedItem = GildedRose.updateQuality([item])
            
            #expect([expectedUpdatedItem] == actualUpdatedItem)
        }
        
        /// A skipped test with a custom test description trait
        ///
        /// Any validation that we KNOW fails every time, instead of commenting
        /// out the test or removing it it can be marked as a known issue, to suite
        /// as a reminder to get back to it.
        ///
        /// The invert happens if the expectation doesn't actually fail...
        @Test("Marked as known issue, instead of commenting or disabling")
        func testNine() async throws {
            let item = try #require(optionalItem(Item(name: "+5 Dexterity Vest", sellIn: 10, quality: 20), nullify: false))
            let expectedUpdatedItem = Item(name: "+5 Dexterity Vest", sellIn: 9, quality: 19)
            
            let actualUpdatedItem = GildedRose.updateQuality([item])
            
            withKnownIssue("Test fails due to a known issue") {
                #expect([expectedUpdatedItem] == actualUpdatedItem)
            }
        }
        
        /// A skipped test with a custom test description trait
        ///
        /// Any validation that we KNOW fails every time, instead of commenting
        /// out the test or removing it it can be marked as a known issue, to suite
        /// as a reminder to get back to it.
        ///
        /// Also take notice of the `ciUnstable` tag.
        ///
        /// The invert happens in this case comapring to the previous
        @Test("Marked as known issue due to intermittent CI failures",
              .tags(.ciUnstable))
        func testTen() async throws {
            let item = try #require(optionalItem(Item(name: "+5 Dexterity Vest", sellIn: 10, quality: 20), nullify: false))
            let expectedUpdatedItem = Item(name: "+5 Dexterity Vest", sellIn: 9, quality: 19)
            
            let actualUpdatedItem = GildedRose.updateQuality([item])
            
            withKnownIssue("Test intermittently fails on CI", isIntermittent: true) {
                #expect([expectedUpdatedItem] == actualUpdatedItem)
            }
        }
    }
    
    // MARK: Helpers
    
    static func optionalItem(_ item: Item, nullify: Bool) -> Item? {
        if nullify {
            return nil
        }
        return item
    }
}

// MARK: ReformedGildedRoseTests

/// Even though the item to be validated is not in our scope, we still want to conform to `CustomTestStringConvertible` here.
/// We certainly don't want to do it in our production code!
extension Array: @retroactive CustomTestStringConvertible where Element == Item {
    public var testDescription: String {
        var description: String = ""
        for (index, item) in self.enumerated() {
            if index > 0 {
                description.append(", Input name: \(item.name), sellIn: \(item.sellIn) and quality: \(item.quality)")
            } else {
                description.append("Input name: \(item.name), sellIn: \(item.sellIn) and quality: \(item.quality)")
            }
        }
        
        return description
    }
}

/*
 Tests are broken down here! Can we fix it?
 
 Maybe our new "show" button could help us out to fix it easily?
 */
@Suite
struct ReformedGildedRoseTests {
    ///25 different tests will be created
    @Test("Test update of quality for normal, aged-bried, sulfuras, backstage-passes and conjured items", arguments: zip([
        [Item(name: "+5 Dexterity Vest", sellIn: 9, quality: 20)],
        [Item(name: "Wirt's Third Leg", sellIn: 29, quality: 1), Item(name: "Drakefire Amulet", sellIn: 5, quality: 5)],
        [Item(name: "Periapt of Vitality", sellIn: 0, quality: 7)],
        [Item(name: "Skull of Gul'dan", sellIn: -10, quality: 50)],
        [Item(name: "Khadgar's Whisker", sellIn: -10, quality: 0)],
        [Item(name: "Aged Brie", sellIn: 10, quality: 15)],
        [Item(name: "Aged Brie", sellIn: 10, quality: 50)],
        [Item(name: "Aged Brie", sellIn: 0, quality: 15)],
        [Item(name: "Aged Brie", sellIn: 0, quality: 49)],
        [Item(name: "Aged Brie", sellIn: 0, quality: 50)],
        [Item(name: "Aged Brie", sellIn: -10, quality: 15)],
        [Item(name: "Aged Brie", sellIn: -10, quality: 49)],
        [Item(name: "Aged Brie", sellIn: -10, quality: 50)],
        [Item(name: "Sulfuras, Hand of Ragnaros", sellIn: 10, quality: 80)],
        [Item(name: "Sulfuras, Hand of Ragnaros", sellIn: 0, quality: 80)],
        [Item(name: "Sulfuras, Hand of Ragnaros", sellIn: -10, quality: 80)],
        [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 11, quality: 5)],
        [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 11, quality: 50)],
        [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 10, quality: 5)],
        [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 6, quality: 5)],
        [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 5, quality: 5)],
        [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 1, quality: 5)],
        [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 0, quality: 5)],
        [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: -1, quality: 5)],
        [Item(name: "Conjured Mana Cake", sellIn: 5, quality: 1)]
    ], [
        [Item(name: "+5 Dexterity Vest", sellIn: 9, quality: 19)],
        [Item(name: "Wirt's Third Leg", sellIn: 29, quality: 0), Item(name: "Drakefire Amulet", sellIn: 4, quality: 4)],
        [Item(name: "Periapt of Vitality", sellIn: -1, quality: 5)],
        [Item(name: "Skull of Gul'dan", sellIn: -11, quality: 48)],
        [Item(name: "Khadgar's Whisker", sellIn: -11, quality: 0)],
        [Item(name: "Aged Brie", sellIn: 9, quality: 16)],
        [Item(name: "Aged Brie", sellIn: 9, quality: 50)],
        [Item(name: "Aged Brie", sellIn: -1, quality: 17)],
        [Item(name: "Aged Brie", sellIn: -1, quality: 50)],
        [Item(name: "Aged Brie", sellIn: -1, quality: 50)],
        [Item(name: "Aged Brie", sellIn: -11, quality: 17)],
        [Item(name: "Aged Brie", sellIn: -11, quality: 50)],
        [Item(name: "Aged Brie", sellIn: -11, quality: 50)],
        [Item(name: "Sulfuras, Hand of Ragnaros", sellIn: 10, quality: 80)],
        [Item(name: "Sulfuras, Hand of Ragnaros", sellIn: 0, quality: 80)],
        [Item(name: "Sulfuras, Hand of Ragnaros", sellIn: -10, quality: 80)],
        [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 10, quality: 6)],
        [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 10, quality: 50)],
        [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 9, quality: 7)],
        [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 5, quality: 7)],
        [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 4, quality: 8)],
        [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 0, quality: 8)],
        [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: -1, quality: 0)],
        [Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: -2, quality: 0)],
        [Item(name: "Conjured Mana Cake", sellIn: 4, quality: 0)]
    ]))
    func updateQuality(with inputItems: [Item], expectedItems: [Item]) {
        let actualItems = GildedRose.updateQuality(inputItems)
        
        #expect(actualItems == expectedItems)
    }
}
