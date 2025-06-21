//
//  CategorySelector.swift
//  chorecade
//
//  Created by Gabriel Kowaleski on 20/06/25.
//

import UIKit

class GroupSelector: UIView {
    
    var onGroupSelected: ((Group) -> Void)?
    
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
        
        let titleText = selectedGroup?.name ?? mockGroups.first?.name ?? "Select"

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
    
    var availableGroups: [Group] {
            return Persistence.getGroups()?.groups ?? []
        }
    
    var mockGroups: [Group] {
        return Persistence.getGroups()?.groups ?? []
    }
    
    private var groupSelections: [UIAction] {
            availableGroups.map { group in
                let action = UIAction(title: group.name) { [weak self] _ in
                    self?.selectedGroup = group
                }
                
                // Apply custom styling to the menu items
                let attributed = NSAttributedString(
                    string: group.name,
                    attributes: [
                        .foregroundColor: UIColor.primaryPurple300 // Assuming this is defined
                    ]
                )
                action.setValue(attributed, forKey: "attributedTitle")
                
                action.state = (group.id == selectedGroup?.id) ? .on : .off
                
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
        
        if let lastSelectedGroupId = UserDefaults.standard.string(forKey: "lastSelectedGroupId"),
                   let uuid = UUID(uuidString: lastSelectedGroupId),
                   let savedGroup = availableGroups.first(where: { $0.id == uuid }) {
                    self.selectedGroup = savedGroup
                } else {
                    self.selectedGroup = availableGroups.first // Default to the first group if no preference
                }
                
                // Now that selectedGroup is set, configure the button's menu and initial title
                updateButtonConfiguration()
                
                // Trigger the initial onGroupSelected event, so TaskListView gets the current group
                if let initialGroup = selectedGroup {
                    onGroupSelected?(initialGroup)
                }
        
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
