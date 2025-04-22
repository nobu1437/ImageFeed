import Foundation

final class OAuth2Service {
  static let shared = OAuth2Service()
  private var lastCode: String?
  private var task: URLSessionTask?
  private init() {}
  
  func fetchOAuthToken(_ code:String,completion: @escaping(Result<String,Error>) -> Void){
    assert(Thread.isMainThread)
    guard lastCode != code else {
      completion(.failure(AuthServiceError.invalidRequest))
      return
    }
    lastCode = code
    task?.cancel()
    switch  makeOAuthTokenRequest(code: code){
    case .success(let request):
      let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
                  guard let self else { return }
        self.lastCode = nil
        switch result {
        case .success(let tokenResponse):
            OAuth2TokenStorage.shared.token = tokenResponse.accessToken
            completion(.success(tokenResponse.accessToken))
            self.task = nil
            self.lastCode = nil
        case .failure(let error):
          completion(.failure(error))
          self.task = nil
          self.lastCode = nil
          print("[OAuth2ServiceError]: Failed to fetch OAuth token\(error)")
        }
      }
      self.task = task
      task.resume()
    case .failure(let error):
      print("[OAuth2ServiceError]: cant create request \(error)")
      completion(.failure(error))
    }
  }
  
  func makeOAuthTokenRequest(code: String) -> Result<URLRequest,UrlError> {
    guard let baseURL = URL(string: "https://unsplash.com") else {
      print("[OAuth2ServiceError]: invalid base URL")
      return .failure(.invalidBaseURL)
    }
    guard let url = URL(
      string: "/oauth/token"
      + "?client_id=\(Constants.accessKey)"
      + "&&client_secret=\(Constants.secretKey)"
      + "&&redirect_uri=\(Constants.redirectURI)"
      + "&&code=\(code)"
      + "&&grant_type=authorization_code",
      relativeTo: baseURL
    ) else{
      print ("[OAuth2ServiceError]: invalid URL")
      return .failure(.invalidURL)
    }
    var request = URLRequest(url: url)
    request.httpMethod = HttpConstants.post.rawValue
    return .success(request)
  }
}
