//
//  SearchResultRow.swift
//  SearchResultRow
//
//  Created by Phuc Hoang on 9/5/21.
//

import SwiftUI

struct SearchResultRow: View {
    private enum Design {
        static let imageDimension: CGFloat = 40
    }
    let user: User
    
    var body: some View {
        HStack {
            AsyncImage(url: user.avatarUrl) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(4)
            } placeholder: {
                ProgressView()
            }
            .frame(width: Design.imageDimension, height: Design.imageDimension)
            Text(user.name ?? "")
                .font(.headline)
            Spacer()
        }
    }
}

struct SearchResultRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultRow(user: User(name: "Phuc", url: "https://avatars.githubusercontent.com/u/3836?v=4"))
    }
}
