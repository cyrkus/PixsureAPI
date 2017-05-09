import Foundation
import Vapor

struct Pixsure: Model {
  var exists: Bool = false
  var id: Node?
  let imageURL: String
  let hotspotLocations: [String]
  
  init(imageURL: String, hotspotLocations:[String]){
    
    self.imageURL = imageURL
    self.hotspotLocations = hotspotLocations
  }
  
  init(node: Node, in context: Context) throws {
    
    id = try node.extract("id")
    imageURL = try node.extract("imageURL")
    hotspotLocations = try node.extract("hotspotLocations")
  }
  
  func makeNode(context: Context) throws -> Node {
    
    return try Node(node: ["id": id])
  }
  
  static func prepare(_ database: Database) throws {
    
    try database.create("pixsures", closure: { (pixsure) in
      pixsure.id()
      pixsure.string("imageURL")
      
      pixsure.
    })
  }
  
  
  static func revert(_ database: Database) throws {
    try database.delete("pixsures")
  }
  
  
  
}

enum HotSpotLocation {
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
