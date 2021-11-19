public class GildedRose {
    var items: [Item]

    let agedBrie = "Aged Brie"
    let backstagePasses = "Backstage passes to a TAFKAL80ETC concert"
    let sulfuras = "Sulfuras, Hand of Ragnaros"
    let conjured = "Conjured Mana Cake"
    
    public init(items: [Item]) {
        self.items = items
    }
    public func updateQuality() {
        for item in items {
            update(item)
        }
    }

    private func update(_ item: Item) {
        let itemDegrades = item.name != agedBrie && item.name != backstagePasses && item.name != sulfuras
        let itemExpired = item.sellIn < 1

        var degradeAmount: Int {
            let amount = (item.name == conjured) ? 2 : 1
            return itemExpired ? amount * 2 : amount
        }

        if (itemDegrades) {
            degradeQuality(of: item, by: degradeAmount)
        }

        if (item.name == agedBrie) {
            let brieUpgradeAmount = itemExpired ? 2 : 1
            upgradeQuality(of: item, by: brieUpgradeAmount)
        }

        if (item.name == backstagePasses) {
            upgradeQuality(of: item)

            if (item.sellIn < 11) {
                upgradeQuality(of: item)
            }
            if (item.sellIn < 6) {
                upgradeQuality(of: item)
            }
            if (itemExpired) {
                // Quality drops to 0 after the concert
                item.quality = item.quality - item.quality
            }
        }

        if (item.name != sulfuras) {
            item.sellIn = item.sellIn - 1
        }

    }

    private func degradeQuality(of item: Item, by amount: Int = 1) {
        let degradedQuality = item.quality - amount
        if (0...50 ~= degradedQuality) {
            item.quality = degradedQuality
        }
    }

    private func upgradeQuality(of item: Item, by amount: Int = 1) {
        let upgradedQuality = item.quality + amount
        if (0...50 ~= upgradedQuality) {
            item.quality = upgradedQuality
        }
    }
}
