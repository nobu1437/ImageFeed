import Foundation

protocol ImagesListControllerProtocol: AnyObject {
  func imageListCellDidTapLike(_ cell: ImagesListCell)
  func showError(message: String)
  func updateTableViewAnimated()
  var presenter: ImagesListPresenterProtocol? { get set }
}
