import SwiftUI

struct PhotoInfo: Codable {
    var title: String
    var description: String
    var url: URL
    var copyright: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description = "explanation"
        case url
        case copyright
    }
}

enum PhotoInfoError: Error, LocalizedError {
    case itemNotFound
    case photoDataWasMissing
}
