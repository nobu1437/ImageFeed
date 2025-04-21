import Foundation
import WebKit

final class ProfileLogoutService {
  static let shared = ProfileLogoutService()
  
  private init() { }
  
  func logout() {
    cleanCookies()
    ProfileService.shared.profileDelete()
    ImagesListService.shared.photosDelete()
    ProfileImageService.shared.avatarURLDelete()
    OAuth2TokenStorage.shared.tokenDelete()
    presentAuthController()
  }
}

extension ProfileLogoutService {
  private func cleanCookies() {
    HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
    WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
      records.forEach { record in
        WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
      }
    }
  }
  func presentAuthController(){
    guard let window = UIApplication.shared.windows.first else {
      assertionFailure("No windows found")
      return
    }
    let storyboard = UIStoryboard(name: "Main", bundle: .main)
    guard let authVC = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
      assertionFailure("AuthViewController not found in storyboard")
      return
    }
    
    window.rootViewController = authVC
    window.makeKeyAndVisible()
  }
}
