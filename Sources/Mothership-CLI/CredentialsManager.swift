//
//  Credentials.swift
//  Mothership-CLI
//
//  Created by Cavelle Benjamin on 17-Dec-28 (53).
//

import Foundation
import Files
import CryptoSwift
import MotherShip

class CredentialsManager {
  
  let folderName = ".private"
  let fileName   = "credentials.bytes"
  let key = "passwordpassword".bytes
  let iv = "12345678".bytes
  
  func load() -> LoginCredentials? {
    
    guard let credentialsFile = try? Folder.current.file(atPath: ".private/credentials.bytes") else {
      return nil
    }
    
    guard let fromFile = try? credentialsFile.read() else { return nil }
    
    guard let decrypted = try? Blowfish(key: key, blockMode: .CFB(iv: iv), padding: .noPadding).decrypt(fromFile.bytes) else { return nil }

    let decryptedData = Data(bytes: decrypted)
    
    let decoder = JSONDecoder()
    
    guard let credentials = try? decoder.decode(LoginCredentials.self, from: decryptedData) else { return nil }
    
    return credentials
    
  }
  
  func storeCredentials(accountName:String, password:String) -> Bool {
    
    let credentials = LoginCredentials(accountName: accountName, password:password)
    
    let jsonEncoder = JSONEncoder()
    
    jsonEncoder.outputFormatting = .prettyPrinted
    
    guard let json = try? jsonEncoder.encode(credentials) else { return false }
    
    guard let string = String(data: json, encoding: .utf8) else { return false }
    
    let plaintext = string.bytes
    
    guard let encrypted = try? Blowfish(key: key, blockMode: .CFB(iv: iv), padding: .noPadding).encrypt(plaintext) else { return false }
    
    let data = Data(bytes:encrypted)
    
    guard let folder = try? Folder.current.createSubfolderIfNeeded(withName: ".private") else { return false }
    
    guard let file   = try? folder.createFile(named: "credentials.bytes", contents: data) else { return false }
    
    return true
    
  }
  
}
