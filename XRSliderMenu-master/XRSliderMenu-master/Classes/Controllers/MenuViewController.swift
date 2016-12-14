//
//  MenuViewController.swift
//  XRSliderMenu-master
//
//  Created by xuran on 16/2/23.
//  Copyright © 2016年 X.R. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var headImage: UIImageView!
    
    // 点击tableViewCell的回调
    var tapTableClosure: ((IndexPath) -> Void)!
    
    var titleArray: [String] = ["开通会员", "QQ钱包", "个性装扮", "我的收藏", "我的相册", "我的文件"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backImageView.image = UIImage(named: "back")
        self.headImage.layer.cornerRadius = 25.0
        self.headImage.clipsToBounds = true
        self.headImage.layer.borderColor = UIColor.white.cgColor
        self.headImage.layer.borderWidth = 1.5
        
        self.myTableView.register(UINib(nibName: "MyCell", bundle: nil), forCellReuseIdentifier: "MyCell")
        self.myTableView.separatorStyle = .none
        self.myTableView.backgroundColor = UIColor.clear
        let footerVw = Bundle.main.loadNibNamed("MessageFooterView", owner: nil, options: nil)?.first as? MessageFooterView
        footerVw?.backgroundColor = UIColor.clear
        self.myTableView.tableFooterView = footerVw
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var myCell = tableView.dequeueReusableCell(withIdentifier: "MyCell") as? MyCell
        
        if myCell == nil {
            myCell = Bundle.main.loadNibNamed("MyCell", owner: nil, options: nil)?.first as? MyCell
        }
        
        myCell?.selectionStyle = .none
        myCell?.logoImageView.image = UIImage(named: "qq")
        myCell?.titleLabel.text = self.titleArray[indexPath.row]
        
        return myCell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.tapTableClosure != nil {
            self.tapTableClosure(indexPath)
        }
    }
}
