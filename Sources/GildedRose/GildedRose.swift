public class GildedRose {
    var items: [Item]
    
    public init(items: [Item]) {
        self.items = items
    }
    
    public func updateQuality() {
        for item in items {
            updateItemQuality(item: item)
        }
    }

    let agedBrie = "Aged Brie"
    let backstagePasses = "Backstage passes to a TAFKAL80ETC concert"
    let sulfuras = "Sulfuras, Hand of Ragnaros"

    private func updateItemQuality(item: Item) {
        // all items except Aged Brie and Backstage passes
        if (item.name != agedBrie && item.name != backstagePasses) {

            // all items except Sulfuras
            if (item.name != sulfuras) {

                item.degradeQuality()
            }
        } else {

            // aged brie or backstage passes
            // with quality less than 50

            item.upgradeQuality()

            // backstage passes
            if (item.name == backstagePasses) {

                // to sell in less than 11 days
                if (item.sellIn < 11) {

                    // promote quality again!
                    item.upgradeQuality()
                }

                // backstage passes
                if (item.sellIn < 6) {

                    // to sell in less than 6 days
                    item.upgradeQuality()
                }
            }
        }

        // all items except Sulfuras
        if (item.name != sulfuras) {

            // demote sellIn!
            item.sellIn = item.sellIn - 1
        }

        // all items where sellIn date passed
        if (item.sellIn < 0) {

            // except aged brie
            if (item.name != agedBrie) {

                // except backstage passes
                if (item.name != backstagePasses) {

                    // except sulfuras
                    if (item.name != sulfuras) {

                        item.degradeQuality()
                    }

                } else {
                    // backstage passes - sellIn date passed

                    // Quality drops to 0 after the concert
                    item.quality = item.quality - item.quality
                }
            } else {
                // aged brie - sellIn date passed
                item.upgradeQuality()
            }
        }
    }
}

extension Item {
    func degradeQuality(by amount: Int = 1) {
        let degradedQuality = quality - amount
        if (0...50 ~= degradedQuality) {
            quality = degradedQuality
        }
    }
    func upgradeQuality(by amount: Int = 1) {
        let upgradedQuality = quality + amount
        if (0...50 ~= upgradedQuality) {
            quality = upgradedQuality
        }
    }
}
