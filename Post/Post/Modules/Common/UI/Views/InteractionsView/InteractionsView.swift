//
//  InteractionsView.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 15/12/22.
//

import SwiftUI

struct InteractionsView: View {
    
    private let likes: Int
    
    init(likes: Int) {
        self.likes = likes
    }
    
    var body: some View {
        HStack {
            Image("heart_icon")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Color(.label))
                .frame(width: 18, height: 18)
            Text("\(likes)")
                .foregroundColor(Color(.label))
                .font(.footnote)
            
            Image("bookmark_icon")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Color(.label))
                .frame(width: 18, height: 18)
        }
    }
}

