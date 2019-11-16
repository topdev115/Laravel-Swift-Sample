//
//  Constants.swift
//  TestApi
//
//  Created by Administrator on 2019/11/13.
//

import UIKit

let APP_NAME = "Test Api"

struct Constants {
    
    static let REQUEST_TIMEOUT = TimeInterval(60)
    
    struct API {
        static let MAIN_URL = "http://localhost:8000"
        static let API_URL = MAIN_URL + "/api"
        
        static let LOG_REQUEST = API_URL + "/log-request"
        static let GET_INFO = API_URL + "/info"
    }
}
