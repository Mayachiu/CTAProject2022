//
//  UITableViewCell+Extension.swift
//  CTAProject
//
//  Created by 内山和輝 on 2022/01/24.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        String(describing: self) //identifierをCellのクラス名にする
    }
    static var nib: UINib {
        UINib(nibName: identifier, bundle: nil) 
    }
}
