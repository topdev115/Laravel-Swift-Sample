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

class HomeViewController: UIViewController {
    
    @IBOutlet weak var mainInfoTableView: UITableView!
    @IBOutlet weak var mainInfoTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var linkInfoTableView: UITableView!
    @IBOutlet weak var linkInfoTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var servInfoButton: UIView!
    @IBOutlet weak var abInfoButton: UIView!
    
    private var mainInfo: Array<JSON> = Array()
    private var linkInfo: Array<JSON> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainInfoTableView.delegate = self
        mainInfoTableView.dataSource = self
        mainInfoTableView.estimatedRowHeight = UITableView.automaticDimension
        mainInfoTableViewHeight.constant = 0
        
        linkInfoTableView.delegate = self
        linkInfoTableView.dataSource = self
        linkInfoTableView.estimatedRowHeight = UITableView.automaticDimension
        linkInfoTableViewHeight.constant = 0
        
        let tapServInfo = UITapGestureRecognizer(target: self, action: #selector(onServInfo))
        servInfoButton.addGestureRecognizer(tapServInfo)
        
        let tapABInfo = UITapGestureRecognizer(target: self, action: #selector(onABInfo))
        abInfoButton.addGestureRecognizer(tapABInfo)
        
        self.loadData()
    }
    
    func loadData() {
        if Reachability.isConnectedToNetwork() {            
            if let code = SettingManager.sharedInstance.code {
                self.serverRequestStart()
                
                Alamofire.request(Constants.API.HOME_DATA, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                    
                    switch response.result {
                    case .success:
                        if let resData = response.data {
                            if let json = try? JSON(data: resData) {
                                let status = json["status"].boolValue
                                if status {
                                    self.mainInfo = json["main"].arrayValue
                                    self.linkInfo = json["link"].arrayValue
                                    
                                    DispatchQueue.main.async {
                                        self.mainInfoTableView.reloadData()
                                        self.linkInfoTableView.reloadData()
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
                // empty code
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
    
    @IBAction func onReloadData(_ sender: UIBarButtonItem) {
        self.loadData()
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
            detailVC.category = sender as! String
        }
    }
}

// Delegate & DataSource of MainInfoTableView

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == mainInfoTableView {
            if (mainInfo.count > 0) {
                self.mainInfoTableViewHeight.constant = 10
            }
            return mainInfo.count
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
            
            let data = self.mainInfo[indexPath.row]
            
            // set text fields
            for n in 0...10 {
                cell.dataFields[n].text = data["text_field\(n + 1)"].string
            }
            
            // set image fields
            cell.imageView1.kf.setImage(with: getImageURL(imagePath: data["image_field1"].string))
            cell.imageView2.kf.setImage(with: getImageURL(imagePath: data["image_field2"].string))
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "linkInfoCell", for: indexPath) as! LinkInfoTableCell
            
            let data = self.linkInfo[indexPath.row]
            
            // set text fields
            cell.dataFields[0].text = data["text_field1"].string
            cell.dataFields[1].text = data["text_field2"].string
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.updateViewConstraints()
        
        if tableView == mainInfoTableView {
            self.mainInfoTableViewHeight.constant = self.mainInfoTableView.contentSize.height
        } else {
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
