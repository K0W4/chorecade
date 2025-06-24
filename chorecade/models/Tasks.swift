//
// Task.swift
// chorecade
//
// Created by João Pedro Teixeira de Carvalho on 10/06/25.
//
import Foundation
import UIKit
import CloudKit

class Tasks {
    var id: CKRecord.ID? =  nil
    let category: Category
    let description: String
    let user: CKRecord.ID
    let group: String

    var beforeImage: UIImage?
    var afterImage: UIImage?
    
    // Inicializador padrão
    init(category: Category, description: String, user: CKRecord.ID, group: String, beforeImage: UIImage? = nil, afterImage: UIImage? = nil) {
        self.category = category
        self.description = description
        self.user = user
        self.group = group
        self.beforeImage = beforeImage
        self.afterImage = afterImage
    }

    // Inicializador a partir do CKRecord
    init?(record: CKRecord) {
        guard
            let idString = record["id"] as? String,
            let categoryID = record["categoryID"] as? Int,
            let description = record["description"] as? String,
            let userReference = record["user"] as? CKRecord.ID // Exemplo de como pode ser feito
        else {
            return nil
        }
        
        self.id = record.recordID
        self.category = CategoriesList.allCategories[categoryID - 1]
        self.description = description
        self.user = userReference // Implemente isso de acordo com seu modelo
        self.group = "" // Implemente se for salvar group como referência
        
        if let beforeAsset = record["beforeImage"] as? CKAsset,
           let imageData = try? Data(contentsOf: beforeAsset.fileURL!) {
            self.beforeImage = UIImage(data: imageData)
        }
        if let afterAsset = record["afterImage"] as? CKAsset,
           let imageData = try? Data(contentsOf: afterAsset.fileURL!) {
            self.afterImage = UIImage(data: imageData)
        }
    }

    // Função para criar CKRecord a partir da Task
    func toRecord(task: Tasks) -> CKRecord {
        let record = CKRecord(recordType: "Tasks")
        record["categoryID"] = task.category.id
        record["description"] = task.description
        record["user"] = String(describing: task.user)
        
        
        // Salvar as imagens como CKAsset
        if let beforeImage = beforeImage,
           let asset = Tasks.imageToCKAsset(image: beforeImage, name: "before_\(String(describing: id)).jpg") {
            record["beforeImage"] = asset
        }
        if let afterImage = afterImage,
           let asset = Tasks.imageToCKAsset(image: afterImage, name: "after_\(String(describing: id)).jpg") {
            record["afterImage"] = asset
        }
        // Se quiser salvar referência para grupo:
        // record["group"] = group?.toReference()

        return record
    }
    
    // Utilitário para salvar UIImage como arquivo temporário e criar CKAsset
    static func imageToCKAsset(image: UIImage, name: String) -> CKAsset? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let tempDir = NSTemporaryDirectory()
        let url = URL(fileURLWithPath: tempDir).appendingPathComponent(name)
        do {
            try data.write(to: url)
            return CKAsset(fileURL: url)
        } catch {
            print("Erro ao salvar imagem temporária: \(error)")
            return nil
        }
    }
}
