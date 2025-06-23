//
//  Category.swift
//  chorecade
//
//  Created by júlia fazenda ruiz on 18/06/25.
//


import Foundation
import UIKit

struct Category: Codable {
    let id: UUID
    let title: String
    let points: Int
    let level: Int
    let type: TaskType
}
