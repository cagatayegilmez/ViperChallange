//
//  ProductListPresenter.swift
//  ViperChallange
//
//  Created by Çağatay Eğilmez on 23.02.2026.
//

import Foundation

struct ProductListViewModel: Equatable {

    var state: ViewState
    var sponsored: [ProductCardViewModel]
    var products: [ProductCardViewModel]
    var isPaginating: Bool
    var canLoadMore: Bool
    var errorMessage: String?
}

@MainActor
@Observable
final class ProductListPresenter: ProductListPresenterProtocol {

    weak var view: ProductListViewProtocol?
    var interactor: ProductListInteractorProtocol!
    var router: ProductListRoutingProtocol!

    private var current = ProductListViewModel(state: .idle,
                                               sponsored: [],
                                               products: [],
                                               isPaginating: false,
                                               canLoadMore: false,
                                               errorMessage: nil)

    func viewDidLoad() {
        current.state = .loading
        current.errorMessage = nil
        view?.render(current)
        interactor.loadInitial()
    }

    func didPullToRefresh() {
        current.state = .loading
        current.errorMessage = nil
        view?.render(current)
        interactor.refresh()
    }

    func didReachListEnd() {
        guard current.canLoadMore, !current.isPaginating else {
            return
        }

        current.isPaginating = true
        view?.render(current)
        interactor.loadNextPage()
    }

    func didSelectProduct(id: Int) {
        router.routeToDetail(productId: id, from: view as AnyObject?)
    }
}

extension ProductListPresenter: ProductListInteractorOutput {

    func didLoadInitial(result: Result<ProductListDataSnapshot, Error>) {
        switch result {
        case .success(let snap):
            current.state = .loaded
            current.isPaginating = false
            current.canLoadMore = snap.canLoadMore
            current.errorMessage = nil

            current.sponsored = snap.sponsored.map {
                ProductCardViewModel(id: $0.id,
                                     title: $0.title,
                                     imageURL: $0.imageUrl,
                                     priceText: PriceFormatter.format($0.price),
                                     discountedPriceText: PriceFormatter.format($0.instantDiscountPrice),
                                     discountText: "%\($0.discountPercent)",
                                     rateText: String(format: "%.1f", $0.rate ?? 0.0),
                                     sellerName: "")
            }

            current.products = snap.products.map {
                ProductCardViewModel(id: $0.id,
                                     title: $0.title,
                                     imageURL: $0.imageUrl,
                                     priceText: PriceFormatter.format($0.price),
                                     discountedPriceText: PriceFormatter.format($0.instantDiscountPrice),
                                     discountText: "%\($0.discountPercent)",
                                     rateText: String(format: "%.1f", $0.rate),
                                     sellerName: $0.sellerName)
            }

            view?.render(current)

        case .failure(let error):
            current.state = .error(message: error.localizedDescription)
            current.isPaginating = false
            current.errorMessage = error.localizedDescription
            view?.render(current)
        }
    }

    func didLoadNext(result: Result<ProductListDataSnapshot, Error>) {
        switch result {
        case .success(let snap):
            current.state = .loaded
            current.isPaginating = false
            current.canLoadMore = snap.canLoadMore
            current.errorMessage = nil

            current.products = snap.products.map {
                ProductCardViewModel(
                    id: $0.id,
                    title: $0.title,
                    imageURL: $0.imageUrl,
                    priceText: PriceFormatter.format($0.price),
                    discountedPriceText: PriceFormatter.format($0.instantDiscountPrice),
                    discountText: "%\($0.discountPercent)",
                    rateText: String(format: "%.1f", $0.rate),
                    sellerName: $0.sellerName
                )
            }

            view?.render(current)

        case .failure(let error):
            current.isPaginating = false
            current.errorMessage = error.localizedDescription
            view?.render(current)
        }
    }
}
