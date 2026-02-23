//
//  ProductListBuilder.swift
//  ViperChallange
//
//  Created by Çağatay Eğilmez on 23.02.2026.
//

import UIKit

enum ProductListBuilder {

    static func build() -> UIViewController {
        let repo = ProductRepostory(apiService: ServiceLayer())
        let interactor = ProductListInteractor(repo: repo)
        let presenter = ProductListPresenter()
        let router = ProductListRouter()
        let vc = ProductListViewController(presenter: presenter)

        presenter.view = vc
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        return vc
    }
}
