import Foundation

struct PhotoResult:Codable{
  let id: String
  let createdAt: String
  let width: Int
  let height: Int
  let description: String?
  let urls: Urls
  let isLiked: Bool
  
  struct Urls:Codable{
    let thumb:String
    let full:String
  }
  enum CodingKeys:String,CodingKey{
    case id, description, urls,width, height
    case createdAt = "created_at"
    case isLiked = "liked_by_user"
  }
}
struct LikePhotoResult: Codable {
  let photo: PhotoResult
}
