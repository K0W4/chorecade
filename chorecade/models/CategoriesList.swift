//
//  Categories.swift
//  chorecade
//
//  Created by júlia fazenda ruiz on 18/06/25.
//

import Foundation

struct CategoriesList {
    static let allCategories: [Category] = [
        Category(id: 1, title: "Take out the trash", points: 5, level: 1, type: .cleaning),
        Category(id: 2, title: "Replace toilet paper", points: 5, level: 1, type: .bathroom),
        Category(id: 3, title: "Refill food bowl", points: 5, level: 1, type: .petCare),
        Category(id: 4, title: "Refill water bowl", points: 5, level: 1, type: .petCare),
        Category(id: 5, title: "Water the plants", points: 8, level: 1, type: .gardening),
        Category(id: 6, title: "Wash pet's food/water bowls", points: 8, level: 1, type: .petCare),
        Category(id: 7, title: "Put scattered items away", points: 9, level: 1, type: .organization),
        Category(id: 8, title: "Dust the furniture", points: 10, level: 1, type: .cleaning),
        Category(id: 9, title: "Clean litter box / pick up poop", points: 10, level: 1, type: .petCare),
        Category(id: 10, title: "Brush pet's fur", points: 10, level: 1, type: .petCare),
        Category(id: 11, title: "Play with pet for 15+ minutes", points: 10, level: 1, type: .petCare),
        Category(id: 12, title: "Take pet for a short walk", points: 12, level: 1, type: .petCare),

        Category(id: 13, title: "Clean pet's bed or resting area", points: 15, level: 2, type: .petCare),
        Category(id: 14, title: "Wash the dishes", points: 15, level: 2, type: .cooking),
        Category(id: 15, title: "Sweep and mop the floor", points: 18, level: 2, type: .cleaning),
        Category(id: 16, title: "Partially clean the bathroom", points: 20, level: 2, type: .bathroom),
        Category(id: 17, title: "Give pet a bath", points: 20, level: 2, type: .petCare),
        Category(id: 18, title: "Administer pet medication", points: 20, level: 2, type: .petCare),
        Category(id: 19, title: "Hang the laundry", points: 22, level: 2, type: .laundry),
        Category(id: 20, title: "Organize drawers or closet", points: 25, level: 2, type: .organization),
        Category(id: 21, title: "Take pet to vet / grooming", points: 25, level: 2, type: .petCare),

        Category(id: 22, title: "Deep clean the bathroom", points: 30, level: 3, type: .bathroom),
        Category(id: 23, title: "Cook a full meal for everyone", points: 35, level: 3, type: .cooking),
        Category(id: 24, title: "Wash and put away bed linens", points: 40, level: 3, type: .laundry),
        Category(id: 25, title: "Clean the stove and microwave", points: 45, level: 3, type: .cooking),
        Category(id: 26, title: "Full house clean", points: 50, level: 3, type: .cleaning),
    ]
}
