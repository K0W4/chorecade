//
//  CategorySelector.swift
//  chorecade
//
//  Created by Gabriel Kowaleski on 20/06/25.
//

import UIKit
import CloudKit

class GroupSelector: UIView {
    
    var onGroupSelected: ((Group) -> Void)?
    var groupRecords: [CKRecord] = []
    
    // MARK: Components
    lazy var button: UIButton = {
        let button = UIButton()
        button.menu = UIMenu(title: "Groups", options: [.singleSelection], children: groupSelections)
        button.showsMenuAsPrimaryAction = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var config = UIButton.Configuration.plain()
        let indicator = UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate)
        
        let indicatorConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        let tintedIndicator = indicator?.applyingSymbolConfiguration(indicatorConfig)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        
        config.image = tintedIndicator
        config.imagePlacement = .trailing
        config.imagePadding = 8
        
        let titleText = selectedGroup?.name ?? groupModels.first?.name ?? "Select"

        let attributedTitle = AttributedString(
            titleText,
            attributes: AttributeContainer([
                .font: Fonts.nameOnTasks,
                .foregroundColor: UIColor.black,
            ])
        )
        config.attributedTitle = attributedTitle
        
        button.configuration = config
        return button
    }()
    
    
    // MARK: Data -- ajustar para buscar os grupos por user
    
    
    func getGroupByUser() {
        guard let currentUserID = Repository.userRecordID?.recordName else {
                print("currentUserID NIL!");
                return
            }
        
        Task {
            self.groupRecords = await try Repository.fetchGroupsForUser(userID: currentUserID)
            self.processGroupRecords()
        }
    }
    
    var groupModels: [Group] = []

    // 2. Quando carregar os records, processe eles assíncronamente:
    func processGroupRecords() {
        Task {
            var models: [Group] = []
            try await withThrowingTaskGroup(of: Group?.self) { group in
                for record in groupRecords {
                    group.addTask {
                        await Repository.createGroupModel(byRecord: record)
                    }
                }
                for try await groupResult in group {
                    if let model = groupResult {
                        models.append(model)
                    }
                }
            }
            self.groupModels = models
            
            // Select the most recently updated group (as a sample logic)
            if let recentGroupRecord = groupRecords.sorted(by: { ($0.modificationDate ?? .distantPast) > ($1.modificationDate ?? .distantPast) }).first {
                self.selectedGroup = await Repository.createGroupModel(byRecord: recentGroupRecord)
            } else {
                self.selectedGroup = models.first
            }
            
            self.updateButtonConfiguration()
            
            if let initialGroup = self.selectedGroup {
                self.onGroupSelected?(initialGroup)
            }
        }
    }
//
    
    private var groupSelections: [UIAction] {
        groupRecords.map { group in
            let action = UIAction(title: group["name"] as? String ?? "Unknown Group") { [weak self] _ in
                       Task {
                           self?.selectedGroup = await Repository.createGroupModel(byRecord: group)
                       }
                   }
            
            let attributed = NSAttributedString(
                string: group["name"] as? String ?? "Unknown Group",
                attributes: [
                    .foregroundColor: UIColor.primaryPurple300
                ]
            )
            action.setValue(attributed, forKey: "attributedTitle")
            
            action.state = (group.recordID.recordName == selectedGroup?.id.recordName) ? .on : .off
            
            return action
        }
    }
    var selectedGroup: Group? {
            didSet {
                // Update the button's title when the selectedGroup changes
                updateButtonConfiguration()
                // If the group truly changed, notify the delegate
                if let group = selectedGroup, group.id != oldValue?.id {
                    onGroupSelected?(group)
                }
            }
        }
    
    // MARK: Functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
        getGroupByUser()
        
//        if let lastSelectedGroupId = UserDefaults.standard.string(forKey: "lastSelectedGroupId"),
//
//                   let savedGroup = groupModels.first(where: { $0.id == uuid }) {
//                    self.selectedGroup = savedGroup
//                } else {
//                    self.selectedGroup = groupModels.first // Default to the first group if no preference
//                }
//
//                // Now that selectedGroup is set, configure the button's menu and initial title
//                updateButtonConfiguration()
//
//                // Trigger the initial onGroupSelected event, so TaskListView gets the current group
//                if let initialGroup = selectedGroup {
//                    onGroupSelected?(initialGroup)
//                }
        
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func updateButtonConfiguration() {
            var config = UIButton.Configuration.plain()
            let indicator = UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate)
            
            let indicatorConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
            let tintedIndicator = indicator?.applyingSymbolConfiguration(indicatorConfig)?.withTintColor(.black, renderingMode: .alwaysOriginal)
            
            config.image = tintedIndicator
            config.imagePlacement = .trailing
            config.imagePadding = 8
            
            let titleText = selectedGroup?.name ?? "Select Group" // Fallback text
            
            let attributedTitle = AttributedString(
                titleText,
                attributes: AttributeContainer([
                    .font: Fonts.nameOnTasks, // Assuming Fonts.nameOnTasks is defined
                    .foregroundColor: UIColor.black,
                ])
            )
            config.attributedTitle = attributedTitle
            
            button.configuration = config
            
            // Update the button's menu (important for marking selected item)
            button.menu = UIMenu(title: "Groups", options: [.singleSelection], children: groupSelections)
        }
}

// MARK: Extensions
extension GroupSelector: ViewCodeProtocol {
    func addSubviews() {
        addSubview(button)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        prefix(1).capitalized + dropFirst()
    }
}
