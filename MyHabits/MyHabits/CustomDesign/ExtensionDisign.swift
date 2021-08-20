//
//  ExtensionDisign.swift
//  MyHabits
//
//  Created by TIS Developer on 11.08.2021.
//

import Foundation
import UIKit

extension UIColor {
    class var AlmostWhite: UIColor {
        return UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 247.0/255.0, alpha: 1.0)
    }
    class var CustomPurple: UIColor {
        return UIColor(red: 161.0/255.0, green: 22.0/255.0, blue: 204.0/255.0, alpha: 1.0)
    }
    class var CustomBlue: UIColor {
        return UIColor(red: 41.0/255.0, green: 109.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
    class var CustomGreen: UIColor {
        return UIColor(red: 29.0/255.0, green: 179.0/255.0, blue: 34.0/255.0, alpha: 1.0)
    }
    class var CustomDarkBlue: UIColor {
        return UIColor(red: 98.0/255.0, green: 54.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
    class var CustomOrange: UIColor {
        return UIColor(red: 255.0/255.0, green: 159.0/255.0, blue: 79.0/255.0, alpha: 1.0)
    }
}

extension UIFont {
     
    class var Title3: UIFont {
        return UIFont.systemFont(ofSize: 20, weight: .semibold)
    }
    class var HeadLine: UIFont {
        return UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    class var Body: UIFont {
        return UIFont.systemFont(ofSize: 17, weight: .regular)
    }
    class var FootNoteBold: UIFont {
        return UIFont.systemFont(ofSize: 13, weight: .semibold)
    }
    class var FootNoteStatus: UIFont {
        return UIFont.systemFont(ofSize: 13, weight: .semibold)
    }
    class var FootNote: UIFont {
        return UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    class var Caption: UIFont {
        return UIFont.systemFont(ofSize: 12, weight: .regular)
    }
}
