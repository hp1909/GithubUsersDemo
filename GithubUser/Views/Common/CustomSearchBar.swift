//
//  CustomSearchBar.swift
//  CustomSearchBar
//
//  Created by Phuc Hoang on 9/5/21.
//

import SwiftUI

struct CustomSearchBar: View {
    private enum Design {
        static let backgroundColor = Color.gray.opacity(0.4)
        static let cornerRadius: CGFloat = 16
        static let padding = EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
    }
    @Binding var text: String
    
    var body: some View {
        TextField(
            "",
            text: $text,
            prompt: Text(
                "SEARCH_PLACEHOLDER".localized()
            )
        )
        .disableAutocorrection(true)
        .modifier(TextFieldClearButton(text: $text))
        .padding(Design.padding)
        .background(Design.backgroundColor)
        .cornerRadius(Design.cornerRadius)
    }
}

struct CustomSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomSearchBar(text: .constant("Hello"))
    }
}
