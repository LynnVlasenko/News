//
//  ArticleRowView.swift
//  News
//
//  Created by Alina Vlasenko on 20.06.2024.
//

import SwiftUI

struct ArticleRowView: View {
    
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
                        ProgressView()
                        Spacer()
                    }
                    .frame(minHeight: 200, maxHeight: 300)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
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
            .background(Color.gray.opacity(0.3))
            .clipped()
            
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
                        
                    } label: {
                        Image(systemName: "bookmark")
                    }
                    .buttonStyle(.bordered)
                    .tint(Color.cyan)
                    
                    Button {
                        
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
    }
}

struct ArticleRowView_Previews: PreviewProvider {

    static var previews: some View {
        NavigationView {
            List {
                ArticleRowView(article: .previewData[0])
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .listStyle(.plain)
        }
    }
}
