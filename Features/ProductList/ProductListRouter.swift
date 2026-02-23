//
//  ProductListRouter.swift
//  ViperChallange
//
//  Created by Çağatay Eğilmez on 23.02.2026.
//

import UIKit

final class ProductListRouter: ProductListRoutingProtocol {

    func routeToDetail(productId: Int, from view: AnyObject?) {
        guard let vc = view as? UIViewController else {
            return
        }

        // let detail = ProductDetailBuilder.build(productId: productId)
        // vc.navigationController?.pushViewController(detail, animated: true)
    }
}
