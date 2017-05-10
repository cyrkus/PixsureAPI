import Foundation
import Vapor

struct Pixsure: Model {
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
      modificationDate = try node.extract("modificationDate")
      imageURL = try node.extract("imageURL")
      hotSpots = try node.extract("hotSpots")
  }
  
  static func prepare(_ database: Database) throws {
    //Using MongoDB so leave this unimplemented
  }
  
  func makeNode(context: Context) throws -> Node {
    
    return try Node(node: ["id": id,
                           "modificationDate": modificationDate,
                           "imageURL": imageURL,
                           "hotSpots": hotSpots.makeNode()])
  }
  
  static func revert(_ database: Database) throws {
    try database.delete("Pixsures")
  }
}

struct HotSpots: Model {
  var id: Node?
  var topLeft: Location
  var topRight: Location
  
  init(node: Node, in context: Context) throws {
    id = try node.extract("id")
    topLeft = try node.extract(HotSpotLocation.topLeft.rawValue)
    topRight = try node.extract(HotSpotLocation.topRight.rawValue)
  }
  
  static func prepare(_ database: Database) throws {}

  
  func makeNode(context: Context) throws -> Node {
    return try Node(node: [HotSpotLocation.topLeft.rawValue: topLeft.makeNode(),
                           HotSpotLocation.topRight.rawValue: topRight.makeNode()])
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
