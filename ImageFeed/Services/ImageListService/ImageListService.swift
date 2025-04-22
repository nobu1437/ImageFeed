import Foundation

final class ImagesListService {
  private(set) var photos: [Photo] = []
  static let shared = ImagesListService()
  static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
  private var task: URLSessionTask?
  private let token = OAuth2TokenStorage.shared.token ?? ""
  private var lastLoadedPage: Int?
  private static let dateFormatter: ISO8601DateFormatter = {
     ISO8601DateFormatter()
  }()
  private init(){}
  
  func fetchPhotosNextPage(_ completion: @escaping (Result<[Photo],Error>) -> Void) {
    assert(Thread.isMainThread)
    task?.cancel()
    let nextPage = (lastLoadedPage ?? 0) + 1
    guard let url = URL(string: "https://api.unsplash.com/photos?page=\(nextPage)&per_page=10") else {
      print("[ImagesListService Error]: wrong URL")
      completion(.failure(UrlError.invalidURL))
      return
    }
    print(url)
    var request = URLRequest(url: url)
    request.httpMethod = HttpConstants.get.rawValue
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
      guard let self = self else { return }
      switch result {
      case .success(let photoResult):
        print("fetched \(photoResult.count) photos")
        for item in photoResult {
          let photo = Photo(
            id: item.id,
            size: CGSize(width: item.width, height: item.height),
            createdAt:
              ImagesListService.dateFormatter.date(from: item.createdAt),
            welcomeDescription: item.description,
            thumbImageURL: item.urls.thumb,
            largeImageURL: item.urls.full,
            isLiked: item.isLiked
          )
          self.photos.append(photo)
        }
        self.lastLoadedPage = nextPage
        NotificationCenter.default
          .post(
            name: ImagesListService.didChangeNotification,
            object: self,
            userInfo: ["photos": self.photos])
        completion(.success(self.photos))
      case .failure(let error):
        print("[ImagesListService Error]:failed to fetch photos \(error)")
        completion(.failure(error))
      }
    }
    self.task = task
    task.resume()
  }
  func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void){
    assert(Thread.isMainThread)
    task?.cancel()
    guard let url = URL(string:"https://api.unsplash.com/photos/\(photoId)/like" ) else {return}
    var request = URLRequest(url: url)
    request.httpMethod = isLike ? HttpConstants.post.rawValue : HttpConstants.delete.rawValue
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    let task = URLSession.shared.objectTask(for: request) {[weak self] (result:Result<LikePhotoResult,Error>) in
      guard let self = self else { return }
      switch result {
      case .success:
        if let index = self.photos.firstIndex(where: {$0.id == photoId}){
          let photo = self.photos[index]
          let newPhoto = Photo(id: photo.id,
                               size: photo.size,
                               createdAt: photo.createdAt,
                               welcomeDescription: photo.welcomeDescription,
                               thumbImageURL: photo.thumbImageURL,
                               largeImageURL: photo.largeImageURL,
                               isLiked: !photo.isLiked)
          
          
          self.photos[index] = newPhoto
          completion(.success(()))
        }
      case .failure(let error):
        print("[ImageListService Error] cant change like \(error)")
        completion(.failure(error))
      }
    }
    task.resume()
  }
  func photosDelete(){
    photos.removeAll()
  }
}
