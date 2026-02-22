//
//  Environment.swift
//  ViperChallange
//
//  Created by Çağatay Eğilmez on 22.02.2026.
//

import Foundation

/// Environment configuration sourced from `Info.plist`
enum Environment {

    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    static let rootURL: URL = {
        guard let rootURLstring = Environment.infoDictionary["API_URL"] as? String else {
            fatalError("Root URL not set in plist for this environment")
        }
        guard let url = URL(string: rootURLstring) else {
            fatalError("Root URL is invalid")
        }
        return url
    }()
}
