//
//  TaskDetailsViewController.swift
//  chorecade
//
//  Created by Gabriel Kowaleski on 20/06/25.
//

import UIKit

class TaskDetailsViewController: UIViewController {
    // MARK: - Components
    lazy var imagesScrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        return scrollView
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
    
    lazy var authorImageView = UIImageView()
    
    lazy var authorNameLabel = Components.getLabel(content: "Julian", font: Fonts.titleConcludedTask)
    
    lazy var dateLabel = Components.getLabel(content: "10 June 2025 at 09:41", font: Fonts.descriptionTask)
    
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
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesScrollView.backgroundColor = .background
        imagesPageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
        configureScrollView()
        setup()
    }
    
    @objc func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        imagesScrollView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(current), y: 0), animated: true)
    }
    
    func configureScrollView() {
        imagesScrollView.contentSize = CGSize(width: view.frame.width * 2, height: view.frame.height)
        imagesScrollView.isPagingEnabled = true
        let images: [UIImage] = [UIImage(named: "defaultImage")!, UIImage(named: "defaultImage")!]
        
        for i in 0..<2 {
            let page = UIView(frame: CGRect(x: (view.frame.width * CGFloat(i)) + 16, y: 130, width: 360, height: 400))
            let imageView = UIImageView(image: images[i])
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.frame = CGRect(x: 0, y: 0, width: 360, height: 400)
            page.addSubview(imageView)
            imagesScrollView.addSubview(page)
        }
    }
}

// MARK: - Extensions
extension TaskDetailsViewController: ViewCodeProtocol {
    func addSubviews() {
        view.addSubview(imagesScrollView)
        view.addSubview(imagesPageControl)
        view.addSubview(taskTitleLabel)
        view.addSubview(detailsStack)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imagesScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            imagesScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imagesScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imagesScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imagesPageControl.widthAnchor.constraint(equalToConstant: 48),
            imagesPageControl.heightAnchor.constraint(equalToConstant: 24),
            imagesPageControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 496),
            imagesPageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            taskTitleLabel.topAnchor.constraint(equalTo: imagesPageControl.bottomAnchor, constant: 20),
            taskTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            detailsStack.topAnchor.constraint(equalTo: taskTitleLabel.bottomAnchor, constant: 48),
            detailsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            detailsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
}

extension TaskDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        imagesPageControl.currentPage = Int(pageIndex)
    }
}
