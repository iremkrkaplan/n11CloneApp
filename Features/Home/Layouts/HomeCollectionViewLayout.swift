// HomeCollectionViewLayout.swift
import Foundation
import UIKit


class HomeCollectionViewLayout {

    private init() {}

 
    static func createLayout(dataSource: UICollectionViewDataSource) -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in

            guard let homeVCDataSource = dataSource as? HomeViewController else {
                print("Layout: DataSource HomeViewController değil. Section tipi belirlenemiyor.")
                return nil
            }

            let sponsoredSectionExists = !homeVCDataSource.sponsoredProducts.isEmpty

            var sectionLayoutType: HomeSectionLayoutType? = nil
            if sectionIndex == 0 && sponsoredSectionExists {
                sectionLayoutType = .sponsoredProducts
            } else if sectionIndex == (sponsoredSectionExists ? 1 : 0) {
                sectionLayoutType = .normalProducts
            }

            switch sectionLayoutType {
            case .sponsoredProducts:
                return createSponsoredProductsSection(environment: layoutEnvironment)
            case .normalProducts:
                return createNormalProductsSection(environment: layoutEnvironment)
            case .none:
                print("Layout: Section index \(sectionIndex) için layout tipi belirlenemedi.")
                return nil
            }
        }
    }

    private static func createSponsoredProductsSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        let groupWidth = environment.container.contentSize.width * 0.9
        let groupHeight: CGFloat = 220
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(groupWidth),
                                               heightDimension: .absolute(groupHeight))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous

        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 20, trailing: 16)
        section.interGroupSpacing = 12

        return section
    }

    private static func createNormalProductsSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .estimated(400))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(itemSize.heightDimension.dimension))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none

        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 6, bottom: 10, trailing: 6)
        section.interGroupSpacing = 10

        return section
    }
}
