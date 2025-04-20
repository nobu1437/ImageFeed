import Foundation
struct UserResult: Codable {
    let profileImage: ProfileImage

    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Codable {
    let small: String
}

final class ProfileImageService{
  static let shared = ProfileImageService()
  static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
  private var task: URLSessionTask?
  private(set) var avatarURL: String?
  private let token = OAuth2TokenStorage.shared.token ?? ""
  
  private init(){}
  enum CodingKeys:String, CodingKey{
    case avatarURL = "profile_Image"
  }
  
  func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void){
    assert(Thread.isMainThread)
    task?.cancel()
    guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {
      print("Profile Image Error: wrong URL")
      completion(.failure(ProfileError.invalidURL))
      return
    }
    print(url)
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
      guard let self = self else { return }
      switch result {
      case .success(let userResult):
        print("profile image fetched successfully")
        let image = userResult.profileImage.small
        self.avatarURL = image
        completion(.success(image))
        NotificationCenter.default                                     // 1
          .post(                                                     // 2
            name: ProfileImageService.didChangeNotification,       // 3
            object: self,                                          // 4
            userInfo: ["URL": self.avatarURL])
        print("post")
      case .failure(let error):
        print(error.localizedDescription)
        completion(.failure(error))
      }
    }
    self.task = task
    task.resume()
  }
}
