import UIKit


final class AuthViewController: UIViewController {
  private let showWebViewSegueIdentifier = "ShowWebView"
  
  weak var delegate: AuthViewControllerDelegate?
  override func viewDidLoad() {
    super.viewDidLoad()
    configureBackButton()
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == showWebViewSegueIdentifier {
      guard
        let webViewViewController = segue.destination as? WebViewViewController
      else { fatalError("Failed to prepare for \(showWebViewSegueIdentifier)") }
      webViewViewController.delegate = self
    } else {
      super.prepare(for: segue, sender: sender)
    }
  }
  private func configureBackButton() {
    navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
    navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black")
  }
}

extension AuthViewController: WebViewViewControllerDelegate {
  func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
    delegate?.authViewController(self, didAuthenticateWithCode: code)
  }
  
  func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
    dismiss(animated: true)
  }
}
