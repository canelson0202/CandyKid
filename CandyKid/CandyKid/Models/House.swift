//
//  House.swift
//  CandyKid
//
//  Created by Nelson, Connor on 10/9/20.
//

import Foundation
import SwiftUI

struct House: Codable {
    let name: String
    let number: Int
    let candy: Candy
    let maxStock: Int
    var currentStock: Int
    var restockTime: Date

    var image: Image {
        return Image("house\(number)")
    }

    var stocked: Bool {
        return currentStock > 0 && Date() >= restockTime
    }

    init(name: String, number: Int, candy: Candy, stock: Int) {
        self.init(name: name, number: number, candy: candy, maxStock: stock, currentStock: stock)
    }

    init(name: String, number: Int, candy: Candy, maxStock: Int, currentStock: Int, restockTime: Date = Date()) {
        self.name = name
        self.number = number
        self.candy = candy
        self.currentStock = currentStock
        self.maxStock = maxStock
        self.restockTime = restockTime
    }
}
