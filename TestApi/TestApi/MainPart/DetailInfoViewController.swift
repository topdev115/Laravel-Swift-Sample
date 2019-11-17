//
//  DetailInfoViewController.swift
//  TestApi
//
//  Created by Administrator on 2019/11/14.
//

import UIKit

import Kingfisher
import SwiftEventBus

class DetailInfoViewController: UITableViewController {
    
    var category: String!
    
    private var detailInfo: [Dictionary<String, String?>]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = category + " Information"
        
        loadData()
        
        SwiftEventBus.onMainThread(self, name: "loadData") { notification in
            self.loadData()
        }
    }
    
    func loadData() {
        detailInfo = category == "Serv" ? DBManager.sharedInstance.servInfo : DBManager.sharedInstance.abInfo
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
                cell.dataFields[n - 1].text = data["text_field\(n)"] as? String
            }
            // set image fields
            cell.imageView1.kf.setImage(with: getImageURL(imagePath: data["image_field1"] as? String))
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "abInfoCell", for: indexPath) as! ABInfoTableCell
            
            let data = detailInfo[indexPath.row]
            // set text fields
            for n in 1...cell.dataFields.count {
                cell.dataFields[n - 1].text = data["text_field\(n)"] as? String
            }
            // set image fields
            cell.imageView1.kf.setImage(with: getImageURL(imagePath: data["image_field1"] as? String))
            
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
