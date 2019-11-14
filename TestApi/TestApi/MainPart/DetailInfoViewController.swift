//
//  DetailInfoViewController.swift
//  TestApi
//
//  Created by Administrator on 2019/11/14.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

class DetailInfoViewController: UITableViewController {
    
    var category: String!
    
    private var detailInfo: Array<JSON> = Array()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = category + " Information"
        
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl!.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        self.loadData()
    }
    
    @objc private func refreshData(_ sender: Any) {
        self.loadData()
        self.tableView.refreshControl?.endRefreshing()
    }
    
    func loadData() {
        if Reachability.isConnectedToNetwork() {
            
            if let code = SettingManager.sharedInstance.code {
                self.serverRequestStart()
                
                let apiUrl = category == "Serv" ? Constants.API.SERV_DATA : Constants.API.AB_DATA
                
                Alamofire.request(apiUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                    
                    switch response.result {
                    case .success:
                        if let resData = response.data {
                            if let json = try? JSON(data: resData) {
                                let status = json["status"].boolValue
                                if status {
                                    self.detailInfo = json["data"].arrayValue
                                    
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
                                } else {
                                    if let msg = json["message"].string {
                                        self.showSnackbar(message: msg)
                                    }
                                }
                            }
                        }
                        break
                    case .failure(let error):
                        print(error)
                        
                        break
                    }
                    
                    DispatchQueue.main.async {
                        self.serverRequestEnd()
                    }
                }
            } else {
                //empty code
                self.showSnackbar(message: "Empty code.")
            }
        } else {            
            // network disconnected
            DispatchQueue.main.async {
                let alert = UIAlertController(title: APP_NAME, message: "Could not connect to the server.\nPlease check the internet connection!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return detailInfo.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if category == "Serv" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "servInfoCell", for: indexPath) as! ServInfoTableCell
            
            let data = detailInfo[indexPath.row]
            // set text fields
            for n in 1...cell.dataFields.count {
                cell.dataFields[n - 1].text = data["text_field\(n)"].string
            }
            // set image fields
            cell.imageView1.kf.setImage(with: getImageURL(imagePath: data["image_field1"].string))
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "abInfoCell", for: indexPath) as! ABInfoTableCell
            
            let data = detailInfo[indexPath.row]
            // set text fields
            for n in 1...cell.dataFields.count {
                cell.dataFields[n - 1].text = data["text_field\(n)"].string
            }
            // set image fields
            cell.imageView1.kf.setImage(with: getImageURL(imagePath: data["image_field1"].string))
            
            return cell
        }
    }
}

// ServInfoTableCell

class ServInfoTableCell: UITableViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet var dataFields: [UILabel]!
    @IBOutlet weak var imageView1: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cardView.layer.cornerRadius = 8.0
        cardView.layer.borderColor = UIColor.lightGray.cgColor
        cardView.layer.borderWidth = 1.0
        
        cardView.layer.shadowColor = UIColor.darkGray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        cardView.layer.shadowRadius = 3.0
        cardView.layer.shadowOpacity = 0.6
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

// ABInfoTableCell

class ABInfoTableCell: UITableViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet var dataFields: [UILabel]!
    @IBOutlet weak var imageView1: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cardView.layer.cornerRadius = 8.0
        cardView.layer.borderColor = UIColor.lightGray.cgColor
        cardView.layer.borderWidth = 1.0
        
        cardView.layer.shadowColor = UIColor.darkGray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        cardView.layer.shadowRadius = 3.0
        cardView.layer.shadowOpacity = 0.6
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
