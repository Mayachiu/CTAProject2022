//
//  HotPepperAPIInterface.swift
//  CTAProject
//
//  Created by 内山和輝 on 2022/03/01.
//

import Foundation

protocol HotPepperAPIType {
    func searchShop(searchWord: String, completion: @escaping(Result<HotPepper, APIError>) -> Void )
}
