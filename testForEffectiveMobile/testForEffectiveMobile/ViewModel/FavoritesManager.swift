//
//  FavoritesManager.swift
//  testForEffectiveMobile
//
//  Created by Dmitrii Imaev on 30.05.2024.
//

import Foundation

final class FavoritesManager {
    
    private let favoritesKey = "favorites"
    private var observers: [FavoritesObserver] = []
    
    static let favoritesDidUpdateNotification = Notification.Name("favoritesDidUpdateNotification")
    
    func saveFavoriteVacancy(_ vacancy: Vacancy) {
        var favorites = loadFavoriteVacancies()
        if !favorites.contains(where: { $0.id == vacancy.id }) {
            favorites.append(vacancy)
            save(favorites)
            notifyObservers()
            NotificationCenter.default.post(name: FavoritesManager.favoritesDidUpdateNotification, object: nil)
        }
    }
    
    func isFavorite(vacancy: Vacancy) -> Bool {
        return loadFavoriteVacancies().contains(where: { $0.id == vacancy.id })
    }
    
    func removeFavoriteVacancy(_ vacancy: Vacancy) {
        var favorites = loadFavoriteVacancies()
        favorites.removeAll { $0.id == vacancy.id }
        save(favorites)
        notifyObservers()
        NotificationCenter.default.post(name: FavoritesManager.favoritesDidUpdateNotification, object: nil)
    }
    
    func loadFavoriteVacancies() -> [Vacancy] {
        if let data = UserDefaults.standard.data(forKey: favoritesKey),
           let favorites = try? JSONDecoder().decode([Vacancy].self, from: data) {
            return favorites
        }
        return []
    }
    
    private func save(_ vacancies: [Vacancy]) {
        if let data = try? JSONEncoder().encode(vacancies) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }
    
    func addObserver(_ observer: FavoritesObserver) {
        observers.append(observer)
    }
    
    func removeObserver(_ observer: FavoritesObserver) {
        observers.removeAll { $0 === observer }
    }
    
    func notifyObservers() {
        let count = loadFavoriteVacancies().count
        observers.forEach {
            $0.favoritesDidUpdate(count: count)
        }
    }
}
