//
//  ViewState.swift
//  ViperChallange
//
//  Created by Çağatay Eğilmez on 23.02.2026.
//

/// Use this type to drive UI rendering and user interaction based on the current state.
enum ViewState: Equatable {

    /// The view is not doing any work yet and has no data to present.
    case idle

    /// The view is currently performing work (e.g., a network request) and should indicate progress.
    case loading

    /// The view has successfully finished loading and can present its content.
    case loaded

    /// The view encountered an unrecoverable error.
    ///
    /// - Parameter message: A human-readable description suitable for display to the user or logging.
    case error(message: String)
}
