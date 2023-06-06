//
//  ViewState.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 28/10/22.
//

import Foundation

enum ViewState<T> {
    case loading
    case loaded(T)
    case error(message: String?)
}

extension ViewState: Equatable where T: Equatable {}
