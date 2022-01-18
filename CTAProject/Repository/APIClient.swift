//
//  APIClient.swift
//  CTAProject
//
//  Created by 内山和輝 on 2022/01/16.
//

import Foundation

enum APIClient {
    static func getAPI(searchWord: String, completion: @escaping(Result<HotPepper, APIError>) -> Void )  {
        let encodedSearchWord = searchWord.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        
        //別ファイルからAPIキー読み込み
        let APIKey = MyAPIKey.myAPIKey
        guard let url = URL(string: "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=" + APIKey + "&format=json&keyword=" + String(encodedSearchWord!)) else { return completion(.failure(.textEncodingError)) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: url) { (data, responds, error) in
            if let error = error {
                print("情報の取得に失敗しました。:", error)
                return
            }
            
            if let data = data {
                do {
                    let hotpepper = try JSONDecoder().decode(HotPepper.self, from: data)
                    completion(.success(hotpepper))
                    print("json:", hotpepper)
                } catch(let error) {
                    completion(.failure(.decodeError))
                    print("情報の取得に失敗しました。:", error)
                }
            }
        }
        task.resume()
        return
    }
}

enum APIError: Error {
    case textEncodingError
    case decodeError
}

