//
//  ApiClass.swift
//  PracticeApp
//
//  Created by Indiawyn Gaming on 13/08/20.
//  Copyright © 2020 myorg. All rights reserved.
//

import Foundation
import Alamofire

//Class for HTTP request
class ApiClass {
    
    static func getData(suceess : @escaping(Any?) -> Void , error : @escaping(Error?) -> Void){
        let url = URL(string: "https://raw.githubusercontent.com/AxxessTech/Mobile-Projects/master/challenge.json")
        
        //make Url request with Alamofire
        Alamofire.request(url!).responseJSON { (responseObject) -> Void in
        
        
            if responseObject.result.isSuccess {
             
                let respJson = responseObject.data
                 
                // return response as Any
                suceess(respJson)
                
            }
            if responseObject.result.isFailure {
                
                //return error msg
                error(responseObject.result.error)
                
            }
        }
    }
    
}
