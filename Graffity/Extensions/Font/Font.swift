//
//  Font.swift
//  Graffity
//
//  Created by Karen Khachatryan on 25.11.24.
//

import UIKit

extension UIFont {
    static func regularBarse(size: CFloat) -> UIFont? {
        return UIFont(name: "Angkor-Regular", size: CGFloat(size))
    }
    
    static func bold(size: CFloat) -> UIFont? {
        return UIFont(name: "Nozhik", size: CGFloat(size))
    }
    
    static func boldMon(size: CFloat) -> UIFont? {
        return UIFont(name: "Montserrat-Bold", size: CGFloat(size))
    }
    
}
