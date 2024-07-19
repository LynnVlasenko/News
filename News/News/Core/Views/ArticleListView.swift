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
    
    var isFetchingNextPage = false
    var nextPageHandler: (() async -> ())? = nil
    
    var body: some View {
        List {
            // return the view for each row in the list
            ForEach(articles) { article in
                
                if let nextPageHandler = nextPageHandler, article == articles.last {
                    
                    listRowView(for: article)
                        .task { await nextPageHandler() }
                    
                    if isFetchingNextPage {
                        bottomProgressView
                    }
                    
                } else {
                    listRowView(for: article)
                }
            }
            .listRowInsets(.init(
                top: Constant.listRowInsetsTopBottom,
                leading: Constant.listRowInsetsleadingTrailing,
                bottom: Constant.listRowInsetsTopBottom,
                trailing: Constant.listRowInsetsleadingTrailing))
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
