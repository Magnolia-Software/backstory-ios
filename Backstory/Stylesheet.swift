//
//  Stylesheet.swift
//  Backstory
//
//  Created by Candace Camarillo on 3/13/25.
//

import SwiftUI

struct Stylesheet {
    struct Fonts {
        static let heading1 = Font.custom("AbrilFatface-Regular", size: 50)
        static let heading2 = Font.custom("AbrilFatface-Regular", size: 36)
        static let heading3 = Font.custom("NotoSans-Bold", size: 20)
        static let body = Font.custom("NotoSans-Regular", size: 16)
    }
    
    struct Colors {
        static let error = Color(UIColor(hex: "#dd6e42"))
        static let background = Color(UIColor(hex: "#eaeaea"))
        static let heading = Color(UIColor(hex: "#4f6d7a"))
        static let action = Color(UIColor(hex: "#c0d6df"))
        static let altBackground = Color(UIColor(hex: "#c0d6df"))
        static let body = Color(UIColor(hex: "#333333"))
    }
}
