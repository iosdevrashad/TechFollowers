//
//  String+Ext.swift
//
//  Created by Rashad Surratt on 1/17/23.
//

import UIKit

let bolderFont = UIFont.boldSystemFont(ofSize: 16)
let italicsFont = UIFont.italicSystemFont(ofSize: 16)

let boldFont = UIFont.preferredFont(forTextStyle: .headline).bold()
let italicFont = UIFont.preferredFont(forTextStyle: .footnote).italic()

// Use as needed. 

//extension String {
//
//    func convertToDate() -> Date? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.timeZone = .current
//
//        return dateFormatter.date(from: self)
//    }
//
//    func convertToDisplayFormat() -> String {
//
//        guard let date = self.convertToDate() else { return "N/A" }
//        return date.convertToMonthYearFormat()
//    }
//}

extension UIFont {
    func withTraits(traits:UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }

    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }

    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}
