//
//  SafariView.swift
//  News
//
//  Created by Alina Vlasenko on 20.06.2024.
//

import Foundation

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    
    let url: URL
    
    // create a SafariViewController to open articles through the Safari browser inside the app.
    func makeUIViewController(context: Context) -> some SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
}
