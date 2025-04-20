import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
  private var nameLabel: UILabel?
  private var nickLabel: UILabel?
  private var descLabel: UILabel?
  private var imageView: UIImageView?
  private var profileImageServiceObserver: NSObjectProtocol?
  private var imageLink: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("init")
    view.backgroundColor = UIColor(named: "YP Black")
    profileImageServiceObserver = NotificationCenter.default    // 2
      .addObserver(
        forName: ProfileImageService.didChangeNotification, // 3
        object: nil,                                        // 4
        queue: .main                                        // 5
      ) { [weak self] _ in
        guard let self = self else { return }
        guard let imageLink = ProfileImageService.shared.avatarURL else { return }
        print(imageLink)
        self.imageLink = imageLink
        self.updateAvatar(imageLink:imageLink)                                 // 6
      }
    guard let profile = ProfileService.shared.profile else { return }
    self.uiSetup(profile: profile)
    if let imageLink = ProfileImageService.shared.avatarURL {
      updateAvatar(imageLink: imageLink)
    }
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
  
  func uiSetup(profile:Profile){
    imageViewInit()
    nameLabelInit(name:profile.name)
    nickLabelInit(nick:profile.username)
    descLabelInit(bio:profile.bio)
    buttonInit()
    addSubviews()
  }
  
  private func updateAvatar(imageLink: String) {
    guard let imageView = imageView else {
      print ("imageView is not initialized")
      return }
    let processor = RoundCornerImageProcessor(cornerRadius: 100)
    imageView.kf.setImage(with: URL(string: imageLink),options:[.processor(processor)] )
    print("done")
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
  private func nameLabelInit(name:String){
    let nameLabel = UILabel()
    nameLabel.text = name
    nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
    nameLabel.textColor = .white
    view.addSubview(nameLabel)
    nameLabel.leadingAnchor.constraint(equalTo: imageView!.leadingAnchor).isActive = true
    nameLabel.topAnchor.constraint(equalTo: imageView!.bottomAnchor, constant: 8).isActive = true
    self.nameLabel = nameLabel
  }
  private func nickLabelInit(nick:String){
    let nickLabel = UILabel()
    nickLabel.text = nick
    nickLabel.font = .systemFont(ofSize: 13, weight: .regular)
    nickLabel.textColor = .gray
    view.addSubview(nickLabel)
    nickLabel.leadingAnchor.constraint(equalTo: imageView!.leadingAnchor).isActive = true
    nickLabel.topAnchor.constraint(equalTo: nameLabel!.bottomAnchor, constant: 8).isActive = true
    self.nickLabel = nickLabel
  }
  private func descLabelInit(bio:String?){
    let descLabel = UILabel()
    if let bio = bio{
      descLabel.text = bio
    } else{
      descLabel.text = "default description"
    }
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
