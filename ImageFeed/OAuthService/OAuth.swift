import Foundation

final class OAuth2Service {
  static let shared = OAuth2Service()
  private init() {}
  
  func makeOAuthTokenRequest(code: String) -> URLRequest {
    let baseURL = URL(string: "https://unsplash.com") ?? Constants.defaultBaseURL
    let url = URL(
      string: "/oauth/token"
      + "?client_id=\(Constants.accessKey)"        
      + "&&client_secret=\(Constants.secretKey)"
      + "&&redirect_uri=\(Constants.redirectURI)"
      + "&&code=\(code)"
      + "&&grant_type=authorization_code",
      relativeTo: baseURL
    ) ?? Constants.defaultBaseURL
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    return request
  }
  
  func fetchOAuthToken(_ code:String,completion: @escaping(Result<String,Error>) -> Void){
    let request = makeOAuthTokenRequest(code: code)
    let task = URLSession.shared.data(for: request) { result in
      switch result {
      case .success(let data):
        do {
          let tokenResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
          OAuth2TokenStorage.shared.token = tokenResponse.accessToken
          completion(.success(tokenResponse.accessToken))
        } catch {
          completion(.failure(error))
          print("Failed to decode OAuth Token")
        }
      case .failure(let error):
        completion(.failure(error))
        print("Failed to fetch OAuth token")
      }
    }
    task.resume()
  }
}
