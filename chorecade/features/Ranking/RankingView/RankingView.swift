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
    var tasksByGroup: [Tasks] = []
    
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
    
    // MARK: - Verificar
    lazy var groupSelector: GroupSelector = {
        let groupSelector = GroupSelector()
        groupSelector.translatesAutoresizingMaskIntoConstraints = false
        groupSelector.onGroupSelected = { [weak self] selectedGroup in
            guard let self = self else { return }
            self.currentSelectedGroup = selectedGroup
            Repository.currentGroup = selectedGroup
          
            Task {
                var tasks: [Tasks] = []
                tasks = selectedGroup.tasks
                DispatchQueue.main.async {
                    self.tasksByGroup = tasks
                    self.tasksTableView.reloadData()
                }
            }
        }
        return groupSelector
    }()
    
    lazy var tasksTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TaskListTableViewCell.self, forCellReuseIdentifier: "taskList-cell")
        tableView.register(EmptyTableViewCell.self, forCellReuseIdentifier: "empty-list-cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        return tableView
    }()
    // MARK: - Verificar
    
    lazy var shareRankingButton: UIButton = {
        let button = UIButton(configuration: .filled(), primaryAction: nil)
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .primaryPurple
        config.baseForegroundColor = .black
        config.title = "Share Ranking"
        config.attributedTitle = AttributedString("Share Ranking", attributes: AttributeContainer([
            .font: UIFont(name: "Jersey10-Regular", size: 16)!
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
    
    private lazy var descriptionLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.nameTasksCategories
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black50
        return label
    }()
    
    
    @objc func handleShareButton() {
        print("Share tapped")
    }
    
    private lazy var stack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [
            shareRankingButton, descriptionLabel,
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.backgroundColor = .background
        stack.distribution = .fill
        stack.alignment = .center
        stack.setCustomSpacing(48, after: shareRankingButton)
        return stack
    }()
    
    private lazy var pointsLabel = Components.getLabel(content: "0 points", font: Fonts.points, alignment: .center)
    
    private lazy var pointsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [pointsLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .yellowPoints
        stackView.alignment = .center
        stackView.layer.cornerRadius = 16
        return stackView
    }()
    
    private lazy var userNamelabel = Components.getLabel(content: "Bibi18", font: Fonts.nameTasksCategories, alignment: .center)
    
    private lazy var crownImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "crown")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var singleUserImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "defaultImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var podiumImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "podium")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var cardView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .primaryPurple100
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var podiumStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [pointsStack, userNamelabel, crownImage, singleUserImage, podiumImage, cardView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.setCustomSpacing(7, after: pointsStack)
        stackView.setCustomSpacing(8, after: userNamelabel)
        stackView.setCustomSpacing(3, after: crownImage)
        stackView.setCustomSpacing(3, after: singleUserImage)
        stackView.setCustomSpacing(0, after: podiumImage)
        
        NSLayoutConstraint.activate([
            pointsStack.widthAnchor.constraint(equalToConstant: 62),
            pointsStack.heightAnchor.constraint(equalToConstant: 34),
            singleUserImage.heightAnchor.constraint(equalToConstant: 77),
            singleUserImage.widthAnchor.constraint(equalToConstant: 64.84),
            cardView.topAnchor.constraint(equalTo: podiumImage.bottomAnchor),
        ])
        return stackView
    }()

    var descriptionText: String? {
        didSet {
            descriptionLabel.text = descriptionText
        }
    }
    
    // MARK: - Closure
    var onAddTaskButtonTaped: (() -> Void)?
    var onTaskSelected: ((Tasks) -> Void)?

    // MARK: - Functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension RankingView: ViewCodeProtocol {
    func setup() {
        addSubviews()
        setupConstraints()
    }

    func addSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(groupSelector)
        contentView.addSubview(shareRankingButton)
//        contentView.addSubview(podiumStack)

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
            
            groupSelector.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 83),
            groupSelector.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            shareRankingButton.widthAnchor.constraint(equalToConstant: 136),
            shareRankingButton.heightAnchor.constraint(equalToConstant: 40),
            shareRankingButton.topAnchor.constraint(equalTo: groupSelector.bottomAnchor, constant: 16),
            shareRankingButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
//
//            podiumStack.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 48),
//            podiumStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
//            podiumStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
        ])
    }
}
