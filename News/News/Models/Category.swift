//
//  Category.swift
//  News
//
//  Created by Alina Vlasenko on 19.06.2024.
//

import Foundation

// CaseIterable - A type that provides a collection of all of its values.
// access a collection by using `allCases` property
enum Category: String, CaseIterable {
    
    case general
    case business
    case technology
    case entertainment
    case sports
    case science
    case health
        
    // to display the title for each category
    var text: String {
        if self == .general {
            return "Top News"
        }
        // capitalize each word in the title
        return rawValue.capitalized
    }
}

// Identifiable - to create a unique id
extension Category: Identifiable {
    var id: Self { self }
}
