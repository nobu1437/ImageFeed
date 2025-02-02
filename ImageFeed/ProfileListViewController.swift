import UIKit

final class ProfileListViewController: UIViewController{
    
    @IBOutlet var logOutButton: UIButton!
    @IBOutlet var userFullName: UILabel!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userDescription: UILabel!
    @IBOutlet var userImage: UIImageView!
    
    
    @IBAction func didTapLogOutButton(_ sender: Any) {
        print("tapped")
    }
}
