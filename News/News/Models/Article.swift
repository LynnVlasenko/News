//
//  Article.swift
//  News
//
//  Created by Alina Vlasenko on 19.06.2024.
//

import Foundation

// to format the date
fileprivate let relativeDateFormatter = RelativeDateTimeFormatter()

struct Article: Codable, Equatable, Identifiable {
    
    // create id as UUID - The API does not provide ids
    var id = UUID()
    
    let source: Source
    
    let title: String
    let url: String
    let publishedAt: Date // iso8601 format
    
    let author: String?
    let description: String?
    let urlToImage: String?
    
    enum CodingKeys: String, CodingKey {
            case source
            case title
            case url
            case publishedAt
            case author
            case description
            case urlToImage
        }
    
    // unwrap the optionals
    var authorText: String {
        author ?? ""
    }
    
    var descriptionText: String {
        description ?? ""
    }
    
    // to show the article source and how long ago it was published, using RelativeDateTimeFormatter and localizedString method
    var captionText: String {
        "\(source.name) ・ \(relativeDateFormatter.localizedString(for: publishedAt, relativeTo: Date()))"
    }
    
    // to grab the URL type for article link
    var articleURL: URL {
        URL(string: url)! // force unwrap because we have all links in API
    }
    
    var imageURL: URL? {
        guard let urlToImage = urlToImage else {
            return nil
        }
        return URL(string: urlToImage)
    }
}

struct Source: Codable, Equatable {
    let name: String
}

// to show the mock data on the canvas 
extension Article {
    
    // for the preview data (this is the stops) - aareay of articles
    static var previewData: [Article] {
        // get the Url for JSON in our Bundle
        let previewDataURL =
        Bundle.main.url(forResource: "news", withExtension: "json")!
        let data = try! Data(contentsOf: previewDataURL)
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601 // to resave data to Swift format
        
        //api response to get data from API
        let apiResponse = try! jsonDecoder.decode(NewsAPIResponse.self, from: data)
        return apiResponse.articles ?? []
    }
}
