//
//  Candy.swift
//  CandyKid
//
//  Created by Nelson, Connor on 10/9/20.
//

import Foundation
import SwiftUI

enum Candy: String, Codable, Identifiable {
    case snickers
    case mms
    case butterfinger
    case pretzelSticks

    var id: String {
        return rawValue
    }

    var name: String {
        switch self {
        case .snickers:
            return "Snickers"
        case .mms:
            return "M&Ms"
        case .butterfinger:
            return "Butterfinger"
        case .pretzelSticks:
            return "Pretzel Sticks"
        }
    }

    var image: Image {
        return Image(rawValue)
    }
}
