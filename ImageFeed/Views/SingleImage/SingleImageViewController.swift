import UIKit

final class SingleImageViewController: UIViewController {
  
  var index:Int?{
    didSet{
      guard isViewLoaded, let index else { return }
      guard let url = URL(string:ImagesListService.shared.photos[index].largeImageURL) else {return}
      showKfImage(fullImageURL:url)
    }
  }
  
  @IBOutlet private var scrollView: UIScrollView!
  @IBOutlet private var imageView: UIImageView!
  
  override func viewDidLoad() {
    scrollView.delegate = self
    super.viewDidLoad()
    scrollView.minimumZoomScale = 0.1
    scrollView.maximumZoomScale = 1.25
    if let index,
       let url = URL(string: ImagesListService.shared.photos[index].largeImageURL) {
      showKfImage(fullImageURL: url)
    }
  }
  
  @IBAction private func didTapBackButton() {
    dismiss(animated: true, completion: nil)
  }
  func showKfImage(fullImageURL:URL){
    UIBlockingProgressHUD.show()
    imageView.kf.setImage(with: fullImageURL,placeholder: UIImage(named:"placeholder")) { [weak self] result in
      UIBlockingProgressHUD.dismiss()
      
      guard let self = self else { return }
      switch result {
      case .success(let imageResult):
        self.rescaleAndCenterImageInScrollView(image: imageResult.image)
      case .failure:
        self.showError()
      }
    }
  }
  func showError() {
    let alert = UIAlertController(title: "Ошибка",message: "Не удалось загрузить изображение.",preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "Ок", style: .default))
    present(alert, animated: true)
  }
  @IBAction private func didTapShareButton(_ sender: UIButton) {
    let share = UIActivityViewController(
      activityItems: [imageView.image],
      applicationActivities: nil
    )
    present(share, animated: true, completion: nil)
  }
  
  private func rescaleAndCenterImageInScrollView(image: UIImage) {
    let minZoomScale = scrollView.minimumZoomScale
    let maxZoomScale = scrollView.maximumZoomScale
    view.layoutIfNeeded()
    let visibleRectSize = scrollView.bounds.size
    let imageSize = image.size
    let hScale = visibleRectSize.width / imageSize.width
    let vScale = visibleRectSize.height / imageSize.height
    let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
    self.imageView.frame.size = imageSize
    scrollView.setZoomScale(scale, animated: false)
    scrollView.layoutIfNeeded()
    let newContentSize = scrollView.contentSize
    let x = (newContentSize.width - visibleRectSize.width) / 2
    let y = (newContentSize.height - visibleRectSize.height) / 2
    scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    
    
  }
}

extension SingleImageViewController: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    imageView
  }
}
