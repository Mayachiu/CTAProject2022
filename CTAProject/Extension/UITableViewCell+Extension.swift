//
//  UITableViewCell+Extension.swift
//  CTAProject
//
//  Created by 内山和輝 on 2022/01/24.
//

import UIKit

extension UITableViewCell {
    static var nibName: String {
        String(describing: self) //クラス名が取得できる
    }
    static var identifier: String {
        String(describing: self) //identifierをCellのクラス名にする
    }
}
