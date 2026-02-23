//
//  ProductListInteractor.swift
//  ViperChallange
//
//  Created by Çağatay Eğilmez on 23.02.2026.
//

import Foundation

struct ProductListDataSnapshot {

    let sponsored: [SponsoredProduct]
    let products: [ListProduct]
    let canLoadMore: Bool
}

final class ProductListInteractor: ProductListInteractorProtocol {

    weak var output: ProductListInteractorOutput?

    private let repo: ProductRepostoryProtocol

    private var currentPage: Int = 1
    private var nextPage: Int?
    private var isLoading: Bool = false

    private var sponsoredCache: [SponsoredProduct] = []
    private var productsCache: [ListProduct] = []

    private var task: Task<Void, Never>?

    init(repo: ProductRepostoryProtocol) {
        self.repo = repo
    }

    func loadInitial() {
        reset()
        fetch(page: 1, isNext: false)
    }

    func refresh() {
        loadInitial()
    }

    func loadNextPage() {
        guard !isLoading, let nextPage else {
            return
        }

        fetch(page: nextPage, isNext: true)
    }

    private func reset() {
        task?.cancel()
        currentPage = 1
        nextPage = nil
        isLoading = false
        sponsoredCache = []
        productsCache = []
    }

    private func fetch(page: Int, isNext: Bool) {
        isLoading = true
        task?.cancel()

        task = Task { [weak self] in
            guard let self else {
                return
            }

            do {
                let response = try await repo.fetchListing(page: page)
                let np = response.nextPage.flatMap(Int.init)

                if isNext == false {
                    self.sponsoredCache = response.sponsoredProducts
                    self.productsCache = response.products
                } else {
                    self.productsCache.append(contentsOf: response.products)
                }

                self.currentPage = page
                self.nextPage = np
                self.isLoading = false

                let snapshot = ProductListDataSnapshot(sponsored: self.sponsoredCache,
                                                       products: self.productsCache,
                                                       canLoadMore: np != nil)

                await MainActor.run {
                    if isNext {
                        self.output?.didLoadNext(result: .success(snapshot))
                    } else {
                        self.output?.didLoadInitial(result: .success(snapshot))
                    }
                }
            } catch {
                self.isLoading = false
                await MainActor.run {
                    if isNext {
                        self.output?.didLoadNext(result: .failure(error))
                    } else {
                        self.output?.didLoadInitial(result: .failure(error))
                    }
                }
            }
        }
    }
}
