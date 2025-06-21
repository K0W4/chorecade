//
//  Categories.swift
//  chorecade
//
//  Created by júlia fazenda ruiz on 18/06/25.
//



import Foundation

struct CategoriesList {
    static let allCategories: [Category] = [
        Category(id: UUID(), title: "Take out the trash", points: 5, level: 1, type: .cleaning),
        Category(id: UUID(), title: "Replace toilet paper", points: 5, level: 1, type: .bathroom),
        Category(id: UUID(), title: "Refill food bowl", points: 5, level: 1, type: .petCare),
        Category(id: UUID(), title: "Refill water bowl", points: 5, level: 1, type: .petCare),
        Category(id: UUID(), title: "Water the plants", points: 8, level: 1, type: .gardening),
        Category(id: UUID(), title: "Wash pet's food/water bowls", points: 8, level: 1, type: .petCare),
        Category(id: UUID(), title: "Put scattered items away", points: 9, level: 1, type: .organization),
        Category(id: UUID(), title: "Dust the furniture", points: 10, level: 1, type: .cleaning),
        Category(id: UUID(), title: "Clean litter box / pick up poop", points: 10, level: 1, type: .petCare),
        Category(id: UUID(), title: "Brush pet's fur", points: 10, level: 1, type: .petCare),
        Category(id: UUID(), title: "Play with pet for 15+ minutes", points: 10, level: 1, type: .petCare),
        Category(id: UUID(), title: "Take pet for a short walk", points: 12, level: 1, type: .petCare),
        
        Category(id: UUID(), title: "Clean pet's bed or resting area", points: 15, level: 2, type: .petCare),
        Category(id: UUID(), title: "Wash the dishes", points: 15, level: 2, type: .cooking),
        Category(id: UUID(), title: "Sweep and mop the floor", points: 18, level: 2, type: .cleaning),
        Category(id: UUID(), title: "Partially clean the bathroom", points: 20, level: 2, type: .bathroom),
        Category(id: UUID(), title: "Give pet a bath", points: 20, level: 2, type: .petCare),
        Category(id: UUID(), title: "Administer pet medication", points: 20, level: 2, type: .petCare),
        Category(id: UUID(), title: "Hang the laundry", points: 22, level: 2, type: .laundry),
        Category(id: UUID(), title: "Organize drawers or closet", points: 25, level: 2, type: .organization),
        Category(id: UUID(), title: "Take pet to vet / grooming", points: 25, level: 2, type: .petCare),
        
        Category(id: UUID(), title: "Deep clean the bathroom", points: 30, level: 3, type: .bathroom),
        Category(id: UUID(), title: "Cook a full meal for everyone", points: 35, level: 3, type: .cooking),
        Category(id: UUID(), title: "Wash and put away bed linens", points: 40, level: 3, type: .laundry),
        Category(id: UUID(), title: "Clean the stove and microwave", points: 45, level: 3, type: .cooking),
        Category(id: UUID(), title: "Full house clean", points: 50, level: 3, type: .cleaning),
    ]
}
