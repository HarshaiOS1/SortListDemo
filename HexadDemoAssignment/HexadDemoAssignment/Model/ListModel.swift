//
//  ListModel.swift
//  HexadDemoAssignment
//
//  Created by Harsha on 04/03/20.
//  Copyright © 2020 Harsha. All rights reserved.
//

import Foundation

// MARK: - ListModel
struct ListModel: Codable {
    var itemlist: [Itemlist]?
}

// MARK: - Itemlist
struct Itemlist: Codable {
    var name: String?
    var rating: Float?
}

struct NetworkConstants {
    static let positiveStatusCodes = [200,201,202,203,204]
}
