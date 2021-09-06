//
//  LoadingRow.swift
//  LoadingRow
//
//  Created by Phuc Hoang on 9/6/21.
//

import SwiftUI

struct LoadingRow: View {
    let height: CGFloat
    var body: some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }
        .frame(height: height)
        .listRowSeparator(.hidden)
    }
}

struct LoadingRow_Previews: PreviewProvider {
    static var previews: some View {
        LoadingRow(height: 300)
    }
}
