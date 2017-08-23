import Vapor
import AuthProvider

extension Droplet {
  func setupRoutes() throws {
    let usersController = UsersController()
    usersController.addRoutes(to: self)
    
    let tokensController = TokensController()
    tokensController.addRoutes(to: self)
  }
}
