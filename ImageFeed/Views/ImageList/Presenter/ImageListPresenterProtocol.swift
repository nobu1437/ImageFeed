import Foundation

protocol ImagesListPresenterProtocol {
  func viewDidLoad()
  func didTapLike(_ photo: Photo, completion: @escaping (Result<Photo,Error>) -> Void)
  func loadNextPageIfNeeded(completion: @escaping (Result<[Photo],Error>) -> Void)
  func formattedDate(from date: Date?) -> String
  var view: ImagesListControllerProtocol? { get set }
}
