import UIKit

final class ImagesListCell: UITableViewCell {
  static let reuseIdentifier = "ImagesListCell"
  @IBOutlet var cellImage: UIImageView!
  @IBOutlet var likeButton: UIButton!
  @IBOutlet var dateLabel: UILabel!
  
  weak var delegate:ImagesListCellDelegate?
  override func prepareForReuse() {
    super.prepareForReuse()
    cellImage.kf.cancelDownloadTask()
  }
  @IBAction private func likeButtonClicked(_ sender:UIButton) {
    delegate?.imageListCellDidTapLike(self)
  }

}

