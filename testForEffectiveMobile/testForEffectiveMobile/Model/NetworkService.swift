//
//  NetworkService.swift
//  testForEffectiveMobile
//
//  Created by Dmitrii Imaev on 30.05.2024.
//

import Foundation

final class NetworkService {
    
    func parseJSON(from data: Data) -> DataModel? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let dataModel = try decoder.decode(DataModel.self, from: data)
            return dataModel
        } catch {
            return nil
        }
    }
}
