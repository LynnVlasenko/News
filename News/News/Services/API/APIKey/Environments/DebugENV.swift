//
//  DebugENV.swift
//  News
//
//  Created by Alina Vlasenko on 12.07.2024.
//

import Foundation

class DebugENV: BaseENV, APIKeyable {
    
    init() {
        super.init(resourceName: "DEBUG-Keys")
    }
    
    var serviceAPIKey: String {
        dict.object(forKey: "SERVICE_API_KEY") as? String ?? ""
    }
}
