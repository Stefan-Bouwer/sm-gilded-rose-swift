@available(iOS 17, macOS 13.0, *)
public class GildedRose {
    
    public static func updateQuality(_ items: Array<Item>) -> [Item] {
        var items = items
        
        for i in 0..<items.count {
            let item = items[i]
            
            if item.name != "Sulfuras, Hand of Ragnaros" {
                updateItemSellIn(&items[i])
                updateItemQuality(&items[i])
            }
        }
        
        return items
    }
    
    private static func updateItemSellIn(_ item: inout Item) {
        item.sellIn -= 1
    }
    
    private static func updateItemQuality(_ item: inout Item) {
        switch item.name {
        case "Aged Brie":
            updateAgedBrieQuality(&item)
        case "Backstage passes to a TAFKAL80ETC concert":
            updateBackstagePassQuality(&item)
        case let name where name.contains("Conjured"):
            updateConjuredItemQuality(&item)
        default:
            updateNormalItemQuality(&item)
        }
    }
    
    private static func updateAgedBrieQuality(_ item: inout Item) {
        if item.quality < 50 {
            item.quality += 1
        }
        if item.sellIn < 0, item.quality < 50 {
            item.quality += 1
        }
    }
    
    private static func updateBackstagePassQuality(_ item: inout Item) {
        if item.sellIn < 0 {
            item.quality = 0
        } else if item.quality < 50 {
            item.quality += 1
            if item.sellIn < 11 {
                item.quality += 1
            }
            if item.sellIn < 6 {
                item.quality += 1
            }
        }
    }
    
    private static func updateConjuredItemQuality(_ item: inout Item) {
        if item.quality > 0 {
            item.quality -= 2
        }
        if item.sellIn < 0, item.quality > 0 {
            item.quality -= 2
        }
        if item.quality < 0 {
            item.quality = 0
        }
    }
    
    private static func updateNormalItemQuality(_ item: inout Item) {
        if item.quality > 0 {
            item.quality -= 1
        }
        if item.sellIn < 0, item.quality > 0 {
            item.quality -= 1
        }
        if item.quality < 0 {
            item.quality = 0
        }
    }
}
