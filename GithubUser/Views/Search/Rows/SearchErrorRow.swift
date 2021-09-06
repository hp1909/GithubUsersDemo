//
//  SearchErrorRow.swift
//  SearchErrorRow
//
//  Created by Phuc Hoang on 9/6/21.
//

import SwiftUI

struct SearchErrorRow: View {
    let errorInfo: String
    var body: some View {
        VStack {
            Text(errorInfo)
                .font(.title)
            Text("RETRY_LABEL".localized())
        }
    }
}

struct SearchErrorRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchErrorRow(errorInfo: "Network error")
    }
}
