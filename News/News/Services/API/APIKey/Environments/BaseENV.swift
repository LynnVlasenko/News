//
//  BaseENV.swift
//  News
//
//  Created by Alina Vlasenko on 12.07.2024.
//

import Foundation

class BaseENV {
    
    let dict: NSDictionary
    
    init (resourceName: String) {
        guard let filePath = Bundle.main.path(forResource: resourceName, ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath)
        else {
            fatalError("Couldn't find file '\(resourceName)' plist")
        }
        self.dict = plist
    }
}
