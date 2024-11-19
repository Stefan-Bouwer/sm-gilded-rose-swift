public struct Item: Equatable {
    var name: String
    var sellIn: Int
    var quality: Int
}

public func ==(lhs: Item, rhs: Item) -> Bool {
    return lhs.name == rhs.name && lhs.sellIn == rhs.sellIn && lhs.quality == rhs.quality
}
