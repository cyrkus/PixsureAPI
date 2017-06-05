import Vapor
import VaporMongo

let drop = Droplet()
drop.preparations.append(Pixsure.self)
drop.preparations.append(Card.self)

do {
  try drop.addProvider(VaporMongo.Provider.self)
} catch {
  assertionFailure("error adding provider \(error)")
}


//MARK: GET

drop.get(Constants.pixsures, String.self) { req, pixsureID in
  let pixsureNode = try Pixsure.query().filter(Constants.pixsureID, pixsureID)
  
  return try JSON(node: pixsureNode.first())
}


drop.post("pixsure") { req in
  var pixsure = try Pixsure(node: req.json)
  try pixsure.save()
  return try pixsure.makeJSON()
}


drop.post("card") { req in
  var card = try Card(node: req.json)
  try card.save()
  return try card.makeJSON()
}


drop.resource("posts", PostController())


drop.run()
