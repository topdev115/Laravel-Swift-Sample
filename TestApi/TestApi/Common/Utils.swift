//
//  Utils.swift
//  TestApi
//
//  Created by Administrator on 2019/11/14.
//

import UIKit

func getImageURL(imagePath: String?) -> URL? {
    if let _imagePath = imagePath {
        return URL(string: Constants.API.MAIN_URL + _imagePath.replacingOccurrences(of: "public", with: ""))
    }
    return nil
}
