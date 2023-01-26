//
//  GFDataLoadingVC.swift
//  Followers
//
//  Created by Rashad Surratt on 1/23/23.
//

import UIKit
import SafariServices

class GFDataLoadingVC: UIViewController {
    
    var containerView: UIView!
    
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha           = 0
        
        UIView.animate(withDuration: 0.25) { self.containerView.alpha = 0.8 }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints =  false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
    }
    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
    
    func showEmptyStateViewWithAttributedString(with message: String, userName: String, in view: UIView) {
        let attributedString = NSMutableAttributedString(string: message)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 30, weight: .heavy), range: NSRange(location: 0, length: userName.count))
        attributedString.addAttribute(.foregroundColor, value: UIColor.systemPurple, range: NSRange(location: 0, length: userName.count))
        let emptyStateView = GFEmptyStateView(multiFontMessage: attributedString)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
