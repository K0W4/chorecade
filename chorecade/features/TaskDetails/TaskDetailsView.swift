//
//  TaskDetailsView.swift
//  chorecade
//
//  Created by Gabriel Kowaleski on 20/06/25.
//

import UIKit

class TaskDetailsView: UIView {
    // MARK: - Components
//    let imageNames = ["before", "after"]
//
//    lazy var taskImageSlider: UIPageViewController = {
//        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//        pageVC.dataSource = self
//        return pageVC
//    }()
//    
//    let imageBefore: UIImageView = {
//        let imageView = UIImageView(image: UIImage(named: "before") ?? UIImage(named: "defaultImage"))
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.clipsToBounds = true
//        imageView.contentMode = .scaleAspectFill
//        return imageView
//    }()
//    
//    let imageAfter: UIImageView = {
//        let imageView = UIImageView(image: UIImage(named: "after") ?? UIImage(named: "defaultImage"))
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.clipsToBounds = true
//        imageView.contentMode = .scaleAspectFill
//        return imageView
//    }()

    lazy var sliderContainer: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 2
        return pageControl
    }()
    
    lazy var taskTitleLabel = Components.getLabel(content: "Default Task", font: Fonts.titleConcludedTask)
    
    lazy var authorImageView = UIImageView()
    
    lazy var authorNameLabel = UILabel()
    
    lazy var dateLabel = UILabel()

    lazy var commenterImageView = UIImageView()
    
    lazy var commentTextField = UITextField()

    lazy var contentStack: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [sliderContainer ,taskTitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        
    }
}

// MARK: - Extensions
extension TaskDetailsView: ViewCodeProtocol {
    func addSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(contentStack)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
}


extension TaskDetailsView: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = imageViewControllers.firstIndex(of: viewController), index > 0 else { return nil }
        return imageViewControllers[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = imageViewControllers.firstIndex(of: viewController), index < imageViewControllers.count - 1 else { return nil }
        return imageViewControllers[index + 1]
    }
}
