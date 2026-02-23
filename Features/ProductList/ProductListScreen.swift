//
//  ProductListScreen.swift
//  ViperChallange
//
//  Created by Çağatay Eğilmez on 23.02.2026.
//

import SwiftUI

struct ProductListScreen: View {
    @State var model: ProductListUIModel

    let onSelectProduct: (Int) -> Void
    let onReachEnd: () -> Void
    let onRefresh: () -> Void

    private let grid = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack {
        }
    }
}
