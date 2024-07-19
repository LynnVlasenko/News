//
//  ArticlesSearchViewModel.swift
//  News
//
//  Created by Alina Vlasenko on 24.06.2024.
//

import SwiftUI

@MainActor
class ArticlesSearchViewModel: ObservableObject {
    
    @Published var phase = DataFetchPhase<[Article]>.empty
    @Published var searchQuery = ""
    @Published var history = [String]()
    private let historyDataStore = PlistDataStore<[String]>(filename: Constant.historyStoreFilename)
    
    static let shared = ArticlesSearchViewModel()
    
    private init() {
        load()
    }
    
    private let pagingData = PagingData(itemsPerPage: 25, maxPageLimit: 4)

    var articles: [Article] {
        phase.value ?? []
    }

    var isFetchingNextPage: Bool {
        if case .fetchingNextPage = phase {
            return true
        }
        return false
    }
    
    private let historyMaxLimit = 10
    
    private let newsAPI = NewsAPI.shared
    
    
    // MARK: - Search methods to show articles with pagination
    
    func searchFirstPageArticles() async {
        
        if Task.isCancelled { return }
        let searchQuery = self.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
       
        phase = .empty
        
        if searchQuery.isEmpty { return }
        
        do {
            await pagingData.reset()
            
            let articles = try await pagingData.loadNextPage(dataFetchProvider: loadArticles(page:))
            
            if Task.isCancelled { return }
            if searchQuery != self.searchQuery { return }
            
            phase = .success(articles)
        } catch {
            
            if Task.isCancelled { return }
            if searchQuery != self.searchQuery { return }
            
            phase = .failure(error)
        }
    }
    
    
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
        let searchQuery = self.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let articles = try await newsAPI.search(
            for: searchQuery,
            page: page,
            pageSize: pagingData.itemsPerPage)
        
        if Task.isCancelled { return [] }
        return articles
    }
    
    // MARK: - History methods
    func addHistory(_ text: String) {
        if let index = history.firstIndex(where: { text.lowercased() == $0.lowercased() }) {
            history.remove(at: index)
        } else if history.count == historyMaxLimit {
            history.remove(at: history.count - 1)
        }
        
        history.insert(text, at: 0)
        historiesUpdated()
    }
    
    func removeHistory(_ text: String) {
        guard let index = history.firstIndex(where: { text.lowercased() == $0.lowercased() }) else {
            return
        }
        history.remove(at: index)
        historiesUpdated()
    }
        
    func removeAllHistory() {
        history.removeAll()
        historiesUpdated()
    }
    
    // // MARK: - History persistence methods
    private func load() {
        Task {
            self.history = await historyDataStore.load() ?? []
        }
    }
        
    private func historiesUpdated() {
        let history = self.history
        Task {
            await historyDataStore.save(history)
        }
    }
}
