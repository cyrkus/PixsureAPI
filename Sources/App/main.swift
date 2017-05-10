import Vapor
import VaporMongo

let drop = Droplet()
drop.preparations.append(Pixsure.self)

do {
  try drop.addProvider(VaporMongo.Provider.self)
} catch {
  assertionFailure("error adding provider \(error)")
}


//MARK: GET
drop.get("pixsures") { req in
  let pixsures = try Pixsure.all()
  let pixsureNode = try pixsures.makeNode()
  
  let nodeDict = ["pixsures": pixsureNode]
  return try JSON(node: nodeDict)
}

drop.post("pixsure") { req in
  var pixsure = try Pixsure(node: req.json)
  try pixsure.save()
  return try pixsure.makeJSON()
}
  
drop.resource("posts", PostController())
  
drop.run()
