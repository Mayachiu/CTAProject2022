//
//  UIImage+Extension.swift
//  CTAProject
//
//  Created by 内山和輝 on 2022/01/21.
//

import UIKit

extension UIImage {
    public convenience init(url: String) {
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            self.init(data: data)!
            return
        } catch {
            print("Error : \(error.localizedDescription)")
        }
        self.init()
    }
}
