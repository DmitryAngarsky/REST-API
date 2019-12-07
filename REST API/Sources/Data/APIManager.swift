//
//  APIServices.swift
//  REST API
//
//  Created by Дмитрий Тараканов on 29.11.2019.
//  Copyright © 2019 Dmitry Angarsky. All rights reserved.
//

import Foundation
import Alamofire

final public class APIManager {
    
    public static let shared = APIManager()
    
    public func getCource<T: Codable>(
        
        handler: @escaping (_ cource: T?, _ error: Error?) -> Void) {
        
        var urlComponents = URLComponents()
        
        urlComponents.scheme     = "https"
        urlComponents.host       = "altgo.altarix.org"
        urlComponents.path       = "/api/event"
        urlComponents.queryItems = [URLQueryItem(name: "id", value: "F95908B6-492E-4D4A-B780-66E9DFE413E4")]
        guard let url = urlComponents.url else { return }
        
        request(url).validate().responseData() { response in
            
            switch response.result {
            case .success(let value):
                do {
                    let cources = try JSONDecoder.init().decode(T.self, from: value)
                    handler(cources, nil)
                } catch {
                    handler(nil, error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
