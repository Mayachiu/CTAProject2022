//
//  UIView+Extension.swift
//  CTAProject
//
//  Created by 内山和輝 on 2022/02/08.
//

import UIKit

extension UIView {
    static var identifier: String {
        String(describing: self)
    }
    static var nib: UINib {
        UINib(nibName: String(describing: self), bundle: nil)
    }
}
