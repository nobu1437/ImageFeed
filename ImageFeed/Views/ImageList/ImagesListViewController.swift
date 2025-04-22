import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
  private let showSingleImageSegueIdentifier = "ShowSingleImage"
  private var photos: [Photo] = []
  

  @IBOutlet private var tableView: UITableView!
  
  private lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(
      forName: ImagesListService.didChangeNotification,
      object: nil,
      queue: .main
    ){ [weak self] _ in
      DispatchQueue.main.async{
        self?.updateTableViewAnimated()
      }}
    
    tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    ImagesListService.shared.fetchPhotosNextPage { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let photos):
        self.photos = photos
        self.tableView.reloadData()
      case .failure(let error):
        print("Error: \(error)")
      }
    }
  }
  func presentErrorAlert(message:String){
    let alert = UIAlertController(title: "Что-то пошло не так", message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "ok", style: .default)
    alert.addAction(action)
    present(alert,animated: true,completion: nil)
  }
  
  func updateTableViewAnimated() {
    let oldCount = self.photos.count
    let newCount = ImagesListService.shared.photos.count
    
    if oldCount != newCount {
      self.photos = ImagesListService.shared.photos
      tableView.performBatchUpdates {
        let indexPaths = (oldCount..<newCount).map { i in
          IndexPath(row: i, section: 0)
        }
        tableView.insertRows(at: indexPaths, with: .automatic)
      }
    }
  }
  
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     guard segue.identifier == showSingleImageSegueIdentifier,
           let viewController = segue.destination as? SingleImageViewController,
           let indexPath = sender as? IndexPath else {
       super.prepare(for: segue, sender: sender)
       return
     }
     viewController.index = indexPath.row
   }
 }

extension ImagesListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return photos.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
    guard let imageListCell = cell as? ImagesListCell else { return UITableViewCell() }
    configCell(for: imageListCell, with: indexPath)
    imageListCell.delegate = self
    return imageListCell
  }
}

extension ImagesListViewController {
  func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
    cell.cellImage.isUserInteractionEnabled = false
    cell.cellImage.kf.indicatorType = .activity
    cell.delegate = self
    let urlString = photos[indexPath.row].thumbImageURL
    guard let url = URL(string: urlString) else {
      print("Invalid URL string: \(urlString)")
      return
    }
    cell.dateLabel.text = dateFormatter.string(from: photos[indexPath.row].createdAt ?? Date())
    let isLiked = photos[indexPath.row].isLiked
    let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
    cell.likeButton.setImage(likeImage, for: .normal)
    
    cell.cellImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder")) { result in
      switch result {
      case .success:
        DispatchQueue.main.async {
          cell.cellImage.isUserInteractionEnabled = true
        }
      case .failure(let error):
        print("Error loading image: \(error.localizedDescription)")
      }
    }
  }
}

extension ImagesListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
    let imageWidth = photos[indexPath.row].size.width
    let scale = imageViewWidth / imageWidth
    let cellHeight = photos[indexPath.row].size.height * scale + imageInsets.top + imageInsets.bottom
    return cellHeight
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == photos.count - 1 {
      ImagesListService.shared.fetchPhotosNextPage {[weak self] result in
        guard let self = self else { return }
        switch result {
        case .success:
          self.updateTableViewAnimated()
        case .failure(let error):
          print("Error: \(error)")
        }
      }
    }
  }
}
extension ImagesListViewController: ImagesListCellDelegate {
  func imageListCellDidTapLike(_ cell: ImagesListCell) {
    UIBlockingProgressHUD.show()
    guard let indexPath = tableView.indexPath(for: cell) else {
      UIBlockingProgressHUD.dismiss()
      return
    }
    let photo = photos[indexPath.row]
    ImagesListService.shared.changeLike(photoId: photo.id, isLike:photo.isLiked) {[weak self] result in
      guard let self = self else {
        UIBlockingProgressHUD.dismiss()
        return
      }
      switch result{
      case .success():
        self.photos = ImagesListService.shared.photos
        let updatedPhoto = self.photos[indexPath.row]
        let isLiked = updatedPhoto.isLiked
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        cell.likeButton.setImage(likeImage, for: .normal)
        UIBlockingProgressHUD.dismiss()
      case . failure(let error):
        let message = "Can't change button state \(error)"
        self.presentErrorAlert(message: message)
        UIBlockingProgressHUD.dismiss()
      }
    }
  }
}
