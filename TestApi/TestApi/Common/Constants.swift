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
        static let CHECK_CODE = API_URL + "/check-code"
        static let GET_INFO = API_URL + "/info"
    }
    
    static let X = 1 //timeframe (in hour)
    static let W = 1 //timeframemultiple
    
    static let SUPPRESSABLE = false
    
    static let SUP_ACTIVE_MESSAGE = "Code is now active."
    static let SUP_INACTIVE_MESSAGE1 = "Code is inactive now. Will check again later."
    static let SUP_INACTIVE_MESSAGE2 = "Code is inactive and it's been more than %d hours."
    static let ERROR_MESSAGE = "Code is inactive now."
}
