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
    
    // create id as a unique url
    var id: String { url }
    
    let source: Source
    
    let title: String
    let url: String
    let publishedAt: Date // iso8601 format
    
    let author: String?
    let description: String?
    let urlToImage: String?
    
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
