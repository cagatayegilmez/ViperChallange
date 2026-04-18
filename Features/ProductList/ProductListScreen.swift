//
//  ProductListScreen.swift
//  ViperChallange
//
//  Created by Çağatay Eğilmez on 23.02.2026.
//

import SwiftUI

struct ProductListScreen: View {
    @State var model: ProductListUIModel
    @State private var searchText = ""

    let onSelectProduct: (Int) -> Void
    let onReachEnd: () -> Void
    let onRefresh: () -> Void

    private var filteredProducts: [ProductCardViewModel] {
        let query = searchText.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else {
            return model.products
        }

        return model.products.filter {
            $0.title.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        switch model.state {
        case .idle, .loading:
            if model.products.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                contentScrollView
            }
        case .error(let message):
            if model.products.isEmpty {
                ErrorStateView(message: message, onRetry: onRefresh)
            } else {
                // Error during pagination — keep showing existing data.
                contentScrollView
            }
        case .loaded:
            contentScrollView
        }
    }

    // MARK: - Main scroll content

    private var contentScrollView: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                searchBarView
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)

                if !model.sponsored.isEmpty {
                    sponsoredCarousel
                }

                if filteredProducts.isEmpty {
                    if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
                        emptyProductsView
                    } else {
                        EmptySearchView(query: searchText)
                    }
                } else {
                    productGrid
                }

                // Bottom spinner while fetching next page
                if model.isPaginating {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .refreshable { onRefresh() }
    }

    // MARK: - Search Bar

    private var searchBarView: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField("Ürün ara...", text: $searchText)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .submitLabel(.search)
            if !searchText.isEmpty {
                Button { searchText = "" } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    // MARK: - Sponsored Carousel

    private var sponsoredCarousel: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Sponsorlu")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 12)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(model.sponsored) { item in
                        SponsoredCard(item: item)
                            .onTapGesture { onSelectProduct(item.id) }
                    }
                }
                .padding(.horizontal, 12)
            }
        }
        .padding(.bottom, 16)
    }

    // MARK: - Product Grid

    private var productGrid: some View {
        let columns = [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)]
        return LazyVGrid(columns: columns, spacing: 8) {
            ForEach(Array(filteredProducts.enumerated()), id: \.element.id) { index, product in
                ProductCard(item: product)
                    .onTapGesture { onSelectProduct(product.id) }
                    .onAppear {
                        // Only paginate when showing the full unfiltered list.
                        if searchText.trimmingCharacters(in: .whitespaces).isEmpty,
                           index >= filteredProducts.count - 4 {
                            onReachEnd()
                        }
                    }
            }
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 16)
    }

    // MARK: - Empty States

    private var emptyProductsView: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 44))
                .foregroundStyle(.secondary)
            Text("Ürün bulunamadı")
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}

// MARK: - Sponsored Card (horizontal carousel item)

private struct SponsoredCard: View {
    let item: ProductCardViewModel
    private let size: CGFloat = 150

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            AsyncImage(url: item.imageURL) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    Color(.systemGray5)
                }
            }
            .frame(width: size, height: size)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 8))

            Text(item.title)
                .font(.caption)
                .lineLimit(2)
                .frame(width: size, alignment: .leading)

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(item.discountedPriceText)
                    .font(.footnote.bold())
                Text(item.priceText)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .strikethrough()
            }

            if item.discountText != "%0" {
                DiscountTag(text: item.discountText)
            }
        }
        .frame(width: size)
        .padding(8)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.07), radius: 4, y: 2)
    }
}

// MARK: - Product Grid Card

private struct ProductCard: View {
    let item: ProductCardViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Product image with discount badge overlaid top-right
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: item.imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    default:
                        Color(.systemGray5)
                    }
                }
                .aspectRatio(1, contentMode: .fill)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 8))

                if item.discountText != "%0" {
                    DiscountTag(text: item.discountText)
                        .padding(6)
                }
            }

            Text(item.title)
                .font(.caption)
                .lineLimit(2)
                .padding(.horizontal, 4)

            if item.rateText != "0.0" {
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 9))
                        .foregroundStyle(.yellow)
                    Text(item.rateText)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 4)
            }

            if let seller = item.sellerName, !seller.isEmpty {
                Text(seller)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .padding(.horizontal, 4)
            }

            Spacer(minLength: 0)

            VStack(alignment: .leading, spacing: 1) {
                Text(item.priceText)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .strikethrough()
                Text(item.discountedPriceText)
                    .font(.subheadline.bold())
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 8)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.07), radius: 4, y: 2)
    }
}

// MARK: - Discount Tag

private struct DiscountTag: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.caption2.bold())
            .foregroundStyle(.white)
            .padding(.horizontal, 5)
            .padding(.vertical, 2)
            .background(Color.orange)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

// MARK: - Empty Search Result

private struct EmptySearchView: View {
    let query: String
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 44))
                .foregroundStyle(.secondary)
            Text("Sonuç bulunamadı")
                .font(.headline)
            Text("\"\(query)\" için ürün bulunamadı.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
        .padding(.horizontal, 24)
    }
}

// MARK: - Error State

private struct ErrorStateView: View {
    let message: String
    let onRetry: () -> Void
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 44))
                .foregroundStyle(.red)
            Text("Bir hata oluştu")
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button("Tekrar Dene", action: onRetry)
                .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
