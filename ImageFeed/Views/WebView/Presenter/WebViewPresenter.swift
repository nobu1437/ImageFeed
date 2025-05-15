import Foundation

final class WebViewPresenter: WebViewPresenterProtocol{
  weak var view: WebViewViewControllerProtocol?
  var authHelper: AuthHelperProtocol
  
  init(authHelper: AuthHelperProtocol) {
    self.authHelper = authHelper
  }
  
  func viewDidLoad() {
    guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
      return
    }
    urlComponents.queryItems = [
      URLQueryItem(name: "client_id", value: Constants.accessKey),
      URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
      URLQueryItem(name: "response_type", value: "code"),
      URLQueryItem(name: "scope", value: Constants.accessScope)
    ]
    
    guard let url = urlComponents.url else {
      return
    }
    let request = URLRequest(url: url)
    guard let request = authHelper.authRequest() else { return }
    didUpdateProgressValue(0)
    view?.load(request: request)
  }
  
  func didUpdateProgressValue(_ newValue: Double) {
    let newProgressValue = Float(newValue)
    view?.setProgressValue(newProgressValue)
    
    let shouldHideProgress = shouldHideProgress(for: newProgressValue)
    view?.setProgressHidden(shouldHideProgress)
  }
  
  func shouldHideProgress(for value: Float) -> Bool {
    abs(value - 1.0) <= 0.0001
  }
  
  func code(from url: URL) -> String? {
    authHelper.code(from: url)
  }
}
