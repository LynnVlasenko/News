//
//  ProdENV.swift
//  News
//
//  Created by Alina Vlasenko on 12.07.2024.
//

import Foundation

class ProdENV: BaseENV, APIKeyable {
    init() {
        super.init(resourceName: "PROD-Keys")
    }
    
    var serviceAPIKey: String {
        dict.object(forKey: "SERVICE_API_KEY") as? String ?? ""
    }
}
