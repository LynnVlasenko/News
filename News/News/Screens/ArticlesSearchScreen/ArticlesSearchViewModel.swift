//
//  ArticlesSearchViewModel.swift
//  News
//
//  Created by Alina Vlasenko on 24.06.2024.
//

import SwiftUI

@MainActor
class ArticlesSearchViewModel: ObservableObject {
    
    @Published var phase: DataFetchPhase<[Article]> = .empty
    @Published var searchQuery = ""
    @Published var history = [String]()
    private let historyDataStore = PlistDataStore<[String]>(filename: "histories")
    
    static let shared = ArticlesSearchViewModel()
    
    private init() {
        load()
    }
    
    private let historyMaxLimit = 10
    
    private let newsAPI = NewsAPI.shared
    
    // MARK: - Search method
    func searchArticle() async {
        
        if Task.isCancelled { return }
        
        let searchQuery = self.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
       
        phase = .empty
        
        if searchQuery.isEmpty {
            return
        }
        
        do {
            let articles = try await newsAPI.search(for: searchQuery)
            
            if Task.isCancelled { return }
            if searchQuery != self.searchQuery { return }
            
            phase = .success(articles)
        } catch {
            
            if Task.isCancelled { return }
            if searchQuery != self.searchQuery { return }
            
            phase = .failure(error)
        }
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
