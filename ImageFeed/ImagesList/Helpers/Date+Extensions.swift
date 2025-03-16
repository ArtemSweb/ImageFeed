//
//  Date+Extensions.swift
//  ImageFeed
//
//  Created by Артем Солодовников on 13.03.2025.
//

import Foundation

extension Date {
    var dateTimeString: String {
        DateFormatter.defaultDateTime.string(from: self)
    }
}

private extension DateFormatter {
    static let defaultDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
}
