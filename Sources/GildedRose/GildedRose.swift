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
    let conjured = "Conjured Mana Cake"

    private func updateItemQuality(item: Item) {
        let degradeAmount = (item.name == conjured) ? 2 : 1
        let itemDegrades = item.name != agedBrie && item.name != backstagePasses && item.name != sulfuras

        if (itemDegrades) {
            item.degradeQuality(by: degradeAmount)
        }

        if (item.name == agedBrie) {
            item.upgradeQuality()
        }

        if (item.name == backstagePasses) {
            item.upgradeQuality()

            if (item.sellIn < 11) {
                item.upgradeQuality()
            }
            if (item.sellIn < 6) {
                item.upgradeQuality()
            }
        }

        // all items except Sulfuras
        if (item.name != sulfuras) {
            // decrease sellIn!
            item.sellIn = item.sellIn - 1
        }

        // all items where sellIn date passed
        if (item.sellIn < 0) {
            if (itemDegrades) {
                item.degradeQuality(by: degradeAmount)
            }
            if (item.name == agedBrie) {
                item.upgradeQuality()
            } else if (item.name == backstagePasses) {
                // Quality drops to 0 after the concert
                item.quality = item.quality - item.quality
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
