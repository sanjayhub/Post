//
//  FeedListView.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 25/10/22.
//

import SwiftUI

struct FeedListView: View {
    
    @ObservedObject private var viewModel: FeedViewModel
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        Group {
            switch viewModel.state {
            case .loading:
                LoadingView()
                    .frame(width: 50.0, height: 50.0)
                    .foregroundColor(Color("3dc6a7"))
                    .onAppear(perform: viewModel.loadFeed)
                
            case let .loaded(feed):
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVStack(spacing: 0) {
                        ForEach(feed, id: \.id) { item in
                          FeedCard(item: item)
                        }
                    }
                    .background(
                        Color(.systemBackground)
                    )
                }
            default: EmptyView()
            }
        }
    }
}
