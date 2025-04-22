import ImageFeed
import Foundation

class WebViewViewControllerSpy:WebViewViewControllerProtocol{
  var loadIsLoaded = false
  var presenter: (any ImageFeed.WebViewPresenterProtocol)?
  
  func load(request: URLRequest) {
    loadIsLoaded = true
  }
  
  func setProgressValue(_ newValue: Float) {
  }
  
  func setProgressHidden(_ isHidden: Bool) {
  }
}
