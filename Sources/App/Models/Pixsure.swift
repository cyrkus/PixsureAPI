import Foundation
import Vapor

struct Pixsure: Model {
  var exists: Bool = false
  var id: Node?
  var modificationDate: String
  let imageURL: String
  let hotspotLocation: HotSpotLocation
  
  init(imageURL: String, hotspotLocations: HotSpotLocation, modificationDate: String){
    self.modificationDate = modificationDate
    self.imageURL = imageURL
    self.hotspotLocation = hotspotLocations
  }
  
  init(node: Node, in context: Context) throws {
    //    id = try node.extract("id")
    modificationDate = try node.extract("modificationDate")
    imageURL = try node.extract("imageURL")
    hotspotLocation = try node.extract("hotspotLocations")
  }
  
  static func prepare(_ database: Database) throws {
    //Using MongoDB so leave this unimplemented
  }
  
  func makeNode(context: Context) throws -> Node {
    
    return try Node(node: ["modificationDate": modificationDate,
                     "imageURL": imageURL,
                     "hotSpotLocation": hotspotLocation.makeNode()])
  }
  
  static func revert(_ database: Database) throws {
    try database.delete("Pixsures")
  }
}

struct HotSpotLocation: Model {
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
    return try Node(node: ["type": type,
                           "param": param])
  }
  
  static func revert(_ database: Database) throws {
    try database.delete("hotSpotLocation")
  }
  
  
}

//
//enum HotSpotLocation {
//  case topLeft
//  case topMid
//  case topRight
//  case midLeft
//  case midRight
//  case botLeft
//  case botMid
//  case botRight
//}


enum TapFunctionality {
  case share
  case openURL
  case showCard
}
