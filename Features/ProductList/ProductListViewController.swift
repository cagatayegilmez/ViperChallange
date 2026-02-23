//
//  ProductListViewController.swift
//  ViperChallange
//
//  Created by Çağatay Eğilmez on 23.02.2026.
//

import Foundation
import SwiftUI
import UIKit

final class ProductListViewController: UIViewController, ProductListViewProtocol {
    private let presenter: ProductListPresenterProtocol
    private let uiModel = ProductListUIModel()

    init(presenter: ProductListPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.title = "Listing"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let screen = ProductListScreen(model: uiModel,
                                       onSelectProduct: { [weak self] id in
                                            self?.presenter.didSelectProduct(id: id)
                                       },
                                       onReachEnd: { [weak self] in
                                            self?.presenter.didReachListEnd()
                                       },
                                       onRefresh: { [weak self] in
                                            self?.presenter.didPullToRefresh()
                                        })
        addSwiftUIView(screen)

        presenter.viewDidLoad()
    }

    func render(_ model: ProductListViewModel) {
        uiModel.apply(model)
    }
}

@Observable
final class ProductListUIModel {

    private(set) var state: ViewState = .idle
    private(set) var sponsored: [ProductCardViewModel] = []
    private(set) var products: [ProductCardViewModel] = []
    private(set) var isPaginating: Bool = false
    private(set) var errorMessage: String?

    func apply(_ vm: ProductListViewModel) {
        state = vm.state
        sponsored = vm.sponsored
        products = vm.products
        isPaginating = vm.isPaginating
        errorMessage = vm.errorMessage
    }
}
