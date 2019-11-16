//
//  HomeViewController.swift
//  TestApi
//
//  Created by Administrator on 2019/11/14.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

import SwiftEventBus

class HomeViewController: UIViewController {

    @IBOutlet weak var mainInfoTableView: UITableView!
    @IBOutlet weak var mainInfoTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var servInfoButton: UIView!
    @IBOutlet weak var abInfoButton: UIView!
    
    @IBOutlet weak var linkInfoTableView: UITableView!
    @IBOutlet weak var linkInfoTableViewHeight: NSLayoutConstraint!
    
    var mainInfo: Dictionary<String, String?>?
    var linkInfo: [Dictionary<String, String?>]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapServInfo = UITapGestureRecognizer(target: self, action: #selector(onServInfo))
        servInfoButton.addGestureRecognizer(tapServInfo)
        
        let tapABInfo = UITapGestureRecognizer(target: self, action: #selector(onABInfo))
        abInfoButton.addGestureRecognizer(tapABInfo)
        
        loadData()
        
        SwiftEventBus.onMainThread(self, name: "loadData") { notification in
            self.loadData()
        }
    }
    
    func loadData() {
        loadMainInfo()
        loadLinkInfo()
    }
    
    func loadMainInfo() {
        mainInfoTableView.delegate = self
        mainInfoTableView.dataSource = self
        mainInfoTableView.estimatedRowHeight = UITableView.automaticDimension
        mainInfoTableViewHeight.constant = 0
        
        mainInfo = DBManager.sharedInstance.mainInfo
        
        mainInfoTableView.reloadData()
    }
    
    func loadLinkInfo() {
        linkInfoTableView.delegate = self
        linkInfoTableView.dataSource = self
        linkInfoTableView.estimatedRowHeight = UITableView.automaticDimension
        linkInfoTableViewHeight.constant = 0
        
        linkInfo = DBManager.sharedInstance.linkInfo
        
        linkInfoTableView.reloadData()
    }
    
    @objc func onServInfo() {
        performSegue(withIdentifier: "segueDetailInfo", sender: "Serv")
    }
    
    @objc func onABInfo() {
        performSegue(withIdentifier: "segueDetailInfo", sender: "AB")
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetailInfo", let detailVC = segue.destination as? DetailInfoViewController {
            detailVC.category = (sender as! String)
        }
    }
}

// Delegate & DataSource of LinkInfoTableView

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == mainInfoTableView {
            if mainInfo != nil {
                self.mainInfoTableViewHeight.constant = 10
                return 1
            } else {
                return 0
            }
        } else {
            if (linkInfo.count > 0) {
                self.linkInfoTableViewHeight.constant = 10
            }
            return linkInfo.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == mainInfoTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mainInfoCell", for: indexPath) as! MainInfoTableCell
            
            let data = self.mainInfo!
            // set text fields
            cell.dataFields[0].text = data["first_name"] as? String
            cell.dataFields[1].text = data["last_name"] as? String
            cell.dataFields[2].text = data["email"] as? String
            cell.dataFields[3].text = data["phone_number"] as? String
            cell.dataFields[4].text = data["birthday"] as? String
            cell.dataFields[5].text = data["country"] as? String
            cell.dataFields[6].text = data["address"] as? String
            cell.dataFields[7].text = data["company"] as? String
            cell.dataFields[8].text = data["url"] as? String
            cell.dataFields[9].text = data["credit_card_type"] as? String
            cell.dataFields[10].text = data["credit_card_number"] as? String
            
            // set image fields
            cell.imageView1.kf.setImage(with: getImageURL(imagePath: data["picture1"] as? String))
            cell.imageView2.kf.setImage(with: getImageURL(imagePath: data["picture2"] as? String))
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "linkInfoCell", for: indexPath) as! LinkInfoTableCell
            
            let data = self.linkInfo[indexPath.row]
            
            // set text fields
            cell.dataFields[0].text = data["text_field1"] as? String
            cell.dataFields[1].text = data["text_field2"] as? String
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.updateViewConstraints()
        
        
        if tableView == mainInfoTableView {
            self.mainInfoTableView.layoutIfNeeded()
            self.mainInfoTableViewHeight.constant = self.mainInfoTableView.contentSize.height
        } else {
            self.linkInfoTableView.layoutIfNeeded()
            self.linkInfoTableViewHeight.constant = self.linkInfoTableView.contentSize.height
        }
    }
}

// MainInfoTableCell
class MainInfoTableCell: UITableViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet var dataFields: [UILabel]!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    
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


// LinkInfoTableCell

class LinkInfoTableCell: UITableViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet var dataFields: [UILabel]!
    
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
