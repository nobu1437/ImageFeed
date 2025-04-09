import UIKit

final class ProfileViewController: UIViewController {
  private var nameLabel: UILabel?
  private var nickLabel: UILabel?
  private var descLabel: UILabel?
  private var imageView: UIImageView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    uiSetup()
  }
  
  @objc
  private func didTapButton() {
    nameLabel?.removeFromSuperview()
    nickLabel?.removeFromSuperview()
    descLabel?.removeFromSuperview()
    nameLabel = nil
    nickLabel = nil
    descLabel = nil
    imageView?.image = UIImage(systemName: "person.crop.circle.fill")
  }
  
  func uiSetup(){
    imageViewInit()
    nameLabelInit()
    nickLabelInit()
    descLabelInit()
    buttonInit()
  }
  
  func imageViewInit(){
    let profileImage = UIImage(named: "avatar")
    let imageView = UIImageView(image: profileImage)
    imageView.tintColor = .gray
    imageView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(imageView)
    imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
    imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
    imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    self.imageView = imageView
  }
  func nameLabelInit(){
    let nameLabel = UILabel()
    nameLabel.text = "Екатерина Новикова"
    nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
    nameLabel.textColor = .white
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(nameLabel)
    nameLabel.leadingAnchor.constraint(equalTo: imageView!.leadingAnchor).isActive = true
    nameLabel.topAnchor.constraint(equalTo: imageView!.bottomAnchor, constant: 8).isActive = true
    self.nameLabel = nameLabel
  }
  func nickLabelInit(){
    let nickLabel = UILabel()
    nickLabel.text = "@ekaterina_nov"
    nickLabel.font = .systemFont(ofSize: 13, weight: .regular)
    nickLabel.textColor = .gray
    nickLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(nickLabel)
    nickLabel.leadingAnchor.constraint(equalTo: imageView!.leadingAnchor).isActive = true
    nickLabel.topAnchor.constraint(equalTo: nameLabel!.bottomAnchor, constant: 8).isActive = true
    self.nickLabel = nickLabel
  }
  func descLabelInit(){
    let descLabel = UILabel()
    descLabel.text = "Hello, world!"
    descLabel.font = .systemFont(ofSize: 13, weight: .regular)
    descLabel.textColor = .white
    descLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(descLabel)
    descLabel.leadingAnchor.constraint(equalTo: imageView!.leadingAnchor).isActive = true
    descLabel.topAnchor.constraint(equalTo: nickLabel!.bottomAnchor, constant: 8).isActive = true
    self.descLabel = descLabel
  }
  func buttonInit(){
    let button = UIButton.systemButton(
      with: UIImage(named: "logoutImage")!,
      target: self,
      action: #selector(Self.didTapButton)
    )
    button.tintColor = UIColor(named: "YP Red")
    button.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(button)
    button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
    button.centerYAnchor.constraint(equalTo: imageView!.centerYAnchor).isActive = true
  }
}
