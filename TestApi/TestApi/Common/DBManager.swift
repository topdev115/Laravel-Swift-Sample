//
//  DBManager.swift
//  TestApi
//
//  Created by Administrator on 2019/11/15.
//

import Foundation

import SwiftyJSON
import SQLite

class DBManager {
    // Singleton class
    static let sharedInstance = DBManager()
    
    // DB
    private var db: Connection?
    
    
    func initialize() {
        createDB(dbName: "localData")
    }
    
    private func createDB(dbName: String) {
        do {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            
            // Create DB
            self.db = try Connection("\(path)/\(dbName).sqlite3")
            
            // Create Main Table
            try db?.run(mains.create(ifNotExists: true) { t in
                t.column(id/*, primaryKey: .autoincrement*/)
                t.column(codeId)
                t.column(firstName)
                t.column(lastName)
                t.column(email)
                t.column(phoneNumber)
                t.column(birthday)
                t.column(country)
                t.column(address)
                t.column(company)
                t.column(url)
                t.column(creditCardType)
                t.column(creditCardNumber)
                t.column(picture1)
                t.column(picture2)
            })
            
            // Create Serv Table
            try db?.run(servs.create(ifNotExists: true) { t in
                t.column(id/*, primaryKey: .autoincrement*/)
                t.column(mainId)
                t.column(textField1)
                t.column(textField2)
                t.column(textField3)
                t.column(imageField1)
            })
            
            // Create Link Table
            try db?.run(links.create(ifNotExists: true) { t in
                t.column(id/*, primaryKey: .autoincrement*/)
                t.column(mainId)
                t.column(textField1)
                t.column(textField2)
            })
            
            // Create AB Table
            try db?.run(abs.create(ifNotExists: true) { t in
                t.column(id/*, primaryKey: .autoincrement*/)
                t.column(mainId)
                t.column(textField1)
                t.column(textField2)
                t.column(imageField1)
            })
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // Save Info into DB Tables
    func saveData(_ mainInfo: JSON?, _ servInfo: Array<JSON>?, _ linkInfo: Array<JSON>?, _ abInfo: Array<JSON>?) {
        do {
            if let _mainInfo = mainInfo {
                // Empty Main Table
                try self.db?.run(mains.delete())
                
                // Insert Main Info into Table
                try self.db?.run(mains.insert(id <- _mainInfo["id"].int64Value, codeId <- _mainInfo["code_id"].int64Value, firstName <- _mainInfo["first_name"].string, lastName <- _mainInfo["last_name"].string, email <- _mainInfo["email"].string, phoneNumber <- _mainInfo["phone_number"].string, birthday <- _mainInfo["birthday"].string, country <- _mainInfo["country"].string, address <- _mainInfo["address"].string, company <- _mainInfo["company"].string, url <- _mainInfo["url"].string, creditCardType <- _mainInfo["credit_card_type"].string, creditCardNumber <- _mainInfo["credit_card_number"].string, picture1 <- _mainInfo["picture1"].string, picture2 <- _mainInfo["picture2"].string))
            }
            
            if let _servInfo = servInfo {
                // Empty Serv Table
                try self.db?.run(servs.delete())
                
                // Insert Serv Info into Table
                for json in _servInfo {
                    try self.db?.run(servs.insert(id <- json["id"].int64Value, mainId <- json["main_id"].int64Value, textField1 <- json["text_field1"].string, textField2 <- json["text_field2"].string, textField3 <- json["text_field3"].string, imageField1 <- json["image_field1"].string))
                }
            }
            
            if let _linkInfo = linkInfo {
                // Empty Link Table
                try self.db?.run(links.delete())
                
                // Insert Link Info into Table
                for json in _linkInfo {
                    try self.db?.run(links.insert(id <- json["id"].int64Value, mainId <- json["main_id"].int64Value, textField1 <- json["text_field1"].string, textField2 <- json["text_field2"].string))
                }
            }
            
            if let _abInfo = abInfo {
                // Empty AB Table
                try self.db?.run(abs.delete())
                
                // Insert AB Info into Table
                for json in _abInfo {
                    try self.db?.run(abs.insert(id <- json["id"].int64Value, mainId <- json["main_id"].int64Value, textField1 <- json["text_field1"].string, textField2 <- json["text_field2"].string, imageField1 <- json["image_field1"].string))
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    var mainInfo : Dictionary<String, String?>? {
        do {
            if let main = try self.db?.pluck(mains) {
                var ret = Dictionary<String, String?>()
                ret["first_name"] = main[firstName]
                ret["last_name"] = main[lastName]
                ret["email"] = main[email]
                ret["phone_number"] = main[phoneNumber]
                ret["birthday"] = main[birthday]
                ret["country"] = main[country]
                ret["address"] = main[address]
                ret["company"] = main[company]
                ret["url"] = main[url]
                ret["credit_card_type"] = main[creditCardType]
                ret["credit_card_number"] = main[creditCardNumber]
                ret["picture1"] = main[picture1]
                ret["picture2"] = main[picture2]
                
                return ret
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    var servInfo : [Dictionary<String, String?>] {
        var ret: [Dictionary<String, String?>] = []
        
        do {
            for serv in try (self.db?.prepare(servs))! {
                
                var element = Dictionary<String, String?>()
                element["text_field1"] = serv[textField1]
                element["text_field2"] = serv[textField2]
                element["text_field3"] = serv[textField3]
                element["image_field1"] = serv[imageField1]
                
                ret.append(element)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return ret
    }
    
    var linkInfo : [Dictionary<String, String?>] {
        var ret: [Dictionary<String, String?>] = []
        
        do {
            for link in try (self.db?.prepare(links))! {
                
                var element = Dictionary<String, String?>()
                element["text_field1"] = link[textField1]
                element["text_field2"] = link[textField2]
                
                ret.append(element)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return ret
    }
    
    var abInfo : [Dictionary<String, String?>] {
        var ret: [Dictionary<String, String?>] = []
        
        do {
            for ab in try (self.db?.prepare(abs))! {
                
                var element = Dictionary<String, String?>()
                element["text_field1"] = ab[textField1]
                element["text_field2"] = ab[textField2]
                element["image_field1"] = ab[imageField1]
                
                ret.append(element)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return ret
    }
    
    
    // DB Struncture
    
    //Tables
    private let mains = Table("mains")
    private let servs = Table("servs")
    private let links = Table("links")
    private let abs = Table("abs")
    
    // Fields
    private let id = Expression<Int64>("id")
    private let codeId = Expression<Int64>("code_id")
    private let firstName = Expression<String?>("first_name")
    private let lastName = Expression<String?>("last_name")
    private let email = Expression<String?>("email")
    private let phoneNumber = Expression<String?>("phone_number")
    private let birthday = Expression<String?>("birthday")
    private let country = Expression<String?>("country")
    private let address = Expression<String?>("address")
    private let company = Expression<String?>("company")
    private let url = Expression<String?>("url")
    private let creditCardType = Expression<String?>("credit_card_type")
    private let creditCardNumber = Expression<String?>("credit_card_number")
    private let picture1 = Expression<String?>("picture1")
    private let picture2 = Expression<String?>("picture2")
    
    private let mainId = Expression<Int64>("main_id")
    private let textField1 = Expression<String?>("text_field1")
    private let textField2 = Expression<String?>("text_field2")
    private let textField3 = Expression<String?>("text_field3")
    private let imageField1 = Expression<String?>("image_field1")
}

