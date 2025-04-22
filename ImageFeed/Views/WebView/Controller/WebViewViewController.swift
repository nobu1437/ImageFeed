import UIKit
import WebKit
import Kingfisher

final class WebViewViewController: UIViewController, WebViewViewControllerProtocol{
  
  @IBOutlet var backButton: UIButton!
  @IBOutlet var webView: WKWebView!
  @IBOutlet var progressBar: UIProgressView!
  private var estimatedProgressObservation: NSKeyValueObservation?
  var presenter: WebViewPresenterProtocol?
  
  weak var delegate: WebViewViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    webView.accessibilityIdentifier = "UnsplashWebView"
    backButton.titleLabel?.text = ""
    presenter?.viewDidLoad()
    webView.navigationDelegate = self
    estimatedProgressObservation = webView.observe(
      \.estimatedProgress,
       options: [],
       changeHandler: { [weak self] _, _ in
         guard let self = self else { return }
         presenter?.didUpdateProgressValue(webView.estimatedProgress)
       })
  }
  
  func load(request: URLRequest) {
      webView.load(request)
  }
  @IBAction private func didTapBackButton(_ sender: Any) {
    dismiss(animated: true)
  }
  
  func setProgressValue(_ newValue: Float) {
    progressBar.progress = newValue
  }

  func setProgressHidden(_ isHidden: Bool) {
    progressBar.isHidden = isHidden
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
      if let url = navigationAction.request.url {
          return presenter?.code(from: url)
      }
      return nil
  }
}
