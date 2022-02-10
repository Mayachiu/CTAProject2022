//
//  AlertView.swift
//  CTAProject
//
//  Created by 内山和輝 on 2022/01/25.
//

import UIKit

final class AlertView: UIView {
    @IBOutlet private weak var alertLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func draw(_ rect: CGRect) {
        alertLabel.text = L10n.characterAlertText
        closeButton.setTitle(L10n.closeButtonTitle, for: .normal)
        closeButton.tintColor = .white
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        removeFromSuperview()
    }
}
