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
    addSubviews()
  }
  
  private func addSubviews() {
    [nameLabel, nickLabel, descLabel, imageView].forEach {
      $0!.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0!)
    }
  }
  
  private func imageViewInit(){
    let profileImage = UIImage(named: "avatar")
    let imageView = UIImageView(image: profileImage)
    imageView.tintColor = .gray
    view.addSubview(imageView)
    imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
    imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
    imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    self.imageView = imageView
  }
  private func nameLabelInit(){
    let nameLabel = UILabel()
    nameLabel.text = "Екатерина Новикова"
    nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
    nameLabel.textColor = .white
    view.addSubview(nameLabel)
    nameLabel.leadingAnchor.constraint(equalTo: imageView!.leadingAnchor).isActive = true
    nameLabel.topAnchor.constraint(equalTo: imageView!.bottomAnchor, constant: 8).isActive = true
    self.nameLabel = nameLabel
  }
  private func nickLabelInit(){
    let nickLabel = UILabel()
    nickLabel.text = "@ekaterina_nov"
    nickLabel.font = .systemFont(ofSize: 13, weight: .regular)
    nickLabel.textColor = .gray
    view.addSubview(nickLabel)
    nickLabel.leadingAnchor.constraint(equalTo: imageView!.leadingAnchor).isActive = true
    nickLabel.topAnchor.constraint(equalTo: nameLabel!.bottomAnchor, constant: 8).isActive = true
    self.nickLabel = nickLabel
  }
  private func descLabelInit(){
    let descLabel = UILabel()
    descLabel.text = "Hello, world!"
    descLabel.font = .systemFont(ofSize: 13, weight: .regular)
    descLabel.textColor = .white
    view.addSubview(descLabel)
    descLabel.leadingAnchor.constraint(equalTo: imageView!.leadingAnchor).isActive = true
    descLabel.topAnchor.constraint(equalTo: nickLabel!.bottomAnchor, constant: 8).isActive = true
    self.descLabel = descLabel
  }
  private func buttonInit(){
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
