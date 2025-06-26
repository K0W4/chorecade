//
//  CategorySelector.swift
//  chorecade
//
//  Created by Gabriel Kowaleski on 20/06/25.
//

import UIKit
import CloudKit

class GroupSelector: UIView {
    
    enum DisplayStyle {
        case normal
        case large
    }
    
    var style: DisplayStyle = .normal
    var onGroupSelected: ((Group) -> Void)?
    var groupRecords: [CKRecord] = []
    var groupModels: [Group] = []
    
    // MARK: Components
    lazy var button: UIButton = {
        let button = UIButton()
        button.menu = UIMenu(title: "Groups", options: [.singleSelection], children: groupSelections)
        button.showsMenuAsPrimaryAction = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var config = UIButton.Configuration.plain()
        let indicator = UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate)
        
        let indicatorConfig = UIImage.SymbolConfiguration(pointSize: (style == .large) ? 20 : 12, weight: .bold)
        let tintedIndicator = indicator?.applyingSymbolConfiguration(indicatorConfig)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        
        config.image = tintedIndicator
        config.imagePlacement = .trailing
        config.imagePadding = 8
        
        let titleText = selectedGroup?.name ?? groupModels.first?.name ?? "Select"
        let font: UIFont = (style == .large) ? Fonts.largeGroupLabel! : Fonts.nameOnTasks!
        
        let attributedTitle = AttributedString(
            titleText,
            attributes: AttributeContainer([
                .font: font,
                .foregroundColor: UIColor.black,
            ])
        )
        config.attributedTitle = attributedTitle
        if style == .large {
            button.titleLabel?.numberOfLines = 1 // Ensure only one line
            button.titleLabel?.lineBreakMode = .byTruncatingTail // Add ellipsis at the end
        }
        button.configuration = config
        return button
    }()
    
    // MARK: Properties
    
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
                    .foregroundColor: UIColor.primaryPurple300,
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
    
    init(style: DisplayStyle = .normal) {
        self.style = style
        super.init(frame: .zero)
        setup()
        
        getGroupByUser()
        
        
        if style == .large {
            button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func getGroupByUser() {
        guard let currentUserID = Repository.userRecordID?.recordName else {
            print("currentUserID NIL!");
            return
        }
        
        Task {
            self.groupRecords = try await Repository.fetchGroupsForUser(userID: currentUserID)
            self.processGroupRecords()
        }
    }
    
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
    
    private func updateButtonConfiguration() {
        var config = UIButton.Configuration.plain()
        let indicator = UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate)
        
        let indicatorConfig = UIImage.SymbolConfiguration(pointSize: (style == .large) ? 20 : 12, weight: .bold)
        let tintedIndicator = indicator?.applyingSymbolConfiguration(indicatorConfig)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        
        config.image = tintedIndicator
        config.imagePlacement = .trailing
        config.imagePadding = 8
        
        let titleText = selectedGroup?.name ?? "Select Group" // Fallback text
        let font: UIFont = (style == .large) ? Fonts.largeGroupLabel! : Fonts.nameOnTasks!
        
        let attributedTitle = AttributedString(
            titleText,
            attributes: AttributeContainer([
                .font: font,
                .foregroundColor: UIColor.black,
            ])
        )
        config.attributedTitle = attributedTitle
        
        if style == .large {
            button.titleLabel?.numberOfLines = 1 // Ensure only one line
            button.titleLabel?.lineBreakMode = .byTruncatingTail // Add ellipsis at the end
        }

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
