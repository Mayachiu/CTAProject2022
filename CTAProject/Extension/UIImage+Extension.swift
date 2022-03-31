//
//  UIImage+Extension.swift
//  CTAProject
//
//  Created by 内山和輝 on 2022/01/21.
//

import UIKit

extension UIImage {
    convenience init?(url: String) {
        guard let url = URL(string: url) else {
            return nil
        }
        do {
            let data = try Data(contentsOf: url) // 失敗したらcatchへ行き、do内のここから下の処理は実行されない
            self.init(data: data)
        } catch {
            print("Error : \(error.localizedDescription)")
            return nil
        }
    }
}
