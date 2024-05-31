//
//  FavoriteCollectionViewController.swift
//  testForEffectiveMobile
//
//  Created by Dmitrii Imaev on 30.05.2024.
//

import UIKit

final class FavoritesCollectionViewController: UICollectionViewController, FavoritesObserver {
    
    private var coordinator: NavigationCoordinator {
        NavigationCoordinator(navigationController: navigationController)
    }
    
    private let cellId = String(describing: VacancyCollectionViewCell.self)
    private let headerId = String(describing: HeaderCollectionReusableView.self)
    private let secondaryHeaderId = String(describing: SecondaryHeaderCollectionReusableView.self)
    
    private let mainHeaderElementKind = "main-header-element-kind"
    private let secondaryHeaderElementKind = "secondary-header-element-kind"
    
    private var favorites: [Vacancy] = []
    private let favoritesManager = FavoritesManager()
    private let viewModel = VacanciesViewModel()
    
    private let numberOfSections = 1
    
    init() {
        super.init(collectionViewLayout: UICollectionViewLayout())
        self.collectionView.collectionViewLayout = createLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        favoritesManager.addObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }
    
    deinit {
        favoritesManager.removeObserver(self)
    }
    
    private func setup() {
        collectionView.backgroundColor  = .black
        
        collectionView.register(VacancyCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: mainHeaderElementKind, withReuseIdentifier: headerId)
        collectionView.register(SecondaryHeaderCollectionReusableView.self, forSupplementaryViewOfKind: secondaryHeaderElementKind, withReuseIdentifier: secondaryHeaderId)
        
        viewModel.onUpdate = { [weak self] in
            self?.loadFavorites()
        }
    }
    
    private func loadFavorites() {
        favorites = favoritesManager.loadFavoriteVacancies()
        collectionView.reloadData()
    }
    
    private func createVacancySection() -> NSCollectionLayoutSection {
        let interGroupSpacing: CGFloat = 8
        let padding: CGFloat = 18
        let size: CGFloat = 200
        let topPadiing: CGFloat = 50
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(size))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(size))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = interGroupSpacing
        section.contentInsets = NSDirectionalEdgeInsets(top: topPadiing, leading: padding, bottom: padding, trailing: padding)
        
        let sectionHeader = createSectionHeader()
        let secondaryHeader = createSecondaryHeader()
        
        section.boundarySupplementaryItems = [sectionHeader, secondaryHeader]
        
        return section
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment -> NSCollectionLayoutSection? in
            self.createVacancySection()
        }
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(24))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: mainHeaderElementKind,
            alignment: .top)
        
        return sectionHeader
    }
    
    private func createSecondaryHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(17))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: secondaryHeaderElementKind,
            alignment: .top)
        
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0)
        
        return sectionHeader
    }
    
    func favoritesDidUpdate(count: Int) {
        loadFavorites()
    }
}

// MARK: UICollectionViewDataSource
extension FavoritesCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        numberOfSections
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favorites.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? VacancyCollectionViewCell else { return UICollectionViewCell() }
        var vacancy = favorites[indexPath.item]
        vacancy.isFavorite = favoritesManager.isFavorite(vacancy: vacancy)
        cell.configure(with: vacancy)
        cell.favoriteButtonTapped = { [weak self] in
            self?.viewModel.toggleFavorite(for: vacancy)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vacancy = viewModel.getVacancy(at: indexPath.item)
        coordinator.showDetailVacancyVC(vacancy: vacancy)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == mainHeaderElementKind {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? HeaderCollectionReusableView else { return UICollectionReusableView() }
            header.configureAsVacanciesHeader(text: Localization.favorites)
            return header
        } else if kind == secondaryHeaderElementKind {
            guard let secondaryHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: secondaryHeaderId, for: indexPath) as? SecondaryHeaderCollectionReusableView else { return UICollectionReusableView() }
            secondaryHeader.configureAsSecondaryHeader(count: favorites.count)
            return secondaryHeader
        }
        return UICollectionReusableView()
    }
}
