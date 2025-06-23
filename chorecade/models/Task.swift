//
// Task.swift
// chorecade
//
// Created by João Pedro Teixeira de Carvalho on 10/06/25.
//
import Foundation
import UIKit

struct Task: Codable, Identifiable {
    let id: UUID
    let category: Category
    let description: String
    
    var beforePicFilename: String? = nil
    var afterPicFilename: String? = nil
    
    let user: User
    let group: Group?
    var isCompleted: Bool = false
    
    
    // Initializer to create a new task (takes UIImages)
    init(id: UUID = UUID(), category: Category, description: String, user: User, group: Group?, beforePic: UIImage? = nil, afterPic: UIImage? = nil) {
        self.id = id
        self.category = category
        self.description = description
        self.user = user
        self.group = group
        self.isCompleted = false // Default value for new tasks
      
        
        // When initializing, save the images to disk and store their filenames
        if let beforePic = beforePic {
            self.beforePicFilename = Persistence.saveImageToFileSystem(image: beforePic, prefix: "before_\(id.uuidString)")
        }
        if let afterPic = afterPic {
            self.afterPicFilename = Persistence.saveImageToFileSystem(image: afterPic, prefix: "after_\(id.uuidString)")
        }
    }
    
    // Computed properties to easily access UIImages (loads from disk)
    var beforeImage: UIImage? {
        guard let filename = beforePicFilename else { return nil }
        return Persistence.loadImageFromFileSystem(filename: filename)
    }
    
    var afterImage: UIImage? {
        guard let filename = afterPicFilename else { return nil }
        return Persistence.loadImageFromFileSystem(filename: filename)
    }
    
    // CHANGE 2: Update CodingKeys to use the new filename properties
    enum CodingKeys: String, CodingKey {
        case id, category, description, user, group, beforePicFilename, afterPicFilename, isCompleted, creationDate
    }

    // Encoder
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(category, forKey: .category)
        try container.encode(description, forKey: .description)
        try container.encode(user, forKey: .user)
        try container.encode(group, forKey: .group)
        try container.encode(isCompleted, forKey: .isCompleted)
        
        
        // Encode only the filenames (Strings)
        try container.encodeIfPresent(beforePicFilename, forKey: .beforePicFilename)
        try container.encodeIfPresent(afterPicFilename, forKey: .afterPicFilename)
    }

    // Decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        category = try container.decode(Category.self, forKey: .category)
        description = try container.decode(String.self, forKey: .description)
        user = try container.decode(User.self, forKey: .user)
        group = try container.decodeIfPresent(Group.self, forKey: .group)
        isCompleted = try container.decodeIfPresent(Bool.self, forKey: .isCompleted) ?? false // Handle migration
       
        
        // Decode the filenames
        beforePicFilename = try container.decodeIfPresent(String.self, forKey: .beforePicFilename)
        afterPicFilename = try container.decodeIfPresent(String.self, forKey: .afterPicFilename)
    }
}
