import UIKit

final class SplashViewController: UIViewController {
  private var imageView: UIImageView?
  private let oauth2Service = OAuth2Service.shared
  private let storage = OAuth2TokenStorage.shared
  let alert = UIAlertController(title: "Что-то пошло не так", message: "Не удалось войти в систему", preferredStyle: .alert)
  let action = UIAlertAction(title: "ok", style: .default)
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    alert.addAction(action)
    if let token = storage.token{
      switchToTabBarController()
      fetchProfile(token: token)
    } else {
      presentAuthController()
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setNeedsStatusBarAppearanceUpdate()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    .lightContent
  }
  
  private func setupUI(){
    view.backgroundColor = UIColor(named: "YP Black")
    let image = UIImage(named: "unsplash_logo")
    let imageView = UIImageView(image: image)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(imageView)
    NSLayoutConstraint.activate([
      imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    self.imageView = imageView
  }
  
  private func switchToTabBarController() {
    guard let window = UIApplication.shared.windows.first else {
      assertionFailure("Invalid Configuration")
      return
    }
    let tabBarController = UIStoryboard(name: "Main", bundle: .main)
      .instantiateViewController(withIdentifier: "TabBarViewController")
    window.rootViewController = tabBarController
  }
}

extension SplashViewController {
  func presentAuthController(){
    let storyboard = UIStoryboard(name: "Main", bundle: .main)
    if let viewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController{
      viewController.delegate = self
      viewController.modalPresentationStyle = .fullScreen
      present(viewController, animated: true)
    }
    else{
      assertionFailure("No controllers with this identifier")
    }
  }
}

extension SplashViewController: AuthViewControllerDelegate {
  func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
    dismiss(animated: true) { [weak self] in
      UIBlockingProgressHUD.show()
      guard let self = self else { return }
      self.fetchOAuthToken(code)
      guard let token = storage.token else { return }
      fetchProfile(token: token)
    }
  }
  private func fetchProfile(token:String){
    ProfileService.shared.getProfile(token: token) { [weak self] result in
      UIBlockingProgressHUD.dismiss()
      guard let self = self else { return }
      switch result {
      case .success(_):
        self.switchToTabBarController()
      case .failure(let error):
        print("Profile error: Can't get profile parameters \(error.localizedDescription)")
      }
    }
  }
  
  private func fetchOAuthToken(_ code: String) {
    dismiss(animated: true)
    oauth2Service.fetchOAuthToken(code) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success:
        print("token fetched successfully")
      case .failure:
        present(alert, animated: true, completion: nil)
        break
      }
    }
  }
}
