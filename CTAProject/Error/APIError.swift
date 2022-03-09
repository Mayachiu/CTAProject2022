//
//  APIError.swift
//  CTAProject
//
//  Created by 内山和輝 on 2022/01/18.
//

import Foundation

enum APIError: Error {
    case textEncodingError
    case decodeError
    case unexpectedError
}
