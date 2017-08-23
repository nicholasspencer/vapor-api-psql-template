import Vapor
import PostgreSQLProvider

public class ApplicationController {
  let config: Config
  let drop: Droplet
  
  public init() throws {
    self.config = try Config()
    try config.addProvider(PostgreSQLProvider.Provider.self)
    try config.setup()
    
    self.drop = try Droplet(self.config)
    try drop.setup()
  }
  
  public func run() throws {
    try drop.run()
  }
}


