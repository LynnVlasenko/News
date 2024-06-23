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
    
    var body: some View {
        List {
            // return the view for each row in the list
            ForEach(articles) { article in
                ArticleRowView(article: article)
                    // pass the clicked article
                    .onTapGesture {
                        selectedArticle = article
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
}

struct ArticleListView_Previews: PreviewProvider {
    
    @StateObject static var bookmarkedArticlesVM = BookmarkedArticlesViewModel()
    
    static var previews: some View {
        NavigationView {
            ArticleListView(articles: Article.previewData)
                .environmentObject(bookmarkedArticlesVM)
        }
    }
}
