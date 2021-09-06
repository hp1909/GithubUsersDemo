//
//  Localization.swift
//  Localization
//
//  Created by Phuc Hoang on 9/7/21.
//

import Foundation

extension String {
    func localized() -> String {
        NSLocalizedString(self, comment: "")
    }
}
