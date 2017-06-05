import Foundation
import Vapor

struct Pixsure: Model {
  var exists: Bool = false
  var id: Node?
  var pixsureID: String
  var modificationDate: String
  var cards: [Card]
  
  init(node: Node, in context: Context) throws {
    self.id = try node.extract(Constants.id)
    guard let pixsure = try node.nodeObject?.makeNode() else { throw NodeError.unableToConvert(node: node, expected: "pixsure") } // set up pixsure
    
    guard let pixsureID = pixsure[Constants.pixsureID]?.string,
      let modDate = pixsure[Constants.modDate]?.string else { throw NodeError.unableToConvert(node: node, expected: Constants.modDate) } // set the modification date
    self.modificationDate = modDate
    self.pixsureID = pixsureID
    
    guard let cardArray = pixsure[Constants.cards]?.nodeArray else { throw NodeError.unableToConvert(node: node, expected: "card") }
    var cards = [Card]()
    cardArray.forEach({
      do {
        cards.append(try Card(node: $0.makeNode(), in: context))
      } catch {
        print("can't even card")
      }
    })
    self.cards = cards
  }
  
  static func prepare(_ database: Database) throws {}
  
  func makeNode(context: Context) throws -> Node {
    return try Node(node: [Constants.id: id,
                           Constants.modDate: modificationDate,
                           Constants.cards: cards.makeNode(),
                           Constants.pixsureID: pixsureID])
  }
  
  static func revert(_ database: Database) throws {
    try database.delete("pixsure")
  }
}


struct Card: Model {
  var exists: Bool = false
  var id: Node?
  var modificationDate: String
  let imageURL: String
  var hotSpots: HotSpots
  
  init(imageURL: String, hotSpots: HotSpots, modificationDate: String){
    self.modificationDate = modificationDate
    self.imageURL = imageURL
    self.hotSpots = hotSpots
  }
  
  init(node: Node, in context: Context) throws {
    id = try node.extract("id")
    modificationDate = try node.extract(Constants.modDate)
    imageURL = try node.extract(Constants.imageURL)
    hotSpots = try node.extract(Constants.hotspots)
  }
  
  static func prepare(_ database: Database) throws {
    //Using MongoDB so leave this unimplemented
  }
  
  func makeNode(context: Context) throws -> Node {
    return try Node(node: ["id": id,
                           Constants.modDate: modificationDate,
                           Constants.imageURL: imageURL,
                           Constants.hotspots: hotSpots.makeNode()])
  }
  
  static func revert(_ database: Database) throws {
    try database.delete("cards")
  }
}

struct HotSpots: Model {
  var id: Node?
  var topLeft: Location
  var topRight: Location
  var botLeft: Location
  var botMid: Location
  var botRight: Location
  
  init(node: Node, in context: Context) throws {
    id = try node.extract("_id")
    topLeft = try node.extract(HotSpotLocation.topLeft.rawValue)
    topRight = try node.extract(HotSpotLocation.topRight.rawValue)
    botLeft = try node.extract(HotSpotLocation.botLeft.rawValue)
    botMid = try node.extract(HotSpotLocation.botMid.rawValue)
    botRight = try node.extract(HotSpotLocation.botRight.rawValue)
  }
  
  static func prepare(_ database: Database) throws {}
  
  
  func makeNode(context: Context) throws -> Node {
    return try Node(node: ["id": id,
                           HotSpotLocation.topLeft.rawValue: topLeft.makeNode(),
                           HotSpotLocation.topRight.rawValue: topRight.makeNode(),
                           HotSpotLocation.botLeft.rawValue: botLeft.makeNode(),
                           HotSpotLocation.botMid.rawValue: botMid.makeNode(),
                           HotSpotLocation.botRight.rawValue: botRight.makeNode()])
  }
  
  static func revert(_ database: Database) throws {}
}


struct Location: Model {
  var id: Node?
  var type: String
  var param: String
  
  init(type: String, param: String){
    self.type = type
    self.param = param
  }
  
  init(node: Node, in context: Context) throws {
    id = try node.extract("id")
    type = try node.extract("type")
    param = try node.extract("param")
  }
  
  static func prepare(_ database: Database) throws {
    // do nothing
  }
  
  func makeNode(context: Context) throws -> Node {
    return try Node(node: ["id": id,
                           "type": type,
                           "param": param])
  }
  
  static func revert(_ database: Database) throws {
    try database.delete("locations")
  }
}


enum HotSpotLocation: String {
  case topLeft
  case topMid
  case topRight
  case midLeft
  case midRight
  case botLeft
  case botMid
  case botRight
}


enum TapFunctionality {
  case share
  case openURL
  case showCard
}
