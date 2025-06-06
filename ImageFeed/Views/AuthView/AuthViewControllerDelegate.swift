import Foundation

protocol AuthViewControllerDelegate: AnyObject {
  func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

