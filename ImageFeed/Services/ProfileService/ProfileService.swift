import Foundation

struct ProfileResult:Codable{
  let username:String
  let firstName:String
  let lastName:String
  let bio:String?
  
  enum CodingKeys:String, CodingKey{
    case username,bio
    case firstName = "first_name"
    case lastName = "last_name"
  }
}

final class ProfileService{
  
  static let shared = ProfileService()
  private(set) var profile: Profile?
  private init(){}
  private var task: URLSessionTask?
  
  func getProfile(token:String,completion: @escaping (Result<Profile, Error>) -> Void) {
    assert(Thread.isMainThread)
    task?.cancel()
    guard let url = URL(string: "https://api.unsplash.com/me") else {
      print("Profile Error: wrong URL")
      completion(.failure(ProfileError.invalidURL))
      return
    }
    var request = URLRequest(url: url)
    request.httpMethod = HttpConstants.get.rawValue
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
        guard let self = self else { return }
      switch result {
      case .success(let profileResult):
        print("profile data fetched successfully")
        let profile = Profile(
          username: "@\(profileResult.username)",
          name: "\(profileResult.firstName) \(profileResult.lastName)",
          bio: profileResult.bio
        )
        self.profile = profile
        ProfileImageService.shared.fetchProfileImageURL(username: profileResult.username) { result in
          switch result{
          case .success(_):
            print("successfully decoded image URl")
          case .failure(let error):
            print("[ProfileService Error]: can't decode image URL \(error)")
          }}
        completion(.success(profile))
      case .failure(let error):
        print("[ProfileService Error]: can't fetch profile data \(error)")
        completion(.failure(error))
      }
    }
    self.task = task
    task.resume()
  }
  func profileDelete(){
    self.profile = nil
  }
}
