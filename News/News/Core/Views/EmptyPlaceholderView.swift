//
//  EmptyPlaceholderView.swift
//  News
//
//  Created by Alina Vlasenko on 20.06.2024.
//

import SwiftUI

struct EmptyPlaceholderView: View {
    let text: String
    let image: Image?
    
    var body: some View {
        VStack(spacing: Constant.phVStackSpacing) {
            Spacer()
            if let image = self.image {
                image
                    .imageScale(.large)
                    .font(.system(size: Constant.phFontSize))
            }
            Text(text)
            Spacer()
        }
    }
}

#Preview {
    EmptyPlaceholderView(text: Constant.phBookmarksText, image: Image(systemName: Constant.bookmarkIcon))
}
