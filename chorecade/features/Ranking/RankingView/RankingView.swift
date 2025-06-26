//
//  RankingView.swift
//  chorecade
//
//  Created by Gabriel Kowaleski on 24/06/25.
//

import UIKit

class RankingView: UIView {
    // MARK: Variables
    var currentSelectedGroup: Group?
    var usersByGroup: [User] = [] {
            didSet {
                let sortedUsers = usersByGroup.sorted { $0.points > $1.points }
                
                DispatchQueue.main.async {
                    self.updatePodium(with: sortedUsers)
                    self.rankingTableView.reloadData()
                }
            }
        }
    
    // MARK: Components
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var groupSelector: GroupSelector = {
        let groupSelector = GroupSelector(style: .large)
        groupSelector.onGroupSelected = { [weak self] selectedGroup in
            guard let self = self else { return }
            self.currentSelectedGroup = selectedGroup
            Repository.currentGroup = selectedGroup
          
            Task {
                var users = selectedGroup.users
                DispatchQueue.main.async {
                    self.usersByGroup = users
                    self.rankingTableView.reloadData()
                }
            }
        }
        return groupSelector
    }()
    
    lazy var groupStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews:  [groupSelector, shareRankingButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        return stackView
    }()
    
    
    lazy var shareRankingButton: UIButton = {
        let button = UIButton(configuration: .filled(), primaryAction: nil)
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .primaryPurple
        config.baseForegroundColor = .black
        config.title = "Share Ranking"
        config.attributedTitle = AttributedString("Share Ranking", attributes: AttributeContainer([
            .font: Fonts.points!
        ]))
        config.image = UIImage(systemName: "square.and.arrow.up")
        config.imagePadding = 8
        config.imagePlacement = .trailing
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 13, weight: .regular)
        config.cornerStyle = .capsule

        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleShareButton), for: .touchUpInside)
        return button
    }()
    
    lazy var firstPointsLabel = Components.getLabel(content: "... points", font: Fonts.points, alignment: .center)
    
    lazy var firstPointsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstPointsLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .yellowPoints
        stackView.alignment = .center
        stackView.layer.cornerRadius = 16
        return stackView
    }()
    
    lazy var secondPointsLabel = Components.getLabel(content: "24 points", font: Fonts.points, alignment: .center)
     
    lazy var secondPointsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [secondPointsLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .yellowPoints
        stackView.alignment = .center
        stackView.layer.cornerRadius = 16
        return stackView
    }()
     
    lazy var thirdPointsLabel = Components.getLabel(content: "10 points", font: Fonts.points, alignment: .center)

   
    lazy var thirdPointsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [thirdPointsLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .yellowPoints
        stackView.alignment = .center
        stackView.layer.cornerRadius = 16
        return stackView
    }()
    
    lazy var firstNameLabel = Components.getLabel(content: "Bibi18", font: Fonts.nameOnTasks, alignment: .center)
    
    lazy var secondNameLabel = Components.getLabel(content: "Rafs2", font: Fonts.nameOnTasks, alignment: .center)
    
    lazy var thirdNameLabel = Components.getLabel(content: "Julian", font: Fonts.nameOnTasks, alignment: .center)
        
    lazy var crownImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "crown")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var firstUserImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "defaultImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var winneUserStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [crownImage, firstUserImage])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 3
        return stackView
    }()
    
    lazy var secondUserImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "defaultImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var thirdUserImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "defaultImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var firstUserStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstPointsStack, firstNameLabel, winneUserStack])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var secondUserStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [secondPointsStack, secondNameLabel, secondUserImage])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var thirdUserStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [thirdPointsStack, thirdNameLabel, thirdUserImage])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var podiumImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "podium")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    lazy var rankingTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RankingTableViewCell.self, forCellReuseIdentifier: RankingTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .primaryPurple100
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        return tableView
    }()
    
    lazy var tasksStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews:  [ rankingTableView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.layer.cornerRadius = 16
        stackView.backgroundColor = .primaryPurple100
        stackView.spacing = 16
        return stackView
    }()

    // MARK: - Functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
        setup()
        
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    @objc func handleShareButton() {
        print("Share tapped")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            rankingTableView.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    rankingTableView.removeConstraint(constraint)
                }
            }
            
            let heightConstraint = rankingTableView.heightAnchor.constraint(equalToConstant: rankingTableView.contentSize.height)
            heightConstraint.isActive = true
            layoutIfNeeded()
        }
    }
    
    deinit {
        rankingTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    func updatePodium(with sortedUsers: [User]) {
           // First User (Winner)
           if let firstUser = sortedUsers.first {
               firstPointsLabel.text = "\(firstUser.points) points"
               firstNameLabel.text = firstUser.nickname
               firstUserImage.image = firstUser.avatarHead
           } else {
               // Reset or hide if no first user
               firstPointsLabel.text = "... points"
               firstNameLabel.text = "N/A"
               firstUserImage.image = UIImage(named: "defaultImage")
           }
           
           // Second User
           if sortedUsers.count > 1 {
               let secondUser = sortedUsers[1]
               secondPointsLabel.text = "\(secondUser.points) points"
               secondNameLabel.text = secondUser.nickname
               secondUserImage.image = secondUser.avatarHead
           } else {
               // Reset or hide if no second user
               secondPointsLabel.text = "0 points"
               secondNameLabel.text = "N/A"
               secondUserImage.image = UIImage(named: "defaultImage")
           }
           
           // Third User
           if sortedUsers.count > 2 {
               let thirdUser = sortedUsers[2]
               thirdPointsLabel.text = "\(thirdUser.points) points"
               thirdNameLabel.text = thirdUser.nickname
               thirdUserImage.image = thirdUser.avatarHead
           } else {
               // Reset or hide if no third user
               thirdPointsLabel.text = "0 points"
               thirdNameLabel.text = "N/A"
               thirdUserImage.image = UIImage(named: "defaultImage")
           }
       }
    
}


