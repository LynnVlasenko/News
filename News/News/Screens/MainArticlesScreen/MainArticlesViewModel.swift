//
//  MainArticlesViewModel.swift
//  News
//
//  Created by Alina Vlasenko on 19.06.2024.
//

import SwiftUI

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
    private let pagingData = PagingData(itemsPerPage: 10, maxPageLimit: 10)
    
    var articles: [Article] {
        phase.value ?? []
    }
    
    var isFetchingNextPage: Bool {
        if case .fetchingNextPage = phase {
            return true
        }
        return false
    }
    
    // MARK: - init
    init(articles: [Article]? = nil, selectedCategory: Category = .general) {
        
        if let articles = articles {
            self.phase = .success(articles)
        } else {
            self.phase = .empty
        }
        
        self.fetchTaskToken = FetchTaskToken(category: selectedCategory, token: Date())
    }
    
    // MARK: - load actions
    // load the first page from API
    func loadFirstPage() async {
        
        if Task.isCancelled { return }
        
        phase = .empty
        
        do {
            // reset data to first page
            await pagingData.reset()
            
            // updating currentPage to next page to fetch new page
            let articles = try await pagingData.loadNextPage(dataFetchProvider: loadArticles(page:))
            if Task.isCancelled { return }
            phase = .success(articles)
        } catch {
            if Task.isCancelled { return }
            print(error.localizedDescription)
            phase = .failure(error)
        }
    }
    
    // load the next page from API
    func loadNextPage() async {
        
        if Task.isCancelled { return }
        
        let articles = self.phase.value ?? []
        phase = .fetchingNextPage(articles)
        
        do {
            let nextArticles = try await pagingData.loadNextPage(dataFetchProvider: loadArticles(page:))
            if Task.isCancelled { return }
            
            phase = .success(articles + nextArticles)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // load the data from API
    private func loadArticles(page: Int) async throws -> [Article] {
        let articles = try await newsAPI.fetch(
            from: fetchTaskToken.category,
            page: page,
            pageSize: pagingData.itemsPerPage)
        if Task.isCancelled { return [] }
        return articles
    }
}
