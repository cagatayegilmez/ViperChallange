//
//  ProductRepostoryProtocol.swift
//  ViperChallange
//
//  Created by Çağatay Eğilmez on 23.02.2026.
//

protocol ProductRepostoryProtocol {

    /// Fetches product list
    ///
    /// - Parameter page: Page number for pagination
    /// - Returns: Product list response
    func fetchListing(page: Int) async throws -> ProductListResponse

    /// Fetches product detail
    ///
    /// - Parameter productId: Id of product
    /// - Returns: Detail response of product
    func fetchDetail(productId: Int) async throws -> ProductDetailResponse
}
