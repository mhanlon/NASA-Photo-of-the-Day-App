import SwiftUI

class PhotoInfoController {
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    func fetchPhotoInfo(for date: Date = Date()) async throws -> PhotoInfo {
        let dateString = dateFormatter.string(from: date)
        let urlString = "https://api.nasa.gov/planetary/apod"
        let url = URL(string: urlString)!
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = [
            "api_key": "DEMO_KEY",
            "date": dateString
        ].map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        let jsonDecoder = JSONDecoder()
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw PhotoInfoError.itemNotFound
        }
        let photoInfo = try jsonDecoder.decode(PhotoInfo.self, from: data)
        return photoInfo
    }
}
