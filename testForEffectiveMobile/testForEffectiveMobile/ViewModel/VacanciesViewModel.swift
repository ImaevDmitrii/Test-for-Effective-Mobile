//
//  VacanciesViewModel.swift
//  testForEffectiveMobile
//
//  Created by Dmitrii Imaev on 30.05.2024.
//

import Foundation

final class VacanciesViewModel {
    
    private let networkService = NetworkService()
    private let favoritesManager = FavoritesManager()
    
    private(set) var offers: [Offer] = []
    private(set) var vacancies: [Vacancy] = []
    
    var displayedVacancies: [Vacancy] {
        return Array(vacancies.prefix(3))
    }
    
    var onUpdate: (() -> Void)?
    
    init() {
        loadData()
    }
    
    func loadData() {
        guard let data = jsonString.data(using: .utf8),
              let dataModel = networkService.parseJSON(from: data) else {
            return
        }
        self.offers = dataModel.offers
        let favoriteVacancies = favoritesManager.loadFavoriteVacancies()
        self.vacancies = dataModel.vacancies.map { vacancy in
            var updatedVacancy = vacancy
            updatedVacancy.isFavorite = favoriteVacancies.contains(where: { $0.id == updatedVacancy.id })
            return updatedVacancy
        }
        self.onUpdate?()
    }
    
    func getVacancy(at index: Int) -> Vacancy {
        return displayedVacancies[index]
    }
    
    func toggleFavorite(for vacancy: Vacancy) {
        if let index = vacancies.firstIndex(where: { $0.id == vacancy.id }) {
            vacancies[index].isFavorite.toggle()
            if vacancies[index].isFavorite {
                favoritesManager.saveFavoriteVacancy(vacancies[index])
            } else {
                favoritesManager.removeFavoriteVacancy(vacancies[index])
            }
            onUpdate?()
            favoritesManager.notifyObservers()
        }
    }
}
