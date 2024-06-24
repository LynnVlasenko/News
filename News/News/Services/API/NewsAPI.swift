//
//  NewsAPI.swift
//  News
//
//  Created by Alina Vlasenko on 19.06.2024.
//

import Foundation

struct NewsAPI {
    
    static let shared = NewsAPI()
    
    private init() {}
    
    private let apiKey = "6088cdf5cc8744bb8331f36ebfa760c4"
    private let session = URLSession.shared
    
    // configuration for JSONDecoder
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601 // to convert date from iso8601
        return decoder
    }()
    
    // MARK: - GET from API by categories, by search
    // to fetch data from API by categories
    func fetch(from category: Category) async throws -> [Article] {
        try await fetchArticles(from: generateNewsURL(from: category))
    }
    
    // to fetch data from API by search
    func search(for query: String) async throws -> [Article] {
        try await fetchArticles(from: generateSearchURL(from: query))
    }
    
    // MARK: - GET from API - general func
    // to get the data from API to the model
    private func fetchArticles(from url: URL) async throws -> [Article] {
        
        // to get data with url using async function for the data task
        let (data, response) = try await session.data(from: url)
        
        // get HTTPURLResponse to hendle status codes
        guard let response = response as? HTTPURLResponse else {
            throw generateErrore(description: "Bad Response")
        }
        
        // get data from the API with different http status code
        switch response.statusCode {
            
        // decode the data to NewsAPIResponse using json decoder
        case (200...299), (400...499):
            let apiResponse = try? jsonDecoder.decode(NewsAPIResponse.self, from: data)
            if apiResponse?.status == "ok" {
                // exclude articles that have been deleted
                let filteredResponse = apiResponse?.articles?.filter { !$0.title.contains("[Removed]") }
                return filteredResponse ?? []
            } else {
                throw generateErrore(description: apiResponse?.message ?? "An error occured")
            }
        default:
            // for 5x errors - internal server error
            throw generateErrore(description: "A server error occured")
        }
    }
    
    // MARK: - Error description
    // helper method for the error description
    private func generateErrore(code: Int = 1, description: String) -> Error {
        NSError(domain: "NewsAPI", code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
    
    // MARK: - URLs
    // to generate URLs for the categories
    private func generateNewsURL(from category: Category) -> URL {
        var url = "https://newsapi.org/v2/top-headlines?"
        url += "apiKey=\(apiKey)"
        url += "&language=en"
        url += "&category=\(category.rawValue)" // передаємо в посилання категорію, його назву як значення стрінги rawValue
        return URL(string: url)!
    }
    
    // to generate URLs for the search word
    private func generateSearchURL(from query: String) -> URL {
        let percentEncodedString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        var url = "https://newsapi.org/v2/everything?"
        url += "apiKey=\(apiKey)"
        url += "&language=en"
        url += "&q=\(percentEncodedString)"
        return URL(string: url)!
    }
}
