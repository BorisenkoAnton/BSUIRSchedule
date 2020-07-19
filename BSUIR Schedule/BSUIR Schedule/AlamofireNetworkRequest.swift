//
//  AlamofireNetworkRequest.swift
//  BSUIR Schedule
//
//  Created by Anton Borisenko on 7/11/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import Foundation
import Alamofire

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
    
    // TODO: add sendGetRequestForJSON
    
}
