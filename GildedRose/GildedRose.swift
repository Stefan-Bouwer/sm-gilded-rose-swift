public class GildedRose {
    
    enum Products: String {
        case agedBrie = "Aged Brie"
        case backstage = "Backstage passes to a TAFKAL80ETC concert"
        case sulfuras = "Sulfuras, Hand of Ragnaros"
        case sulfurasConjured = "Sulfuras, Hand of Ragnaros (Conjured)"
    }
    
    
    public static func updateQuality(_ items: Array<Item>) -> [Item] {
        var items = items
        for i in 0 ..< items.count {
            let name = Products(rawValue: items[i].name)
            
            if items[i].name != Products.agedBrie.rawValue && items[i].name != Products.backstage.rawValue {
                if items[i].quality > 0 {
                    if items[i].name != Products.sulfuras.rawValue {
                        items[i].quality = items[i].quality - 1
                    }
                }
            } else {
                if items[i].quality < 50 {
                    items[i].quality = items[i].quality + 1
                    
                    if items[i].name == Products.backstage.rawValue {
                        if items[i].sellIn < 11 {
                            if items[i].quality < 50 {
                                items[i].quality = items[i].quality + 1
                            }
                        }
                        
                        if items[i].sellIn < 6 {
                            if items[i].quality < 50 {
                                items[i].quality = items[i].quality + 1
                            }
                        }
                    }
                }
            }
            
            switch name {
            case .agedBrie:
                items[i].sellIn = items[i].sellIn - 1
            case .backstage:
                items[i].sellIn = items[i].sellIn - 1
            case .sulfuras:
                break
            case .sulfurasConjured:
                items[i].sellIn = items[i].sellIn - 1
            default:
                items[i].sellIn = items[i].sellIn - 1
            }

            checkSellIn(item: &items[i])
        }
   
        return items
    }
    
    private static func checkSellIn(item: inout Item) {
        guard item.sellIn < 0 else {
            return
        }
        
        guard item.name != Products.agedBrie.rawValue else {
            if item.quality < 50 {
                item.quality = item.quality + 1
            }
            return
        }
        
        if item.name != Products.backstage.rawValue {
            if item.quality > 0 {
                if item.name != Products.sulfuras.rawValue {
                    item.quality = item.quality - 1
                }
            }
        } else {
            item.quality = item.quality - item.quality
        }
    }
    
    private static func reduceQuantityIfNotSulfuras(item: inout Item) {
        if item.quality > 0 {
            if item.name != Products.sulfuras.rawValue {
                item.quality = item.quality - 1
            }
        }
    }
}
