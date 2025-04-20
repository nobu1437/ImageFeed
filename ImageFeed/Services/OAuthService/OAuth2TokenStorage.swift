import Foundation
import SwiftKeychainWrapper

public class OAuth2TokenStorage{
  static let shared = OAuth2TokenStorage()
  
  private init(){}
  
  private let storage = KeychainWrapper.standard
  
  var token:String?{
    get{
      storage.string(forKey: "accessToken")
    }
    set{
      guard let value = newValue else {
        assertionFailure("cant store empty token")
        return
      }
       let isSuccess = storage.set(value, forKey: "accessToken")
      guard isSuccess else{
        print("error storing token, removing it")
        storage.removeObject(forKey: "accessToken")
        return
      }
    }
  }
}
