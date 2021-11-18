public class GildedRose {
    var items: [Item]
    
    public init(items: [Item]) {
        self.items = items
    }
    
    public func updateQuality() {
        for i in 0 ..< items.count {

            // all items except Aged Brie and Backstage passes
            if (items[i].name != "Aged Brie" && items[i].name != "Backstage passes to a TAFKAL80ETC concert") {

                // all items with quality greater than 0
                if (items[i].quality > 0) {

                    // all items except Sulfuras
                    if (items[i].name != "Sulfuras, Hand of Ragnaros") {

                        // demote quality!
                        items[i].quality = items[i].quality - 1
                    }
                }
            } else {

                // aged brie or backstage passes
                // with quality less than 50
                if (items[i].quality < 50) {

                    // promote quality!
                    items[i].quality = items[i].quality + 1
                    
                    // backstage passes
                    if (items[i].name == "Backstage passes to a TAFKAL80ETC concert") {

                        // to sell in less than 11 days
                        if (items[i].sellIn < 11) {

                            // with quality below 50
                            if (items[i].quality < 50) {

                                // promote quality again!
                                items[i].quality = items[i].quality + 1
                            }
                        }

                        // backstage passes
                        if (items[i].sellIn < 6) {

                            // to sell in less than 6 days
                            if (items[i].quality < 50) {

                                // promote quality once more!
                                items[i].quality = items[i].quality + 1
                            }
                        }
                    }
                }
            }

            // all items except Sulfuras
            if (items[i].name != "Sulfuras, Hand of Ragnaros") {

                // demote sellIn!
                items[i].sellIn = items[i].sellIn - 1
            }

            // all items where sellIn date passed
            if (items[i].sellIn < 0) {

                // except aged brie
                if (items[i].name != "Aged Brie") {

                    // except backstage passes
                    if (items[i].name != "Backstage passes to a TAFKAL80ETC concert") {

                        // with quality greater than 0
                        if (items[i].quality > 0) {

                            // except sulfuras
                            if (items[i].name != "Sulfuras, Hand of Ragnaros") {

                                // demote quality!
                                items[i].quality = items[i].quality - 1
                            }
                        }
                    } else {
                        // backstage passes - sellIn date passed

                        // Quality drops to 0 after the concert
                        items[i].quality = items[i].quality - items[i].quality
                    }
                } else {
                    // aged brie - sellIn date passed

                    // (quality can never be greater than 50)
                    if (items[i].quality < 50) {

                        // promote quality!
                        items[i].quality = items[i].quality + 1
                    }
                }
            }
        }
    }
}
