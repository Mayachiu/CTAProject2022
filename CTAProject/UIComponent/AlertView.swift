//
//  AlertView.swift
//  CTAProject
//
//  Created by 内山和輝 on 2022/01/25.
//

import UIKit

final class AlertView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func closeButtonClicked(_ sender: Any) {
        removeFromSuperview()
    }
}
