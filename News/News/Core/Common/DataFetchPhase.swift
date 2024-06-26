//
//  DataFetchPhase.swift
//  News
//
//  Created by Alina Vlasenko on 25.06.2024.
//

import Foundation

// statuses of receiving data from the API
enum DataFetchPhase<T> {
    case empty
    case success(T)
    case fetchingNextPage(T)
    case failure(Error)
    
    var value: T? {
        if case .success(let value) = self {
            return value
        } else if case .fetchingNextPage(let value) = self {
            return value
        }
        return nil
    }
}
