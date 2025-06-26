//
//  TaskDetailsViewController.swift
//  chorecade
//
//  Created by Gabriel Kowaleski on 20/06/25.
//

import UIKit

class TaskDetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var task: Tasks?

    // MARK: - Components
    lazy var imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCellCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView.register(AddImageCollectionViewCell.self, forCellWithReuseIdentifier: "AddImageCell")
        collectionView.backgroundColor = .primaryPurple100
        return collectionView
    }()

    lazy var imagesPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 2
        pageControl.backgroundStyle = .minimal
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray
        pageControl.layer.cornerRadius = 12
        return pageControl
    }()

    lazy var taskTitleLabel = Components.getLabel(content: "Default Task", font: Fonts.titleConcludedTask, alignment: .center)

    lazy var authorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "defaultImage")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 43
        imageView.backgroundColor = UIColor.namedColors.randomElement()?.value
        imageView.clipsToBounds = true
        return imageView
    }()

    lazy var authorNameLabel = Components.getLabel(content: "Julian", font: Fonts.titleConcludedTask)
    lazy var dateLabel = Components.getLabel(content: "", font: Fonts.descriptionTask)

    lazy var detailsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authorNameLabel, dateLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    lazy var authorStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authorImageView, detailsStack])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()

    var images: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        imagesPageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
        setup()

        if let task = task {
            taskTitleLabel.text = task.category.title
            Task {
                let user = await Repository.createUserModel(byRecordID: task.user)
                authorNameLabel.text = user.nickname
                authorImageView.image = user.avatarHead
            }

            if let before = task.beforeImage {
                images.append(before)
            }
            if let after = task.afterImage {
                images.append(after)
            }

            if images.count < 2 {
                images.append(UIImage()) // Placeholder para célula de adicionar
            }

            imagesPageControl.numberOfPages = images.count
            imagesCollectionView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .primaryPurple300
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    @objc func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        imagesCollectionView.scrollToItem(at: IndexPath(item: current, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension TaskDetailsViewController: ViewCodeProtocol {
    func addSubviews() {
        view.addSubview(imagesCollectionView)
        view.addSubview(imagesPageControl)
        view.addSubview(taskTitleLabel)
        view.addSubview(authorStack)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            imagesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imagesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imagesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            imagesCollectionView.heightAnchor.constraint(equalToConstant: 400),

            imagesPageControl.topAnchor.constraint(equalTo: imagesCollectionView.bottomAnchor, constant: 8),
            imagesPageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            taskTitleLabel.topAnchor.constraint(equalTo: imagesPageControl.bottomAnchor, constant: 20),
            taskTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            authorStack.topAnchor.constraint(equalTo: taskTitleLabel.bottomAnchor, constant: 48),
            authorStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            authorStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            authorImageView.widthAnchor.constraint(equalToConstant: 86),
            authorImageView.heightAnchor.constraint(equalToConstant: 86)
        ])
    }
}
