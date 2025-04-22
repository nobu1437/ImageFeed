import XCTest
@testable import ImageFeed

final class ImagesListPresenter: ImagesListPresenterProtocol {
  var didCallViewDidLoad = false
  var didTapLikeCalled = false
  var didCallLoadNextPage = false
  var presenterDate = ""
  private lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
  }()
  func viewDidLoad() {
    didCallViewDidLoad = true
  }
  
  func didTapLike(_ photo: ImageFeed.Photo, completion: @escaping (Result<ImageFeed.Photo, any Error>) -> Void) {
    didTapLikeCalled = true
  }
  
  func loadNextPageIfNeeded(completion: @escaping (Result<[ImageFeed.Photo], any Error>) -> Void) {
    didCallLoadNextPage = true
  }
  
  func formattedDate(from date: Date?) -> String {
     presenterDate = dateFormatter.string(from: date ?? Date())
    return presenterDate
  }
  
  weak var view: ImagesListControllerProtocol?
  
  
}
