//
//  RankingEmptyState.swift
//  chorecade
//
//  Created by Carolina Silva dos Santos on 21/06/25.
//

import UIKit

class RankingEmptyStateView: UIView {
    // MARK: Components
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Jersey10-Regular", size: 48)
        label.textAlignment = .center
        label.textColor = .black
        return label
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
    
    private lazy var shareRankingButton: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .primaryPurple
        container.layer.cornerRadius = 16
        container.isUserInteractionEnabled = true

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Share Ranking"
        label.font = UIFont(name: "Jersey10-Regular", size: 16)
        label.textColor = .black

        let imageView = UIImageView(image: UIImage(systemName: "square.and.arrow.up"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black

        let stack = UIStackView(arrangedSubviews: [label, imageView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        container.addSubview(stack)


        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 40),
            container.widthAnchor.constraint(equalToConstant: 136),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: container.topAnchor),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 15),
            imageView.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        imageView.isUserInteractionEnabled = false
        label.isUserInteractionEnabled = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleShareButton))

        container.addGestureRecognizer(tap)

        return container
    }()
    
    @objc func handleShareButton() {
        print("Share tapped")
    }
    
    private lazy var stack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [
            titleLabel, shareRankingButton, descriptionLabel,
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.backgroundColor = .background
        stack.distribution = .fill
        stack.alignment = .center
        stack.setCustomSpacing(24, after: titleLabel)
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

    var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }

    var descriptionText: String? {
        didSet {
            descriptionLabel.text = descriptionText
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RankingEmptyStateView: ViewCodeProtocol {
    func setup() {
        addSubviews()
        setupConstraints()
    }

    func addSubviews() {
        addSubview(stack)
        addSubview(podiumStack)

    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 33),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),

            podiumStack.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 48),
            podiumStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            podiumStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
        ])
    }
}
