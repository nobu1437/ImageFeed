import Foundation

public class OAuth2TokenStorage{
  static let shared = OAuth2TokenStorage()
  
  private init(){}
  
  private let storage = UserDefaults.standard
  
  var token:String?{
    get{
      storage.string(forKey: "accessToken")
    }
    set{
      storage.set(newValue, forKey: "accessToken")
    }
  }
}
