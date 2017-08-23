import Vapor

protocol Routeable {
  func addRoutes(to drop: Droplet)
}
