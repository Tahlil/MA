//
//  BookingSelectPackageVC.swift
//  Mission Athletics
//
//  Created by MAC  on 13/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class BookingSelectPackageVC: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var ivVideoThumb: UIImageView!
    @IBOutlet weak var lblBookSession: UILabel!
    @IBOutlet weak var lblWithCoach: UILabel!
    @IBOutlet weak var vwCoachRating: CosmosView!
    @IBOutlet weak var lblPackagesAvailable: UILabel!
    @IBOutlet weak var lblEligibleInfo: UILabel!
    @IBOutlet weak var tvSessions: UITableView!
    @IBOutlet weak var tvSessionsHeight: NSLayoutConstraint!
    @IBOutlet weak var btnBookSession: UIButton!
    
    //Popup
    @IBOutlet weak var vwConfirmationPopup: UIView!
    @IBOutlet weak var vwConfirmSubPopup: UIView!
    @IBOutlet weak var vwSubscribedPopup: UIView!
    @IBOutlet weak var lblSubscribedTo: UILabel!
    
    var selectedIndex = -1
    
    //MARK:- Viewlifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tvSessions.dataSource = self
        self.tvSessions.delegate = self
        self.tvSessions.estimatedRowHeight = 70
        self.tvSessions.rowHeight = UITableView.automaticDimension
        self.tvSessions.tableFooterView = UIView()
        self.tvSessions.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setTableHeight()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    func setTableHeight()
    {
        let height = self.tvSessions.tableViewHeight
        self.tvSessionsHeight.constant = height
    }
    
    //MARK:- IBActions
    @IBAction func btnBookMySessionAction(_ sender: UIButton)
    {
        let nextVC = GlobalConstants.SessionStoryboard.instantiateViewController(withIdentifier: "UpcomingSessionVC") as! UpcomingSessionVC
        self.navigationController?.pushViewController(nextVC, animated: true)

    }
    
    //Popup actions
    @IBAction func btnConfirmAction(_ sender: UIButton)
    {
        
    }
    
    @IBAction func btnNeverMindAction(_ sender: UIButton)
    {
        
    }
    
    @IBAction func btnGoBackPopupAction(_ sender: UIButton)
    {
        
    }
    
    //UITableView datasource delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedIndex != -1
        {
            if indexPath.row == self.selectedIndex {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BookSessionSelectedCell") as! BookSessionSelectedCell
                
                cell.contentView.alpha = 1.0
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BookSessionCell") as! BookSessionCell
               
                cell.contentView.alpha = 0.3
                cell.selectionStyle = .none
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookSessionCell") as! BookSessionCell
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.tvSessions.reloadData()
        self.setTableHeight()
        
        self.btnBookSession.backgroundColor = UIColor.greenSubscribe
        self.btnBookSession.setTitle("Book My Free Session", for: .normal)
    }
}
