import XCTest
@testable import ImageFeed

final class ProfileListTests: XCTestCase {
  func didTapupdateAvatar() {
    // given
    let controller = ProfileLisController()
    
    // when
    controller.updateAvatar(with: "")
    
    // then
    XCTAssertTrue(controller.updateAvatarCalled)
  }

  func didTapShowLogoutConfirmation() {
    // given
    let controller = ProfileLisController()
    
    // when
    controller.showLogoutConfirmation()
    
    // then
    XCTAssertTrue(controller.showLogoutCalles)
  }
  
  func didTapDisplayProfile(){
    // given
    let controller = ProfileLisController()
    
    // when
    controller.displayProfile(Profile(username: "name", name: "name"))
    
    // then
    XCTAssertTrue(controller.displayProfileCalled)
  }
  
  func didTapViewDidLoad(){
    // given
    let presenter = ProfileLisPresenter()
    
    // when
    presenter.viewDidLoad()
    
    // then
    XCTAssertTrue(presenter.viewDidLoadCalled)
  }
}
