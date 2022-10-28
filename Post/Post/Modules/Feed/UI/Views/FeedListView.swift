//
//  FeedListView.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 25/10/22.
//

import SwiftUI

struct FeedListView: View {
    
    @ObservedObject private (set) var viewModel: FeedViewModel
    @State private var isLoading = false
    @State private var items: [Feed] = []
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if isLoading {
                LoadingView()
                    .frame(width: 50.0, height: 50.0)
                    .foregroundColor(Color("3dc6a7"))
            } else {
                ForEach(items, id: \.id) { feed in
                    Text(feed.id)
                }
            }
        }
        .onAppear(perform: onLoad)
        .padding()
    }
}

private extension FeedListView {
    func onLoad() {
        viewModel.onLoadingStateChange = {  isLoading = $0 }
        viewModel.onFeedLoad = { self.items = $0 }
        
        viewModel.loadFeed()
    }
}

