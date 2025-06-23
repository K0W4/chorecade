//
//  TaskDetailsViewController.swift
//  chorecade
//
//  Created by Gabriel Kowaleski on 20/06/25.
//

import UIKit

class TaskDetailsViewController: UIViewController {
    // MARK: - Components
    lazy var scrollView = UIScrollView()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 2
        pageControl.backgroundColor = .primaryPurple300
        return pageControl
    }()
    
    // MARK: - View
    lazy var taskDetailsView: TaskDetailsView = {
        let view = TaskDetailsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
        scrollView.backgroundColor = .systemRed
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageControl.frame = CGRect(x: 10, y: view.frame.height - 100, width: view.frame.width - 20, height: 70)
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 100)
        
        if scrollView.subviews.count == 2 {
            configureScrollView()
        }
    }
    
    @objc func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(current), y: 0), animated: true)
    }
    
    func configureScrollView() {
        scrollView.contentSize = CGSize(width: view.frame.width * 2, height: view.frame.height)
        scrollView.isPagingEnabled = true
        let colors: [UIColor] = [.systemBlue, .systemGreen]
        
        for i in 0..<2 {
            let page = UIView(frame: CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height))
            page.backgroundColor = colors[i]
            scrollView.addSubview(page)
        }
    }
}

// MARK: - Extensions
extension TaskDetailsViewController: ViewCodeProtocol {
    func addSubviews() {
        view.addSubview(scrollView)
        view.addSubview(pageControl)
    }
    
    func setupConstraints() {
        
    }
}
