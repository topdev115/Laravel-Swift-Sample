//
//  Constants.swift
//  TestApi
//
//  Created by Administrator on 2019/11/13.
//

import UIKit

let APP_NAME = "Test Api".localizedString

struct Constants {
    
    static let REQUEST_TIMEOUT = TimeInterval(60)
    
    struct API {
        static let MAIN_URL = "http://localhost:8000"
        static let API_URL = MAIN_URL + "/api"
        
        static let CHECK_CODE = API_URL + "/check-code"
        static let HOME_DATA = API_URL + "/home-data"
        static let SERV_DATA = API_URL + "/serv-data"
        static let AB_DATA = API_URL + "/ab-data"
    }
}
