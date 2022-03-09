//
//  APIClient.swift
//  CTAProject
//
//  Created by 内山和輝 on 2022/01/16.
//

import Foundation
import RxSwift

final class APIClient: HotPepperAPIType {
    func searchShop(searchWord: String) -> Single<HotPepper> {
        let encodedSearchWord = searchWord.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        return Single<HotPepper>.create { observer in
            let APIKey = MyAPIKey.hotpepper
            guard let url = URL(string: "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=" + APIKey + "&format=json&keyword=" + String(encodedSearchWord!)) else {
                observer(.failure(APIError.textEncodingError))
                return Disposables.create()
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let error = error {
                    print("情報の取得に失敗しました。:", error)
                    observer(.failure(APIError.unexpectedError))
                    return
                }
                
                if let data = data {
                    do {
                        let hotpepper = try JSONDecoder().decode(HotPepper.self, from: data)
                        observer(.success(hotpepper))
                        print("json:", hotpepper)
                    } catch {
                        observer(.failure(APIError.decodeError))
                        print("デコードに失敗しました。:", error)
                    }
                }
            }
            task.resume()
            return Disposables.create()
        }
    }
}
