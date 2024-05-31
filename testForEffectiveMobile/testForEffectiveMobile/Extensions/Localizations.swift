//
//  Localization.swift
//  testForEffectiveMobile
//
//  Created by Dmitrii Imaev on 30.05.2024.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

struct Localization {
    static let login = "login".localized
    static let searchJob = "search_job".localized
    static let email = "email".localized
    static let continueText = "continue".localized
    static let loginWithPassword = "login_with_password".localized
    static let invalidEmailError = "invalid_email_error".localized
    static let searchEmployee = "search_employee".localized
    static let jobDescription = "job_description".localized
    static let iSearchEmployee = "I_search_employee".localized
    static let codeSent = "codeSent".localized
    static let codeVerificationDescription = "code_verification_description".localized
    static let confirm = "confirm".localized
    static let reply = "reply".localized
    static let published = "published".localized
    static let lokingNow = "loking_now".localized
    static let people = "people".localized
    static let peoples = "peoples".localized
    static let position = "position".localized
    static let keywords = "keywords".localized
    static let vacancyForYou = "vacancy_for_you".localized
    static let more = "more".localized
    static let vacancy = "vacancy".localized
    static let oneVacancy = "oneVacancy".localized
    static let vacancies = "vacancies".localized
    static let back = "back".localized
    static let yourTasks = "yourTasks".localized
    static let askQuestion = "askQuestion".localized
    static let receivedWithResponse = "receivedWithResponse".localized
    static let respond = "respond".localized
    static let requiredExperience = "requiredExperience".localized
    static let appliedNumberText = "appliedNumberText".localized
    static let lookingNumberText = "lookingNumberText".localized
    static let companyText = "companyText".localized
    static let removeFromFavorites = "removeFromFavorites".localized
    static let addToFavorites = "addToFavorites".localized
    static let search = "search".localized
    static let favorites = "favorites".localized
    static let responses = "responses".localized
    static let messages = "messages".localized
    static let profile = "profile".localized
}