extension RankingView: ViewCodeProtocol {

    func addSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(groupStack)
        contentView.addSubview(firstUserStack)
        contentView.addSubview(secondUserStack)
        contentView.addSubview(thirdUserStack)
        contentView.addSubview(podiumImage)
        contentView.addSubview(tasksStack)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            groupStack.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
            groupStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            groupSelector.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            shareRankingButton.widthAnchor.constraint(equalToConstant: 136),
            shareRankingButton.heightAnchor.constraint(equalToConstant: 40),
            
            firstUserStack.topAnchor.constraint(equalTo: groupStack.bottomAnchor, constant: 20),
            firstUserStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            firstPointsStack.widthAnchor.constraint(equalToConstant: 70),
            firstPointsStack.heightAnchor.constraint(equalToConstant: 34),
            
            crownImage.heightAnchor.constraint(equalToConstant: 40),
            
            firstUserImage.heightAnchor.constraint(equalToConstant: 77),
            
            secondUserStack.topAnchor.constraint(equalTo: firstUserStack.bottomAnchor, constant: -95),
            secondUserStack.trailingAnchor.constraint(equalTo: firstUserStack.leadingAnchor, constant: -10),
            
            secondPointsStack.widthAnchor.constraint(equalToConstant: 70),
            secondPointsStack.heightAnchor.constraint(equalToConstant: 34),
            
            secondUserImage.widthAnchor.constraint(equalToConstant: 65),
            secondUserImage.heightAnchor.constraint(equalToConstant: 77),
            
            thirdUserStack.topAnchor.constraint(equalTo: firstUserStack.bottomAnchor, constant: -75),
            thirdUserStack.leadingAnchor.constraint(equalTo: firstUserStack.trailingAnchor, constant: 30),
            
            thirdPointsStack.widthAnchor.constraint(equalToConstant: 70),
            thirdPointsStack.heightAnchor.constraint(equalToConstant: 34),
            
            thirdUserImage.widthAnchor.constraint(equalToConstant: 65),
            thirdUserImage.heightAnchor.constraint(equalToConstant: 77),
            
            podiumImage.widthAnchor.constraint(equalToConstant: 300),
            podiumImage.heightAnchor.constraint(equalToConstant: 275),
            podiumImage.topAnchor.constraint(equalTo: firstUserStack.bottomAnchor, constant: -30),
            podiumImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            tasksStack.topAnchor.constraint(equalTo: podiumImage.bottomAnchor),
            tasksStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tasksStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tasksStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
//
//            rankingTableView.topAnchor.constraint(equalTo: podiumImage.bottomAnchor, constant: 40),
//            rankingTableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
//            rankingTableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
        ])
    }
}
