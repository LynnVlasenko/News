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
        VStack(alignment: .leading, spacing: Constant.mainVStackSpacing) {
            
            // fetch image from URL-link using AsyncImage
            AsyncImage(url: article.imageURL) { phase in
                switch phase {
                // return appropriate view depending on the phase
                case .empty:
                    HStack {
                        Spacer()
                        Image(systemName: Constant.photoPlaceholderIcon)
                            .imageScale(.large)
                        Spacer()
                    }
                    .frame(minHeight: Constant.articlePhotoMinHeight,
                           maxHeight: Constant.articlePhotoMaxHeight)
                case .success(let image):
                    GeometryReader { geometry in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                case .failure:
                    HStack {
                        Spacer()
                        Image(systemName: Constant.photoPlaceholderIcon)
                            .imageScale(.large)
                        Spacer()
                    }
                    .frame(minHeight: Constant.articlePhotoMinHeight,
                           maxHeight: Constant.articlePhotoMaxHeight)
                @unknown default:
                    HStack {
                        Spacer()
                        Image(systemName: Constant.photoPlaceholderIcon)
                            .imageScale(.large)
                        Spacer()
                    }
                    .frame(minHeight: Constant.articlePhotoMinHeight,
                           maxHeight: Constant.articlePhotoMaxHeight)
                }
            }
            .background(Color.cyan.opacity(Constant.photoBgOpacity))
            .clipped()
            .frame(minHeight: Constant.articlePhotoMinHeight,
                   maxHeight: Constant.articlePhotoMaxHeight)
            
            VStack(alignment: .leading, spacing: Constant.infoVStackSpacing) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(Constant.titleLineLimit)
                
                Text(article.descriptionText)
                    .font(.subheadline)
                    .lineLimit(Constant.descrLineLimit)
                HStack {
                    Text(article.captionText)
                        .lineLimit(Constant.captionLineLimit)
                        .foregroundColor(.secondary)
                        .font(.caption)
                    
                    Spacer()
                    
                    Button {
                        toggleBookmark(for: article)
                    } label: {
                        Image(systemName:
                                bookmarkedArticlesVM.isBookmarked(for: article)
                              ? Constant.bookmarkFillIcon
                              : Constant.bookmarkIcon)
                    }
                    .buttonStyle(.bordered)
                    .tint(Color.cyan)
                    
                    Button {
                        presentShareSheet(url: article.articleURL)
                    } label: {
                        Image(systemName: Constant.saveArticleIcon)
                    }
                    .buttonStyle(.bordered)
                    .tint(Color.cyan)
                }
            }
            .padding([.horizontal, .bottom])
        }
        .background(Color.init(uiColor: .secondarySystemBackground))
        .border(Color.init(uiColor: .secondarySystemBackground))
        .cornerRadius(Constant.rowRadius)
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
                    .listRowInsets(.init(
                        top: Constant.listRowInsetsTopBottom,
                        leading: Constant.listRowInsetsleadingTrailing,
                        bottom: Constant.listRowInsetsTopBottom,
                        trailing: Constant.listRowInsetsleadingTrailing))
            }
            .listStyle(.plain)
        }
        .environmentObject(bookmarkedArticlesVM)
    }
}
