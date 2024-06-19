//
//  NewsAPIResponse.swift
//  News
//
//  Created by Alina Vlasenko on 19.06.2024.
//

import Foundation

// model to fetch data from API
struct NewsAPIResponse: Decodable {
    
    let status: String
    let totalResults: Int?
    let articles: [Article]?
    
    // for error
    // if we have an error the API return us "status", "code", "message"
    // we can handle it
    let code: String?
    let message: String?
}
