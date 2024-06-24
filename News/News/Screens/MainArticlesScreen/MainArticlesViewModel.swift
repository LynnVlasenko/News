//
//  MainArticlesViewModel.swift
//  News
//
//  Created by Alina Vlasenko on 19.06.2024.
//

import SwiftUI

//  statuses of receiving data from the API
enum DataFetchPhase<T> {
    case empty
    case success(T)
    case failure(Error)
}

// fetch Task Token to trigger the task update with the current date to fetch a new data request
struct FetchTaskToken: Equatable {
    var category: Category
    var token: Date
}

// MainActor - a singleton actor whose executor is equivalent to the main dispatch queue.
@MainActor
class MainArticlesViewModel: ObservableObject {
    
    @Published var phase = DataFetchPhase<[Article]>.empty
    @Published var fetchTaskToken: FetchTaskToken
    
    private let newsAPI = NewsAPI.shared
    
    init(articles: [Article]? = nil, selectedCategory: Category = .general) {
        
        if let articles = articles {
            self.phase = .success(articles)
        } else {
            self.phase = .empty
        }
        
        self.fetchTaskToken = FetchTaskToken(category: selectedCategory, token: Date())
    }
    
    // load the data fron API
    func loadArticles() async {
        // add moke data to avoid making requests to the api every time during development
        //phase = .success(Article.previewData)
        
        // censel case for the Task
        if Task.isCancelled { return }
        phase = .empty
        
        do {
            let articles = try await newsAPI.fetch(from: fetchTaskToken.category)
            if Task.isCancelled { return }
            phase = .success(articles)
        } catch {
            if Task.isCancelled { return }
            print(error.localizedDescription)
            phase = .failure(error)
        }
    }
}
