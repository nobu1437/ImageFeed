import Foundation

public protocol ProfileListPresenterProtocol{
  var view: ProfileListControllerProtocol? { get set }
  func viewDidLoad()
}
