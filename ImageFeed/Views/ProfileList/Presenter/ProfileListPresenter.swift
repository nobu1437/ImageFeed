import Foundation

class ProfileListPresenter:ProfileListPresenterProtocol{
  weak var view: ProfileListControllerProtocol?
  
  func viewDidLoad() {
    guard let profile = ProfileService.shared.profile else { return }
    view?.displayProfile(profile)
    if let url = ProfileImageService.shared.avatarURL {
      view?.updateAvatar(with: url)
    }
    
    NotificationCenter.default.addObserver(
      forName: ProfileImageService.didChangeNotification,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      guard let url = ProfileImageService.shared.avatarURL else { return }
      self?.view?.updateAvatar(with: url)
    }
  }
  
}
