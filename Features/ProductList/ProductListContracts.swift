//
//  ProductListContracts.swift
//  ViperChallange
//
//  Created by Çağatay Eğilmez on 23.02.2026.
//

import Foundation

protocol ProductListViewProtocol: AnyObject {

    func render(_ model: ProductListViewModel)
}

protocol ProductListPresenterProtocol: AnyObject {

    func viewDidLoad()
    func didPullToRefresh()
    func didReachListEnd()
    func didSelectProduct(id: Int)
}

protocol ProductListInteractorProtocol: AnyObject {

    func loadInitial()
    func refresh()
    func loadNextPage()
}

protocol ProductListInteractorOutput: AnyObject {

    func didLoadInitial(result: Result<ProductListDataSnapshot, Error>)
    func didLoadNext(result: Result<ProductListDataSnapshot, Error>)
}

protocol ProductListRoutingProtocol: AnyObject {

    func routeToDetail(productId: Int, from view: AnyObject?)
}
