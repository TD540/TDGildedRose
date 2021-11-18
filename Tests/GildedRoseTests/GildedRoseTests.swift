@testable import GildedRose
import XCTest

class GildedRoseTests: XCTestCase {

    let app = GildedRose(items: [
        Item(name: "Test item 0", sellIn: 5, quality: 50),
        Item(name: "Test item 1", sellIn: 10, quality: 20),
        // Item(name: "testQualityNeverMoreThanFifty", sellIn: 5, quality: 1000),
    ])

    func testDemoteSellIn() {
        // when
        app.updateQuality()

        // then
        XCTAssertEqual(app.items[0].sellIn, 4)
        XCTAssertEqual(app.items[1].sellIn, 9)
    }

    func testDemoteQuality() {
        // when
        app.updateQuality()

        // then
        XCTAssertEqual(app.items[0].quality, 49)
        XCTAssertEqual(app.items[1].quality, 19)
    }

    func testQualityAfterSellDatePassed() {
        // Once the sell by date has passed,
        // Quality degrades twice as fast
        app.items[0].sellIn = 0

        // when
        app.updateQuality()

        // then
        XCTAssertEqual(app.items[0].quality, 48)
    }

    func testQualityNeverNegative() {
        // when
        for _ in 1...200 {
            app.updateQuality()
        }

        // then
        for i in 0 ..< app.items.count {
            XCTAssertGreaterThanOrEqual(app.items[i].quality, 0)
        }
    }

    func testAgedBrieQualityIncrease() {
        // given
        let startQuality = 20
        app.items.append(
            Item(name: "Aged Brie", sellIn: 5, quality: startQuality)
        )

        // when
        app.updateQuality()

        // then
        XCTAssertGreaterThan(app.items.last!.quality, startQuality)
    }

    func testQualityNeverMoreThanFifty() {
        // when 200 days pass
        for _ in 1...200 {
            app.updateQuality()
        }

        // then
        for i in 0 ..< app.items.count {
            XCTAssertLessThanOrEqual(app.items[i].quality, 50)
        }
    }

    func testLegendarySulfuras() {
        // given
        app.items.append(
            Item(name: "Sulfuras, Hand of Ragnaros", sellIn: 20, quality: 80)
        )
        let startSellIn = app.items.last!.sellIn
        let startQuality = app.items.last!.quality

        // when 200 days pass
        for _ in 1...200 {
            app.updateQuality()
        }

        // then
        XCTAssertEqual(app.items.last!.quality, startQuality)
        XCTAssertEqual(app.items.last!.sellIn, startSellIn)
    }

    func testBackstagePassesQualityIncrease() {
        // given
        app.items.append(
            Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 11, quality: 10)
        )
        // when
        app.updateQuality()
        // then sellIn not less than 11, quality increases by 1
        XCTAssertEqual(app.items.last!.quality, 11)

        // when
        app.updateQuality()
        // then sellIn is less than 11, quality increases by 2
        XCTAssertEqual(app.items.last!.quality, 13)

        // given
        app.items.last!.sellIn = 5

        // when
        app.updateQuality()

        // then sellIn is less than 6, quality increases by 3
        XCTAssertEqual(app.items.last!.quality, 16)
    }

    func testBackstagePassesQualityZero() {
        // Backstage Passes Quality drops to 0 after the concert

        // given
        app.items.append(
            Item(name: "Backstage passes to a TAFKAL80ETC concert", sellIn: 0, quality: 20)
        )

        // when
        app.updateQuality()

        // sellIn = 0, concert is over, quality should be 0
        XCTAssertEqual(app.items.last!.quality, 0)
    }

}
