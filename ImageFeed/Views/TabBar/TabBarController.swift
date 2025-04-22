import UIKit

final class TabBarController: UITabBarController {
  override func awakeFromNib() {
    super.awakeFromNib()
    let storyboard = UIStoryboard(name: "Main", bundle: .main)
   guard let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController
    else { fatalError("Failed to prepare for instantiate view controller") }
    let imagesListPresenter = ImageListPresenter()
    imagesListViewController.presenter = imagesListPresenter
    imagesListPresenter.view = imagesListViewController
    let profileViewController = ProfileViewController()
    let profilePresenter = ProfileListPresenter()
    profileViewController.presenter = profilePresenter
    profilePresenter.view = profileViewController
    
    profileViewController.tabBarItem = UITabBarItem(
      title: "",
      image: UIImage(systemName: "person.circle.fill"),
      selectedImage: nil
    )
    self.viewControllers = [imagesListViewController, profileViewController]
  }
}
