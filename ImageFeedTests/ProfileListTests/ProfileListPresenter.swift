import XCTest
@testable import ImageFeed

class ProfileLisPresenter:ProfileListPresenterProtocol {
  weak var view: ProfileListControllerProtocol?
  var  viewDidLoadCalled = false
  func viewDidLoad(){
    viewDidLoadCalled = true
  }
}
