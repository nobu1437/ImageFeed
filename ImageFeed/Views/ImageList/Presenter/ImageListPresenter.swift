import Foundation

class ImageListPresenter: ImagesListPresenterProtocol {
  weak var view: ImagesListControllerProtocol?
  var photos: [Photo]?
  
  private lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
  }()
  
  func viewDidLoad() {
    NotificationCenter.default.addObserver(
      forName: ImagesListService.didChangeNotification,
      object: nil,
      queue: .main
    ){ [weak self] _ in
      DispatchQueue.main.async{
        self?.view?.updateTableViewAnimated()
      }}
  }
  func didTapLike(_ photo: Photo, completion: @escaping (Result<Photo,Error>) -> Void) {
    ImagesListService.shared.changeLike(photoId: photo.id, isLike:photo.isLiked) {[weak self] result in
      guard let self = self else {
        UIBlockingProgressHUD.dismiss()
        return
      }
      self.photos = ImagesListService.shared.photos
      switch result{
      case .success:
        completion(.success(photo))
        print("Successfully changed button state")
      case . failure(let error):
        completion(.failure(error))
        print("Can't change button state \(error)")
      }
    }
  }
  func loadNextPageIfNeeded(completion: @escaping (Result<[Photo],Error>) -> Void) {
    ImagesListService.shared.fetchPhotosNextPage{[weak self] result in
      guard let self = self else { return }
      switch result {
      case .success:
        print("Successfully loaded next page")
        completion(.success(self.photos ?? []))
      case .failure(let error):
        print("cant load next page \(error)")
      }
    }
  }
  
  func formattedDate(from date: Date?) -> String{
    dateFormatter.string(from: date ?? Date())
  }
}
