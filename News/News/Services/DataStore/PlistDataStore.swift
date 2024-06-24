//
//  PlistDataStore.swift
//  News
//
//  Created by Alina Vlasenko on 24.06.2024.
//

import Foundation

// Actor - it's a protocol that helps us avoid any data resises issues when we update data
protocol DataStore: Actor {
    
    associatedtype D
    
    func save(_ current: D)
    func load() -> D?
}

actor PlistDataStore<T: Codable>: DataStore where T: Equatable {
    
    private var saved: T?
    let filename: String
    
    init(filename: String){
        self.filename = filename
    }
    
    private var dataURL: URL {
        
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appending(path: "\(filename).plist")
    }
    
    func save(_ current: T) {
        
        if let saved = saved, saved == current {
            return
        }
       
        do {
            
            let encoder = PropertyListEncoder()
            encoder.outputFormat = .binary
            
            let data = try encoder.encode(current)
            
            try data.write(to: dataURL, options: [.atomic])
            print(dataURL)
            self.saved = current
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func load() -> T? {
        
        do {
            let data = try Data(contentsOf: dataURL)
            let decoder = PropertyListDecoder()
           
            let current = try decoder.decode(T.self, from: data)
            
            self.saved = current
            return current
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
