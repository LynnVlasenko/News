//
//  View+ShareSheet.swift
//  News
//
//  Created by Alina Vlasenko on 20.06.2024.
//

import SwiftUI

extension View {
    
    // to present the article sharing screen
    func presentShareSheet(url: URL) {
        
        // create UIActivityViewController with the current url
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        // show UIActivityViewController to share the article or copy its link
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .keyWindow?
            .rootViewController?
            .present(activityVC, animated: true)
    }
}
