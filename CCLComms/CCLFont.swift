//
//  CCLFont.swift
//  CCLStyles
//
//

import Foundation

public enum CCLFont: String {

    case openSansExtraBold = "OpenSans-ExtraBold"
    case openSansBold = "OpenSans-Bold"
    case openSansSemiBold = "OpenSans-Semibold"
    case openSansRegular = "OpenSans"
    case openSansLight = "OpenSans-Light"
    case openSansItalic = "OpenSans-Italic"
    case helveticaNeue = "HelveticaNeue"
    case helveticaNeueMedium = "HelveticaNeue-Medium"
    case helveticaNeueBold = "HelveticaNeue-Bold"
    case helveticaNeueItalic = "HelveticaNeue-Italic"
    case tempoStd = "TempoStd-HeavyCondensed"

    var name: String {
        return self.rawValue
    }

}
