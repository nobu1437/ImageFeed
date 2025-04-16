import UIKit
import WebKit

final class WebViewViewController: UIViewController{
  
  @IBOutlet var webView: WKWebView!
  @IBOutlet var progressBar: UIProgressView!
  
  weak var delegate: WebViewViewControllerDelegate?
  override func viewWillAppear(_ animated: Bool) {
    webView.addObserver(
      self,
      forKeyPath: #keyPath(WKWebView.estimatedProgress),
      options: .new,
      context: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadAuthView()
    webView.navigationDelegate = self
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    webView.removeObserver(self, forKeyPath:
                            #keyPath(WKWebView.estimatedProgress), context: nil)
  }
  
  private func loadAuthView() {
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
    webView.load(request)
  }
  
  
  
  override func addObserver(
    _ observer: NSObject,
    forKeyPath keyPath: String,
    options: NSKeyValueObservingOptions = [],
    context: UnsafeMutableRawPointer?) {}
  
  override func observeValue(
    forKeyPath keyPath: String?,
    of object: Any?,
    change: [NSKeyValueChangeKey : Any]?,
    context: UnsafeMutableRawPointer?
  ) {
    if keyPath == #keyPath(WKWebView.estimatedProgress) {
      updateProgress()
    } else {
      super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
    }
  }
  
  private func updateProgress() {
    progressBar.progress = Float(webView.estimatedProgress)
    progressBar.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
  }
  
}
extension WebViewViewController: WKNavigationDelegate{
  func webView(
    _ webView: WKWebView,
    decidePolicyFor navigationAction: WKNavigationAction,
    decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
  ) {
    if let code = code(from: navigationAction) { //1
      //TODO: process code                     //2
      decisionHandler(.cancel) //3
    } else {
      decisionHandler(.allow) //4
    }
  }
  private func code(from navigationAction: WKNavigationAction) -> String? {
    if
      let url = navigationAction.request.url,                         
        let urlComponents = URLComponents(string: url.absoluteString),
      urlComponents.path == "/oauth/authorize/native",
      let items = urlComponents.queryItems,
      let codeItem = items.first(where: { $0.name == "code" })
    {
      return codeItem.value
    } else {
      return nil
    }
  }
}
