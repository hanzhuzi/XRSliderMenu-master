//
//  PerspectBottomViewController.swift
//  XRSliderMenu-master
//
//  Created by xuran on 16/12/9.
//  Copyright © 2016年 X.R. All rights reserved.
//

///  底部视图控制器

import UIKit

@objc protocol PerspectBottomViewControllerDelegate: NSObjectProtocol {
    
    @objc func didTapCloseItem()
}

class PerspectBottomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var segmentControl: UISegmentedControl!
    var myTableView: UITableView!
    weak var delegate: PerspectBottomViewControllerDelegate?
    
    lazy var dataArray: [String] = ["好言相券", "个人资料", "账户安全", "地址管理", "推送消息设置", "我要反馈", "清除缓存", "帮助中心", "客户电话", "关于我们"]
    var widthForTable: CGFloat = 0.0 {
        
        didSet {
            self.myTableView.frame = CGRect(x: 0, y: 0, width: widthForTable, height: self.view.frame.height)
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.myTableView.frame.width, height: 80.0))
            headerView.backgroundColor = UIColor.clear
            self.myTableView.tableHeaderView = headerView
        }
    }
    
    func closeBtnAction() {
        
        if delegate != nil && delegate!.responds(to: #selector(PerspectBottomViewControllerDelegate.didTapCloseItem)) {
            delegate!.didTapCloseItem()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: widthForTable, height: self.view.frame.height), style: .grouped)
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.myTableView.backgroundColor = UIColor.clear
        self.myTableView.separatorStyle = .none
        self.myTableView.showsVerticalScrollIndicator = false
        self.myTableView.showsHorizontalScrollIndicator = false
        self.view.addSubview(self.myTableView)
        
        let closeBtn = UIButton(type: .custom)
        closeBtn.frame = CGRect(x: 12.0, y: 20.0, width: 32.0, height: 32.0)
        closeBtn.setImage(UIImage(named: "close"), for: .normal)
        closeBtn.addTarget(self, action: #selector(self.closeBtnAction), for: .touchUpInside)
        self.view.addSubview(closeBtn)
        
        let exitBtn = UIButton(type: .custom)
        exitBtn.frame = CGRect(x: self.view.frame.maxX - 100.0 - 30.0, y: self.view.frame.maxY - 32.0 - 25.0, width: 100.0, height: 32.0)
        exitBtn.setTitle("退出登录", for: .normal)
        exitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        exitBtn.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(exitBtn)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell")
        
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "tableViewCell")
        }
        
        cell?.selectionStyle = .gray
        cell?.textLabel?.textColor = UIColor.white
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 15.0)
        cell?.textLabel?.text = dataArray[indexPath.row]
        cell?.backgroundColor = UIColor.clear
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    
}



