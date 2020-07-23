//
//  AlamofireNetworkRequest.swift
//  BSUIR Schedule
//
//  Created by Anton Borisenko on 7/11/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation
import Alamofire

// Class to manage Alamofire requests
class AlamofireNetworkRequest {
    
    static func sendGetRequestForString(url: String, completion: @escaping (_ stringRepresentationOfData: String) -> ()) {
        
        guard let url = URL(string: url) else { return }
        
        AF.request(url, method: .get).validate().responseString { (response) in
            
            switch response.result {
            case .success(let value):
                completion(value)
            case .failure(let error):
                // TODO: add showAlert()
                print(error)
            }
        }
        
    }
    
    static func sendGetRequestForJSON(url: String, completion: @escaping (Any) -> ()) {
        
        guard let url = URL(string: url) else { return }
        
        AF.request(url, method: .get, encoding: JSONEncoding.default).validate().responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                completion(value)
            case .failure(let error):
                // TODO: add showAlert()
                print(error)
            }
        }
    }
    
    static func sendGetRequestForData(url: String, completion: @escaping (Data) -> ()) {
        
        guard let url = URL(string: url) else { return }
        
        AF.request(url, method: .get, encoding: JSONEncoding.default).validate().responseData { (response) in
            
            switch response.result {
            case .success(let value):
                completion(value)
            case .failure(let error):
                // TODO: add showAlert()
                print(error)
            }
        }
    }
}
