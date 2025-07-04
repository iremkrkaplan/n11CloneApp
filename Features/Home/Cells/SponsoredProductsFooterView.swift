//
//  SponsoredProductsFooterView.swift
//  N11CloneApp
//
//  Created by irem karakaplan on 3.07.2025.
//

import UIKit

class SponsoredProductsFooterView: UICollectionReusableView {
    static let identifier = "SponsoredProductsFooterView"
    
    let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = .systemPurple
        pc.pageIndicatorTintColor = .systemGray4
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.isUserInteractionEnabled = false
        return pc
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(numberOfPages: Int) {
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = 0
    }
}
