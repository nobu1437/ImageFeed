import XCTest
@testable import ImageFeed

final class ImagesListController: ImagesListControllerProtocol {
  var didCallUpdateTableView = false
  var didCallShowError = true
  var didCallImageListCellDidTapLike = false
  func imageListCellDidTapLike(_ cell: ImageFeed.ImagesListCell) {
    didCallImageListCellDidTapLike = true
  }
  
  func showError(message: String) {
    didCallShowError = true
  }
  
  func updateTableViewAnimated() {
    didCallUpdateTableView = true
  }
  var presenter: (any ImageFeed.ImagesListPresenterProtocol)?
}
