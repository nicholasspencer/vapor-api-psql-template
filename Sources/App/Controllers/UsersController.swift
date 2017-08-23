import Vapor
import HTTP

final class UsersController {
  func store(_ request: Request, hash: HashProtocol) throws -> ResponseRepresentable {
    // require that the request body be json
    guard let json = request.json else {
      throw Abort(.badRequest)
    }
    
    // initialize the name and email from
    // the request json
    let user = try User(json: json)
    
    // ensure no user with this email already exists
    guard try User.makeQuery().filter("email", user.email).first() == nil else {
      throw Abort(.badRequest, reason: "A user with that email already exists.")
    }
    
    // require a plaintext password is supplied
    guard let password = json["password"]?.string else {
      throw Abort(.badRequest)
    }
    
    // hash the password and set it on the user
    user.password = try hash.make(password.makeBytes()).makeString()
    
    // save and return the new user
    try user.save()
    return user
  }
}

extension UsersController: Routeable {
  func addRoutes(to drop: Droplet) {
    drop.post("users") { req in
      return try self.store(req, hash: drop.hash)
    }
  }
}
