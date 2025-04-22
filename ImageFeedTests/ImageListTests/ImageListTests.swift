import XCTest
@testable import ImageFeed

final class ImageListTests: XCTestCase {
  func testViewControllerCallsViewDidLoad() {
    // given
    let viewController = ImagesListController()
    let presenter = ImagesListPresenter()
    viewController.presenter = presenter
    presenter.view = viewController
    
    // when
    presenter.viewDidLoad()
    
    // then
    XCTAssertTrue(presenter.didCallViewDidLoad)
  }
  
  func testPresenterFormatsDateCorrectly() {
    // given
    let presenter = ImagesListPresenter()
    
    // when
    let formatted = presenter.formattedDate(from: Date())
    
    // then
    XCTAssertFalse(formatted.isEmpty)
  }
  
  func DidTapLike() {
    // given
    let controller = ImagesListController()
    
    // when
    controller.imageListCellDidTapLike(ImagesListCell())
    
    // then
    XCTAssertTrue(controller.didCallImageListCellDidTapLike)
  }
  
  func testDidLoadPage() {
    // given
    let presenter = ImagesListPresenter()
    
    // when
    presenter.loadNextPageIfNeeded{_ in }
    
    // then
    XCTAssertTrue(presenter.didCallLoadNextPage)
  }
}

