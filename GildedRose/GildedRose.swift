public class GildedRose {
    public static func updateQuality(_ items: Array<Item>) -> [Item] {
        var items = items
        for i in 0 ..< items.count {
            let itemName = ItemName(rawValue: items[i].name)
            
            switch itemName {
            case .agedBrie:
                items[i].addQuantity()
                
                items[i].sellIn = items[i].sellIn - 1
                
                if items[i].sellIn < 0 {
                    items[i].addQuantity()
                }
            case .TAFKAL80ETC:
                if items[i].quality < 50 {
                    items[i].quality = items[i].quality + 1
                    
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
                items[i].sellIn = items[i].sellIn - 1
                
                if items[i].sellIn < 0 {
                    items[i].quality = items[i].quality - items[i].quality
                }
                
            case .sulfuras:
                break
            case nil:
                if items[i].quality > 0 {
                    items[i].quality = items[i].quality - 1
                }
                items[i].sellIn = items[i].sellIn - 1
                
                if items[i].sellIn < 0 {
                    if items[i].quality > 0 {
                        items[i].quality = items[i].quality - 1
                    }
                }
            }
        }
   
        return items
    }
    
}

extension Item {
    mutating func addQuantity(amount: Int = 1) {
        if self.quality < 50 {
            self.quality = self.quality + amount
        }
    }
}

enum ItemName: String {
    case agedBrie = "Aged Brie"
    case TAFKAL80ETC = "Backstage passes to a TAFKAL80ETC concert"
    case sulfuras = "Sulfuras, Hand of Ragnaros"
}
