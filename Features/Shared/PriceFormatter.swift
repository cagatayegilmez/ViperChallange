//
//  PriceFormatter.swift
//  ViperChallange
//
//  Created by Çağatay Eğilmez on 23.02.2026.
//

import Foundation

enum PriceFormatter {

    static func format(_ price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "TRY"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: price)) ?? "\(price)"
    }
}
