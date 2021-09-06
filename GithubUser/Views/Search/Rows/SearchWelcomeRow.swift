//
//  WelcomeRow.swift
//  WelcomeRow
//
//  Created by Phuc Hoang on 9/5/21.
//

import SwiftUI

struct SearchWelcomeRow: View {
    private enum Design {
        static let iconDimension: CGFloat = 160
        static let iconBottomPadding = EdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 0)
        static let height: CGFloat = 200
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Spacer()
                Image("github_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: Design.iconDimension,
                        height: Design.iconDimension,
                        alignment: .center
                    )
                Spacer()
            }
            .frame(height: Design.height)
            .padding(Design.iconBottomPadding)
            Text("WELCOME".localized())
        }
    }
}

struct WelcomeRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchWelcomeRow()
    }
}
