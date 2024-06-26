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
    
    // створюємо новий масив для статей, щоб підгружати по стоінкам (старий масив був в MainArticlesTabView - ми його видалили, так як отримання статей тим способом не буде працювати належним чином з пагінацією)
    // створюємо компьютед проперті, яка повертає масив і тут передаємо значення(властивість vslue) з DataFetchPhase
    
    var articles: [Article] {
        phase.value ?? []
    }
    
    // перевірити що цей стан може бути використаний вьюшкою щоб визначити де має відображатись індикатор прогресу внизу
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
    
    // в цій реалізації оновлення даних може відбутися у 2 випадках
    // 1 - якщо останній перегляд у списку з'являєтьсяч знову, тобто коли юзер прокручує вгору та вниз
    // 2 - коли юзер оновлює вручну, використовуючи кннопку оновлення або натискання кнопки оновлення на навігейшн барі, тому це тригерує завантаження першої сторінки та повертає дані для підкачки на першу сторінку
    
    // load first page from API
    // щоб цей метод спочатку отримав інформацію коли з'явиться новий перегляд кроків на екрані // коли він переходить до цього оператора DO, нам потрібно скинути pagingData і викликати функцію reset у pagingData - це гарантує скидання даних до першої сторінки (тобто перший 10 елементів і першої сторінки з АРІ)
    // MARK: - load actions
    // load the first page from API
    func loadFirstPage() async {
        
        if Task.isCancelled { return }
        
        phase = .empty
        
        do {
            // скидаємо дані до 1 сторінки
            await pagingData.reset()
            
            // тут ми теж використаємо pagingData і його функцію завантаженння наступної сторінки - метод, що приймає ця функція відповідний тому, що ми створити для вивантаження даних з АРІ - loadArticles(page: Int) async throws -> [Article] // і виходить так, що pagingData викличе loadArticles передавши властивість поточної сторінки(currentPage), а потім завантажить її з АРІ передавши сторінку (page: page) / після того як вона буде передана, pagingData.loadNextPage інкрементує лічильник поточної сторінки і поверне дані з нової сторінки
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
        
        // захопимо статтю за допомогою phase і прописаної в ньому властивості value
        let articles = self.phase.value ?? []
        // встановимо фазу що ми отримуємо наступну сторінку
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
