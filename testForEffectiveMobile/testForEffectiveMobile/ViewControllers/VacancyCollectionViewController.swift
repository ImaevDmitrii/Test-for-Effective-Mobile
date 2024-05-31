//
//  VacancyCollectionViewController.swift
//  testForEffectiveMobile
//
//  Created by Dmitrii Imaev on 30.05.2024.
//

import UIKit

final class VacancyCollectionViewController: UICollectionViewController, FavoritesObserver {
    
    private let viewModel = VacanciesViewModel()
    private var favorites: [Vacancy] = []
    private let favoritesManager = FavoritesManager()
    
    private var coordinator: NavigationCoordinator {
        NavigationCoordinator(navigationController: navigationController)
    }
    
    private let vacanciesCellId = String(describing: VacancyCollectionViewCell.self)
    private let recommendationCellId = String(describing: RecommendationCollectionViewCell.self)
    private let headerId = String(describing: HeaderCollectionReusableView.self)
    private let searchHeaderId = String(describing: SearchHeaderCollectionReusableView.self)
    private let footerButtonId = String(describing: MoreVacancyButtonCollectionReusableView.self)
    
    private let numberOfSections = 2
    private let padding: CGFloat = 18
    private let interGroupSpacing: CGFloat = 8
    
    init() {
        super.init(collectionViewLayout: UICollectionViewLayout())
        self.collectionView.collectionViewLayout = createLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        favoritesManager.addObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .black
        idRegister()
        viewModel.onUpdate = { [weak self] in
            self?.collectionView.reloadData()
            self?.loadFavorites()
        }
        viewModel.loadData()
    }
    
    deinit {
        favoritesManager.removeObserver(self)
    }
    
    private func idRegister() {
        collectionView.register(VacancyCollectionViewCell.self, forCellWithReuseIdentifier: vacanciesCellId)
        collectionView.register(RecommendationCollectionViewCell.self, forCellWithReuseIdentifier: recommendationCellId)
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(SearchHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: searchHeaderId)
        collectionView.register(MoreVacancyButtonCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerButtonId)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.createRecommendationSection()
            case 1:
                return self.createVacancySection()
            default:
                return nil
            }
        }
    }
    
    private func createRecommendationSection() -> NSCollectionLayoutSection {
        let recommendationHeightSize: CGFloat = 120
        let recommendationWidhtSize: CGFloat = 132
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(recommendationWidhtSize), heightDimension: .absolute(recommendationHeightSize))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(recommendationWidhtSize), heightDimension: .absolute(recommendationHeightSize))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = interGroupSpacing
        section.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
        
        let sectionHeader = createSearchHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private func createVacancySection() -> NSCollectionLayoutSection {
        let vacanciesSize: CGFloat = 200
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(vacanciesSize))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(vacanciesSize))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = interGroupSpacing
        section.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        let sectionFooter = createSectionFooter()
        section.boundarySupplementaryItems.append(sectionFooter)
        
        return section
    }
    
    private func createSearchHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        return sectionHeader
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(24))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        return sectionHeader
    }
    
    private func createSectionFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(48))
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom)
        
        return sectionFooter
    }
    
    func favoritesDidUpdate(count: Int) {
        loadFavorites()
    }
    
    private func loadFavorites() {
        favorites = favoritesManager.loadFavoriteVacancies()
        collectionView.reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension VacancyCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        numberOfSections
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.offers.count
        } else {
            return viewModel.displayedVacancies.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recommendationCellId, for: indexPath) as? RecommendationCollectionViewCell else { return UICollectionViewCell() }
            let offer = viewModel.offers[indexPath.item]
            cell.configure(with: offer)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: vacanciesCellId, for: indexPath) as? VacancyCollectionViewCell else { return UICollectionViewCell() }
            var vacancy = viewModel.getVacancy(at: indexPath.item)
            vacancy.isFavorite = favoritesManager.isFavorite(vacancy: vacancy)
            cell.configure(with: vacancy)
            cell.favoriteButtonTapped = { [weak self] in
                self?.viewModel.toggleFavorite(for: vacancy)
            }
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vacancy = viewModel.getVacancy(at: indexPath.item)
            coordinator.showDetailVacancyVC(vacancy: vacancy)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if indexPath.section == 0 {
                guard let searchHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: searchHeaderId, for: indexPath) as? SearchHeaderCollectionReusableView else { return UICollectionReusableView() }
                return searchHeader
            } else {
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? HeaderCollectionReusableView else { return UICollectionReusableView() }
                header.configureAsVacanciesHeader(text: Localization.vacancyForYou)
                return header
            }
        } else if kind == UICollectionView.elementKindSectionFooter {
            guard let footerButton = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerButtonId, for: indexPath) as? MoreVacancyButtonCollectionReusableView else { return UICollectionReusableView() }
            let numberOfVacancies = viewModel.vacancies.count
            footerButton.configure(with: numberOfVacancies)
            return footerButton
        }
        return UICollectionReusableView()
    }
}
