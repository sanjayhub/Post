//
//  FeedUIComposer.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 25/10/22.
//

import SwiftUI

enum FeedUIComposer {
    static func compose() -> UIHostingController<FeedListView> {
        let rootView = FeedListView()
        let viewController = UIHostingController(rootView: rootView)
        return viewController
    }
}
