//
//  Date+Extension.swift
//  GitHub
//
//  Created by Jitendra Gandhi on 20/12/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import Foundation

import Foundation

extension Date {
    
    static let formatter = DateFormatter()
    
    static let utcTimeZone = TimeZone(abbreviation: "UTC")!
    
    enum Format: String {
        
        case d                                                      = "d"
        case dd                                                     = "dd"
        case E                                                      = "E"
        case EE                                                     = "EE"
        case EEEE                                                   = "EEEE"
        case HH_colon_mm                                            = "HH:mm"
        case MM_slash_yy                                            = "MM/yy"
        case MM_slash_yyyy                                          = "MM/yyyy"
        case d_space_MMM                                            = "d MMM"
        case d_space_MMM_space_EE                                   = "d MMM EE"
        case dd_space_MMM                                           = "dd MMM"
        case dd_dash_MM_dash_yyyy                                   = "dd-MM-yyyy"
        case dd_space_MMM_line_EEEE                                 = "dd MMM\nEEEE"
        case d_space_MMM_comma_space_EEE                            = "d MMM, EEE"
        case dd_space_MMM_comma_space_EEE                           = "dd MMM, EEE"
        case dd_space_MMM_comma_space_EEEE                          = "dd MMM, EEEE"
        case dd_space_MMM_space_YY                                  = "dd MMM YY"
        case dd_slash_MM_slash_yyyy                                 = "dd/MM/yyyy"
        case dd_space_MMM_space_YYYY                                = "dd MMM YYYY"
        case dd_space_MMM_comma_space_yy                            = "dd MMM, yy"
        case dd_space_MMM_space_yy                                  = "dd MMM yy"
        case d_space_MMM_space_yy                                   = "d MMM yy"
        case dd_space_MMM_comma_space_YY                            = "dd MMM, YY"
        case dd_space_MMM_comma_space_YYYY                          = "dd MMM, YYYY"
        case yyyy_slash_MMM_slash_dd                                = "yyyy/MM/dd"
        case dd_dash_MM_dash_yyyy_comma_space_EEE                   = "dd-MM-yyyy, EEEE"
        case dd_space_MMM_dot_space_yy_space_I_space_EE             = "dd MMM. yy | EE"
        case dd_space_MMM_comma_space_yy_space_I_space_EE           = "dd MMM, yy | EE"
        case yyyy_colon_MM_colon_dd_space_HH_colon_mm                   = "yyyy-MM-dd HH:mm"
        case dd_dash_MM_dash_yyyy_comma_space_HH_colon_mm_I_space_EEEE  = "dd-MM-yyyy, HH:mm | EEEE"
        case yyyy_colon_MM_colon_dd_space_HH_colon_mm_colon_ss          = "yyyy-MM-dd HH:mm:ss"
        case yyyy_colon_MM_colon_dd_space_T_HH_colon_mm_colon_ss_Z      = "yyyy-MM-dd'T'HH:mm:ssZ"
    }
    
    static func string(from date: Date?, format: Format, timeZone: TimeZone = utcTimeZone) -> String? {
        
        guard let date = date else { return nil }
        formatter.dateFormat = format.rawValue
        formatter.timeZone = timeZone
        formatter.locale = Locale(identifier: "en")
        return formatter.string(from: date)
    }
}
