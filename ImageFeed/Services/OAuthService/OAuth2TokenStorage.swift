import Foundation
import SwiftKeychainWrapper

public class OAuth2TokenStorage{
  static let shared = OAuth2TokenStorage()
  private let tokenKey = "accessToken"
  private init(){}
  
  private let storage = KeychainWrapper.standard
  
  var token:String?{
    get{
      storage.string(forKey: tokenKey)
    }
    set{
      guard let value = newValue else {
        assertionFailure("cant store empty token")
        return
      }
       let isSuccess = storage.set(value, forKey: tokenKey)
      guard isSuccess else{
        print("error storing token, removing it")
        storage.removeObject(forKey: tokenKey)
        return
      }
    }
  }
}
