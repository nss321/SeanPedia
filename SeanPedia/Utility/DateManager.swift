//
//  DateManager.swift
//  SeanPedia
//
//  Created by BAE on 1/25/25.
//

import UIKit
import Then

final class DateManager {
    static let shared = DateManager()
    
    private let signupDateForamtter = DateFormatter().then {
        $0.dateFormat = "yy.MM.dd 가입"
    }
    
    func convertDateToString(date: Date) -> String {
        return signupDateForamtter.string(from: date)
    }
}
