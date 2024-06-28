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
    
    private let apiKey = Constant.apiKey
    private let session = URLSession.shared
    
    // configuration for JSONDecoder
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601 // to convert date from iso8601
        return decoder
    }()
    
    // MARK: - GET from API by categories, by search
    // to fetch data from API by categories
    func fetch(from category: Category, page: Int = 1, pageSize: Int = 20) async throws -> [Article] {
        try await fetchArticles(from: generateNewsURL(from: category, page: page, pageSize: pageSize))
    }
    
    // to fetch data from API by search
    func search(for query: String, page: Int = 1, pageSize: Int = 20) async throws -> [Article] {
        try await fetchArticles(from: generateSearchURL(from: query, page: page, pageSize: pageSize))
    }
    
    // MARK: - GET from API - general func
    // to get the data from API to the model
    private func fetchArticles(from url: URL) async throws -> [Article] {
        
        // to get data with url using async function for the data task
        let (data, response) = try await session.data(from: url)
        
        // get HTTPURLResponse to hendle status codes
        guard let response = response as? HTTPURLResponse else {
            throw generateErrore(description: Constant.responseError)
        }
        
        // get data from the API with different http status code
        switch response.statusCode {
            
        // decode the data to NewsAPIResponse using json decoder
        case (200...299), (400...499):
            let apiResponse = try? jsonDecoder.decode(NewsAPIResponse.self, from: data)
            if apiResponse?.status == Constant.responseSuccess {
                // exclude articles that have been deleted
                let filteredResponse = apiResponse?.articles?.filter { !$0.title.contains("[Removed]") }
                return filteredResponse ?? []
            } else {
                throw generateErrore(description: apiResponse?.message ?? Constant.generalError)
            }
        default:
            // for 5x errors - internal server error
            throw generateErrore(description: Constant.serverError)
        }
    }
    
    // MARK: - Error description
    // helper method for the error description
    private func generateErrore(code: Int = 1, description: String) -> Error {
        NSError(domain: Constant.domainName, code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
    
    // MARK: - URLs
    // to generate URLs for the categories
    private func generateNewsURL(from category: Category, page: Int = 1, pageSize: Int = 20) -> URL {
        var url = "https://newsapi.org/v2/top-headlines?"
        url += "apiKey=\(apiKey)"
        url += "&language=en"
        url += "&category=\(category.rawValue)"
        url += "&page=\(page)"
        url += "&pageSize=\(pageSize)"
        return URL(string: url)!
    }
    
    // to generate URLs for the search word
    private func generateSearchURL(from query: String, page: Int = 1, pageSize: Int = 100) -> URL {
        let percentEncodedString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        var url = "https://newsapi.org/v2/everything?"
        url += "apiKey=\(apiKey)"
        url += "&language=en"
        url += "&q=\(percentEncodedString)"
        url += "&searchIn=title"
        url += "&sortBy=publishedAt"
        url += "&page=\(page)"
        url += "&pageSize=\(pageSize)"
        return URL(string: url)!
    }
}
