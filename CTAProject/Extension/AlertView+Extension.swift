//
//  AlertView+Extension.swift
//  CTAProject
//
//  Created by 内山和輝 on 2022/01/27.
//

import UIKit

extension AlertView {
    static var nib: UINib {
        UINib(nibName: String(describing: self), bundle: nil)
    }
}
