//
//  ArticleListView.swift
//  News
//
//  Created by Alina Vlasenko on 20.06.2024.
//

import SwiftUI

struct ArticleListView: View {
    
    let articles: [Article]
    @State private var selectedArticle: Article?
    
    // властивість отримання наступної сторінку
    var isFetchingNextPage = false
    var nextPageHandler: (() async -> ())? = nil
    
    var body: some View {
        List {
            // return the view for each row in the list
            ForEach(articles) { article in
                // якщо значення nextPageHandler існує і параметр article дорівнює останній статті, то це означає, що це нижня частина списку
                if let nextPageHandler = nextPageHandler, article == articles.last {
                    // в цьому випадку передаємо рядок (який ми винесли у окрему функцію)
                    listRowView(for: article)
                    // далі передаємо таск модіфаєр, який тригериватиметься, коли з'явиться останнє подання на екрані
                        .task { await nextPageHandler() }
                    // далі потрібно перевірити, що isFetchingNextPage є тру і передаємо тут прогрес бар, щоб відобразити, коли заваннтажується ннова пачка статей
                    if isFetchingNextPage {
                        bottomProgressView
                    }
                    
                } else {
                    listRowView(for: article)
                }
            }
            .listRowInsets(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
            .listRowSeparator(.hidden)
            // represents a sheet using the given element as the data source for the sheet's content
            .sheet(item: $selectedArticle) {
                SafariView(url: $0.articleURL)
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
        .listStyle(.plain)
    }
    
    @ViewBuilder
    private var bottomProgressView: some View {
        Divider()
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }.padding()
    }
    
    @ViewBuilder
    private func listRowView(for article: Article) -> some View {
        ArticleRowView(article: article)
            // pass the clicked article
            .onTapGesture {
                selectedArticle = article
            }
    }
}

struct ArticleListView_Previews: PreviewProvider {
    
    @StateObject static var bookmarkedArticlesVM = BookmarkedArticlesViewModel.shared
    
    static var previews: some View {
        NavigationView {
            ArticleListView(articles: Article.previewData)
                .environmentObject(bookmarkedArticlesVM)
        }
    }
}
