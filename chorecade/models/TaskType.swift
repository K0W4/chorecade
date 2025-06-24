//
//  TaskType.swift
//  chorecade
//
//  Created by João Pedro Teixeira de Carvalho on 10/06/25.
//

import Foundation

enum TaskType: String, Codable, CaseIterable {
    case cleaning
    case petCare
    case organization
    case cooking
    case laundry
    case bathroom
    case gardening
    case others
}
