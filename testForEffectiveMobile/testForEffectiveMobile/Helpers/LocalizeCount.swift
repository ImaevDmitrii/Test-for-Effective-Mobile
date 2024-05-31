//
//  LocalizePeopleCount.swift
//  testForEffectiveMobile
//
//  Created by Dmitrii Imaev on 30.05.2024.
//

import Foundation

final class LocalizeCount {
    static func localizePeopleCount(_ count: Int) -> String {
        let remainder100 = count % 100
        if remainder100 >= 11 && remainder100 <= 19 {
            return Localization.people
        }
        switch count % 10 {
        case 2, 3, 4:
            return Localization.peoples
        default:
            return Localization.people
        }
    }
    
    static func getVacancyText(for number: Int) -> String {
        let lastDigit = number % 10
        let lastTwoDigits = number % 100
        
        if lastTwoDigits >= 11 && lastTwoDigits <= 19 {
            return Localization.vacancies
        } else {
            switch lastDigit {
            case 1:
                return Localization.oneVacancy
            case 2, 3, 4:
                return Localization.vacancy
            default:
                return Localization.vacancies
            }
        }
    }
}
