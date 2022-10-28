//
//  FeedListView.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 25/10/22.
//

import SwiftUI

struct FeedListView: View {
    
    @ObservedObject private (set) var viewModel: FeedViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            renderViewFor(viewModel.state)
        }
        .onAppear(perform: viewModel.loadFeed)
        .padding()
    }
}

private extension FeedListView {
    func renderViewFor(_ state: ViewState<[Feed]>) -> some View {
        return Group {
            switch state {
            case .loading:
                LoadingView()
                    .frame(width: 50.0, height: 50.0)
                    .foregroundColor(Color("3dc6a7"))
                
            case let .loaded(feed):
                ForEach(feed, id: \.id) { item in
                    Text(item.id)
                }
            default: Text("todo")
            }
        }
    }
}

        
//        if viewModel.isLoading {
//            LoadingView()
//                .frame(width: 50.0, height: 50.0)
//                .foregroundColor(Color("3dc6a7"))
//        } else {
//            ForEach(viewModel.feed, id: \.id) { feed in
//                Text(feed.id)
//            }
//        }


