//
//  ProductListResponse.swift
//  ViperChallange
//
//  Created by Çağatay Eğilmez on 22.02.2026.
//

import Foundation

struct ProductListResponse: Decodable {

    let page: String
    let nextPage: String?
    let published_at: String
    let sponsoredProducts: [SponsoredProduct]
    let products: [ListProduct]

    var publishDate: Date {
        Self.iso8601WithFractional.date(from: published_at)
        ?? Self.iso8601NoFractional.date(from: published_at)
        ?? .distantPast
    }

    private static let iso8601WithFractional: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        formatter.timeZone = TimeZone(secondsFromGMT: .zero)
        return formatter
    }()

    private static let iso8601NoFractional: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        formatter.timeZone = TimeZone(secondsFromGMT: .zero)
        return formatter
    }()
}
