import UIKit
import WebKit
import Kingfisher

final class WebViewViewController: UIViewController{
  
  @IBOutlet var backButton: UIButton!
  @IBOutlet var webView: WKWebView!
  @IBOutlet var progressBar: UIProgressView!
  private var estimatedProgressObservation: NSKeyValueObservation?
  
  weak var delegate: WebViewViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    backButton.titleLabel?.text = ""
    loadAuthView()
    webView.navigationDelegate = self
    estimatedProgressObservation = webView.observe(
      \.estimatedProgress,
       options: [],
       changeHandler: { [weak self] _, _ in
         guard let self = self else { return }
         self.updateProgress()
       })
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
  
  @IBAction func didTapBackButton(_ sender: Any) {
    dismiss(animated: true)
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
    if let code = code(from: navigationAction) { 
      delegate?.webViewViewController(self, didAuthenticateWithCode: code)
      decisionHandler(.cancel)
    } else {
      decisionHandler(.allow)
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
