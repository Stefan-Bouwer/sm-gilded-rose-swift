public class GildedRose {
    
    public static func updateQuality(_ items: Array<Item>) -> [Item] {
        var items = items
        for i in 0 ..< items.count {
            if !items[i].isSameName(as: .agedBrie) && !items[i].isSameName(as: .passesTafkal) {
                if items[i].quality > 0 {
                    if items[i].name != ItemName.sulfurus.rawValue {
                        items[i].quality = items[i].quality - 1
                    }
                }
            } else {
                if checkQualityAndSetItemQuality(items: &items, at: i, qualityCheck: 50) {
                    if items[i].name == ItemName.passesTafkal.rawValue {
                        checkSellInQuantityAndSetItemQuality(items: &items, at: i, sellInChecK: 11, qualityCheck: 50)
                        
                        checkSellInQuantityAndSetItemQuality(items: &items, at: i, sellInChecK: 6, qualityCheck: 50)
                    }
                }
            }
            
            if !items[i].isSameName(as: .sulfurus) {
                items[i].sellIn = items[i].sellIn - 1
            }
            
            processIfSellInIsLessThanZero(items: &items, at: i)
        }
   
        return items
    }
    
    static func checkSellInQuantityAndSetItemQuality(items: inout [Item], at index: Int, sellInChecK: Int, qualityCheck: Int) {
        if items[index].sellIn < sellInChecK {
            checkQualityAndSetItemQuality(items: &items, at: index, qualityCheck: qualityCheck)
        }
    }
    
    @discardableResult
    static func checkQualityAndSetItemQuality(items: inout [Item], at index: Int, qualityCheck: Int) -> Bool {
        let result = items[index].isQualityLessThan(qualityCheck)
        if result {
            items[index].quality = items[index].quality + 1
        }
        return result
    }
    
    static func processIfSellInIsLessThanZero(items: inout [Item], at index: Int) {
        guard items[index].sellIn < 0 else {
            return
        }
        
        if !items[index].isSameName(as: .agedBrie) {
            if !items[index].isSameName(as: .passesTafkal) {
                lessenQualityForPassesTafkal(items: &items, at: index)
            } else {
                lessenQuality(items: &items, at: index, with: items[index].quality)
            }
        } else {
            checkQualityAndSetItemQuality(items: &items, at: index, qualityCheck: 50)
        }
    }
    
    static func lessenQualityForPassesTafkal(items: inout [Item], at index: Int) {
        if items[index].quality > 0 {
            if !items[index].isSameName(as: .sulfurus) {
                items[index].quality = items[index].quality - 1
            }
        }
    }
    
    static func lessenQuality(items: inout [Item], at index: Int, with amount: Int) {
        items[index].quality = items[index].quality - amount
    }
}

enum ItemName: String {
    case agedBrie = "Aged Brie"
    case passesTafkal = "Backstage passes to a TAFKAL80ETC concert"
    case sulfurus = "Sulfuras, Hand of Ragnaros"
}

extension Item {
    func isQualityLessThan(_ value: Int) -> Bool {
        quality < value
    }
    
    func isSameName(as name: ItemName) -> Bool {
        self.name == name.rawValue
    }
}
