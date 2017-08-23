import Vapor
import AuthProvider
import HTTP
import JSON

final class TokensController {
  func login(_ request: Request) throws -> ResponseRepresentable {
    let user = try request.user()
    let token = try Token.generate(for: user)
    try token.save()
    return token
  }
  
  func logout(_ request: Request) throws -> ResponseRepresentable {
    try request.auth.unauthenticate()
    var json = JSON()
    try json.set("authenticated", false)
    return json
  }
}

extension TokensController: Routeable {
  func addRoutes(to drop: Droplet) {
    
    // Password protected
    drop.group(middleware: [PasswordAuthenticationMiddleware(User.self)]) { password in
      // GET /tokens
      // Authorization: Basic <base64 email:password>
      password.get("tokens", handler: self.login)
    }
    
    // Token protected
    drop.group(middleware: [TokenAuthenticationMiddleware(User.self)]) { token in
      token.delete("tokens", handler: self.logout)
    }
  }
}
