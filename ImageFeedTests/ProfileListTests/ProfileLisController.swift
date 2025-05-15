import XCTest
@testable import ImageFeed

final class ProfileLisController:ProfileListControllerProtocol{
  var presenter: ProfileListPresenterProtocol?
  var updateAvatarCalled = false
  var showLogoutCalles = false
  var displayProfileCalled = false
  
  func updateAvatar(with url: String) {
    updateAvatarCalled = true
  }
  
  func showLogoutConfirmation() {
    showLogoutCalles = true
  }
  
  func displayProfile(_ profile: ImageFeed.Profile) {
    displayProfileCalled = true
  }
}
