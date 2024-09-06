public class GildedRose {
    enum Name: String {
        case brie = "Aged Brie"
        case backstage = "Backstage passes to a TAFKAL80ETC concert"
        case sulfuras = "Sulfuras, Hand of Ragnaros"
        case anything
    }
    
    private static func updateAnything(item: inout Item) {
        guard item.quality > 0 else {
            return
        }
        
        item.quality = item.quality - 1
    }
    
    private static func updateBrie(item: inout Item) {
        guard item.quality < 50 else {
            return
        }
        
        item.quality = item.quality + 1
    }
    
    private static func updateBackstage(item: inout Item) {
        guard item.quality < 50 else {
            return
        }
        
        item.quality = item.quality + 1
        
        if item.sellIn < 11 {
            if item.quality < 50 {
                item.quality = item.quality + 1
            }
        }
        
        if item.sellIn < 6 {
            if item.quality < 50 {
                item.quality = item.quality + 1
            }
        }
    }
    
    private static func updatebrieOrBackstage(item: inout Item) {
        switch item.name {
        case Name.brie.rawValue:
            updateBrie(item: &item)
        case Name.backstage.rawValue:
            updateBackstage(item: &item)
        default:
            break
        }
    }
    
    private static func updateAllExceptSulfurasSellIn(item: inout Item) {
        if item.name != Name.sulfuras.rawValue {
            item.sellIn = item.sellIn - 1
        }
    }
    
    private static func updateIfSellInLessThanZero(item: inout Item) {
        if item.sellIn < 0 {
            if item.name != Name.brie.rawValue {
                if item.name != Name.backstage.rawValue {
                    if item.quality > 0 {
                        if item.name != Name.sulfuras.rawValue {
                            item.quality = item.quality - 1
                        }
                    }
                } else {
                    item.quality = item.quality - item.quality
                }
            } else {
                if item.quality < 50 {
                    item.quality = item.quality + 1
                }
            }
        }
    }
    
    public static func updateQuality(_ items: Array<Item>) -> [Item] {
        var newArray = Array<Item>()
        
        for var item in items {
            switch item.name {
            case Name.brie.rawValue:
                updateBrie(item: &item)
            case Name.backstage.rawValue:
                updateBackstage(item: &item)
            case Name.sulfuras.rawValue:
                break
            default:
                updateAnything(item: &item)
            }
            
            updateAllExceptSulfurasSellIn(item: &item)
            
            updateIfSellInLessThanZero(item: &item)
            
            newArray.append(item)
        }
   
        return newArray
    }
}
