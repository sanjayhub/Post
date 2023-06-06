//
//  FeedListView.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 25/10/22.
//

import SwiftUI

struct FeedView: View {
    
    @ObservedObject private var viewModel: FeedViewModel
    
    private let feedCard: (Feed) -> FeedCard
    
    init(viewModel: FeedViewModel, feedCard: @escaping (Feed) -> FeedCard) {
        self.viewModel = viewModel
        self.feedCard = feedCard
    }
    
    var body: some View {
        
        Group {
            switch viewModel.state {
            case .loading:
                LoadingView()
                    .frame(width: 50.0, height: 50.0)
                    .foregroundColor(Color("3dc6a7"))
                    .onAppear(perform: viewModel.loadFeed)
                
            case let .loaded(feed) where !feed.isEmpty:
                ListView(items: feed) { item in
                    feedCard(item)
                }
                
            case .loaded:
                Image("search_icon")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color(.secondaryLabel))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 140)
                VStack {
                    Text("It looks like you haven't followed anyone")
                        .font(.headline)
                        .foregroundColor(Color(.label))
                    Text("Search for & discover new content")
                        .font(.headline)
                        .foregroundColor(Color(.secondaryLabel))
                        .padding(.top, 8)
                }
                
            default: EmptyView()
            }
        }
    }
}
