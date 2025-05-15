import Foundation

public protocol ProfileListControllerProtocol: AnyObject{
  var presenter: ProfileListPresenterProtocol? { get set }
  func updateAvatar(with url: String)
  func showLogoutConfirmation()
  func displayProfile(_ profile: Profile)
  
}
