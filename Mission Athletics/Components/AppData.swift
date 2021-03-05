//
//  AppData.swift
//  Mission Athletics
//
//  Created by ChiragGajjar on 26/11/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class AppData: NSObject {
    static let shared = AppData()
    
    
    //TableView footer loader methods
    class func showLoaderInFooter(on tableView: UITableView)
    {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = false
    }
    
    class func hideLoaderInFooter(on tableView: UITableView)
    {
        tableView.tableFooterView = nil
        tableView.tableFooterView?.isHidden = true
    }
    
    
    class func showLoaderInHeader(on tableView: UITableView)
    {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        tableView.tableHeaderView = spinner
        tableView.tableHeaderView?.isHidden = false
    }
    
    class func hideLoaderInHeader(on tableView: UITableView)
    {
        tableView.tableHeaderView = nil
        tableView.tableHeaderView?.isHidden = true
    }

}
