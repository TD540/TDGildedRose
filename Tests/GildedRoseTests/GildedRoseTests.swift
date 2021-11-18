@testable import GildedRose
import XCTest

class GildedRoseTests: XCTestCase {

    let app = GildedRose(items: [
        Item(name: "+5 Dexterity Vest", sellIn: 10, quality: 20),
        Item(name: "Aged Brie", sellIn: 2, quality: 0),
        Item(name: "Elixir of the Mongoose", sellIn: 5, quality: 7),
        Item(name: "Sulfuras, Hand of Ragnaros", sellIn: 0, quality: 80),
        Item(name: "Sulfuras, Hand of Ragnaros", sellIn: -1, quality: 80),
        Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 15, quality: 20),
        Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 10, quality: 49),
        Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 5, quality: 49),
        Item(name: "Conjured Mana Cake", sellIn: 3, quality: 6)
    ])

    func testDemoteSellIn() {
        app.updateQuality()
        XCTAssertEqual(app.items[0].sellIn, 9) // +5 Dexterity Vest
        XCTAssertEqual(app.items[1].sellIn, 1) // Aged Brie
    }

    func testQuality() {
        let app = GildedRose(items: [
            Item(name: "Regular Item", sellIn: 5, quality: 5)
        ])
        app.updateQuality()
        XCTAssertEqual(app.items[0].quality, 4)
    }

    func testQualityAfterSellDatePassed() {
        /* quality degrades twice as fast */
        let app = GildedRose(items: [
            Item(name: "Item", sellIn: 0, quality: 20)
        ])
        app.updateQuality()
        XCTAssertEqual(app.items[0].quality, 18)
    }

    func testQualityNeverNegative() {
        for _ in 1...200 {
            app.updateQuality()
        }
        for i in 0 ..< app.items.count {
            XCTAssertGreaterThanOrEqual(app.items[i].quality, 0)
        }
    }

    func testAgedBrieQualityIncrease() {
        let initialQuality = app.items[1].quality
        app.updateQuality()
        XCTAssertGreaterThan(app.items[1].quality, initialQuality)
    }
    
    func testAgedBrieDoubleQualityIncrease() {
        let app = GildedRose(items: [
            Item(name: "Aged Brie", sellIn: 0, quality: 2)
        ])
        app.updateQuality()
        XCTAssertEqual(app.items[0].sellIn, -1)
        XCTAssertEqual(app.items[0].quality, 4)
    }

    func testQualityNeverMoreThanFifty() {
        /* add quality 1000 to check if test fails */
//        app.items.append(
//            Item(name: "Item Quality over Fifty", sellIn: 5, quality: 1000)
//        )
        for _ in 1...200 {
            app.updateQuality()
            
            for i in 0 ..< app.items.count {
                if app.items[i].name != "Sulfuras, Hand of Ragnaros" {
                    XCTAssertLessThanOrEqual(app.items[i].quality, 50)
                }
            }
        }
    }

    func testLegendarySulfuras() {
        let app = GildedRose(items: [
            Item(name: "Sulfuras, Hand of Ragnaros", sellIn: 20, quality: 80)
        ])
        app.updateQuality()
        app.items[0].assertEqual(to: Item(name: "Sulfuras, Hand of Ragnaros", sellIn: 20, quality: 80))
    }

    func testBackstagePassesQualityIncrease() {
        let app = GildedRose(items: [
            Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 20, quality: 20)
        ])
        app.updateQuality()
        XCTAssertEqual(app.items[0].sellIn, 19)
        XCTAssertEqual(app.items[0].quality, 21)
        
        // sellIn not less than 11, quality increases by 1
        app.items[0].sellIn = 11
        app.updateQuality()
        XCTAssertEqual(app.items[0].quality, 22)
        
        // sellIn is less than 11, quality increases by 2
        app.items[0].sellIn = 10
        app.updateQuality()
        XCTAssertEqual(app.items[0].quality, 24)
        
        // sellIn is less than 6, quality increases by 3
        app.items[0].sellIn = 5
        app.updateQuality()
        XCTAssertEqual(app.items[0].quality, 27)
    }

    func testBackstagePassesQualityZeroAfterConcert() {
        let app = GildedRose(items: [
            Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 0, quality: 20)
        ])
        app.updateQuality()
        XCTAssertEqual(app.items[0].quality, 0)
    }

}

extension Item {
    func assertEqual(to item: Item) {
        XCTAssertEqual(self.description, item.description)
    }
}
