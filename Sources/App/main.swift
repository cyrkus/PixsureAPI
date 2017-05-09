import Vapor

let drop = Droplet()

drop.get { req in
drop.resource("posts", PostController())

drop.run()
