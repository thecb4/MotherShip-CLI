import Foundation
import Commander
import MotherShip
import CryptoSwift
import Files

let version = "0.1.0"

let mothership = MotherShip()
let testFlight = TestFlight()
let credManager = CredentialsManager()

extension Int64: ArgumentConvertible {
  public init(parser: ArgumentParser) throws {
    if let value = parser.shift() {
      if let value = Int64(value) {
        self.init(value)
      } else {
        throw ArgumentError.invalidType(value: value, type: "number", argument: nil)
      }
    } else {
      throw ArgumentError.missingValue(argument: nil)
    }
  }
}

let group = Group {
  
  $0.command("help") {}
  
  $0.command(
    "login",
    description: "Mothership login. You shouldn't have to do this directly"
  ) { (username:String, password:String) in
    
    print("logging \(username) into Mothership")
    
    let credentials = LoginCredentials(accountName: username, password:password)
    
    // TODO: Credentials store analysis
    
    mothership.login(with: credentials)
    
  }
  
  $0.command("ll",
   Option("username", default: "", description: "Apple ID"),
   Option("password", default: "", description: "Apple ID Password")
  ) { (username:String, password:String) in
    
    
    if username == "" && password == "" {
      guard let credentials = credManager.load() else {
        
        print("You need to enter credentials")
        
        print("Enter Account email and password")
        guard let response = readLine() else {
          print("bad entry -- try again")
          return
        }
        
        let credentialStrings = response.split(separator: " ")
        
        let accountName = String(describing: credentialStrings[0])
        let password    = String(describing: credentialStrings[1])
        
        if credManager.storeCredentials(accountName: accountName, password: password) {
          
          print("Account name and password saved. Please login again.")
          
        } else {
          
          print("Credentials not stored. Please try again")
          
        }
        
        return
        
      }
      
      // log in with existing credentials
      print("Logging \(credentials.accountName) into iTunes Connect")
      
    } else {
      
      let credentials = LoginCredentials(accountName: username, password:password)
      // log in with existing credentials
      print("Logging \(credentials.accountName) into iTunes Connect")
    
    }
    
  }
  
  $0.group("testflight") {
    
    $0.command(
      "testers",
      Option("appID", default: "", description: "App ID"),
      Option("teamID", default: "", description: "Apple ID Password")
    ) { (appID: String, teamID: String) in
      
      guard let credentials = credManager.load() else {
        print("use 'mothership login' to store credentials or supply at command line")
        return
      }
      
      testFlight.login(with: credentials)
      
      let appID  = AppIdentifier(appID)!
      let teamID = TeamIdentifier(teamID)!
      
      let testers = testFlight.testers(for: appID, in: teamID)
      print(testers)

    }

    $0.command(
      "invite",
      Argument<String>("email", description: "tester email address"),
      Argument<String>("firstNam", description: "tester first name"),
      Argument<String>("lastName", description: "tester last name"),
      Argument<AppIdentifier>("appID", description: "app id to add tester to"),
      Argument<TeamIdentifier>("teamID", description: "team id to add tester to")
    ) { (email:String, firstName: String, lastName: String, appID: AppIdentifier, teamID: TeamIdentifier) in
      
      guard let credentials = credManager.load() else {
        print("use 'mothership login' to store credentials or supply at command line")
        return
      }
      
      testFlight.login(with: credentials)
      
      let tester = Tester(email: email, firstName:firstName, lastName:lastName)
      
      
      let result = testFlight.invite(tester: tester, to: appID, for: teamID)
      
      print(result)
      
    }

    
  }
  
}

group.run(version)
