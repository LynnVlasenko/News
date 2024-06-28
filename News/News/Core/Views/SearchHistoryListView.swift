//
//  SearchHistoryListView.swift
//  News
//
//  Created by Alina Vlasenko on 24.06.2024.
//

import SwiftUI

struct SearchHistoryListView: View {
    
    @ObservedObject var searchVM: ArticlesSearchViewModel
    
    let onSubmit: (String) -> ()
    
    var body: some View {
        List {
            HStack {
                Text(Constant.hstTitle)
                    .foregroundStyle(.secondary)
                Spacer()
                Button(Constant.clearBtnText) {
                    searchVM.removeAllHistory()
                }
                .foregroundColor(Color.cyan)
            }
            .listRowSeparator(.hidden)
            
            ForEach(searchVM.history, id: \.self) { history in
                Button(history) {
                    onSubmit(history)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        searchVM.removeHistory(history)
                    } label: {
                        Label(Constant.deleteLbl, systemImage: Constant.deleteIcon)
                    }
                    .tint(Color.red)
                }
            }
        }
        .listStyle(.plain)
    }
}

struct SearchHistoryListView_Previews: PreviewProvider {
    static var previews: some View {
        SearchHistoryListView(searchVM: ArticlesSearchViewModel.shared) { _ in
            
        }
    }
}
