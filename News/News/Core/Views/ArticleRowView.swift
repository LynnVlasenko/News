//
//  ArticleRowView.swift
//  News
//
//  Created by Alina Vlasenko on 20.06.2024.
//

import SwiftUI

struct ArticleRowView: View {
    
    // To retrieve the object(get it in NewsApp) in a subview,  use the ``EnvironmentObject`` property wrapper.
    @EnvironmentObject var bookmarkedArticlesVM: BookmarkedArticlesViewModel
    
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // fetch image from URL-link using AsyncImage
            AsyncImage(url: article.imageURL) { phase in
                switch phase {
                // return appropriate view depending on the phase
                case .empty:
                    HStack {
                        Spacer()
                        Image(systemName: "photo.fill")
                            .imageScale(.large)
                        Spacer()
                    }
                    .frame(minHeight: 200, maxHeight: 300)
                case .success(let image):
                    GeometryReader { geometry in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                case .failure:
                    HStack {
                        Spacer()
                        Image(systemName: "photo.fill")
                            .imageScale(.large)
                        Spacer()
                    }
                    .frame(minHeight: 200, maxHeight: 300)
                @unknown default:
                    HStack {
                        Spacer()
                        Image(systemName: "photo.fill")
                            .imageScale(.large)
                        Spacer()
                    }
                    .frame(minHeight: 200, maxHeight: 300)
                }
            }
            .background(Color.cyan.opacity(0.1))
            .clipped()
            .frame(minHeight: 200, maxHeight: 300)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(3)
                
                Text(article.descriptionText)
                    .font(.subheadline)
                    .lineLimit(2)
                HStack {
                    Text(article.captionText)
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                        .font(.caption)
                    
                    Spacer()
                    
                    Button {
                        toggleBookmark(for: article)
                    } label: {
                        Image(systemName:
                                bookmarkedArticlesVM.isBookmarked(for: article)
                              ? "bookmark.fill"
                              : "bookmark")
                    }
                    .buttonStyle(.bordered)
                    .tint(Color.cyan)
                    
                    Button {
                        presentShareSheet(url: article.articleURL)
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .buttonStyle(.bordered)
                    .tint(Color.cyan)
                }
            }
            .padding([.horizontal, .bottom])
        }
        .background(Color.init(uiColor: .secondarySystemBackground))
        .border(Color.init(uiColor: .secondarySystemBackground))
        .cornerRadius(25)
        Spacer()
    }
    
    // MARK: - Actions
    
    private func toggleBookmark(for article: Article) {
        if bookmarkedArticlesVM.isBookmarked(for: article) {
            bookmarkedArticlesVM.removeBookmark(for: article)
        } else {
            bookmarkedArticlesVM.addBookmark(for: article)
        }
    }
}

struct ArticleRowView_Previews: PreviewProvider {
    
    @StateObject static var bookmarkedArticlesVM = BookmarkedArticlesViewModel.shared

    static var previews: some View {
        NavigationView {
            List {
                ArticleRowView(article: .previewData[0])
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .listStyle(.plain)
        }
        .environmentObject(bookmarkedArticlesVM)
    }
}
