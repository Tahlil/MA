//
//  AthleteDiscoveryVC.swift
//  Mission Athletics
//
//  Created by MAC  on 12/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class AthleteDiscoveryVC: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var cvTopPlayers: UICollectionView!
    @IBOutlet weak var cvTopNews: UICollectionView!
    @IBOutlet weak var cvTrainingVideos: UICollectionView!
    @IBOutlet weak var tvTrendingPosts: UITableView!
    @IBOutlet weak var trendingPostsHeight: NSLayoutConstraint!

    //MARK:- Viewlifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.reloadCollViews(collViews: [self.cvTopPlayers, self.cvTopNews, self.cvTrainingVideos], isFirstTime: true)
        
        self.tvTrendingPosts.dataSource = self
        self.tvTrendingPosts.delegate = self
        self.tvTrendingPosts.tableFooterView = UIView()
        self.tvTrendingPosts.reloadData()
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let contentHeight = self.tvTrendingPosts.tableViewHeight + 60.0
        self.trendingPostsHeight.constant = contentHeight
    }
    
    func reloadCollViews(collViews:[UICollectionView], isFirstTime: Bool)
    {
        for view in collViews
        {
            if isFirstTime {
                view.dataSource = self
                view.delegate = self
                view.reloadData()
            } else {
                view.reloadData()
            }
        }
    }
    
    //MARK:- IBActions
    @IBAction func btnSeeAllActions(_ sender: UIButton)
    {
        if sender.tag == 0 {//TopPlayers
            print("See all Top Players")
        } else if sender.tag == 1 {//TopNews
            print("See all Top News")
        } else if sender.tag == 2 {//TrainingVideos
            print("See all Training Videos")
        } else if sender.tag == 3 {//TrendingPosts
            print("See all Trending Posts")
        }
    }
    
    //MARK:- UITextfield delegate methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Prevent first char as space
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        if newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location == 0 && string == " "
        {
            return false
        }//Prevent first char as space
        
        return true
    }
}

//MARK:- UICollectionView datasource delegate methods
extension AthleteDiscoveryVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.cvTopPlayers {
            return 10
        } else if collectionView == self.cvTopNews {
            return 10
        } else if collectionView == self.cvTrainingVideos {
            return 10
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.cvTopPlayers
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopPlayersCell", for: indexPath) as! TopPlayersCell
            
            return cell
        } else if collectionView == self.cvTopNews {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopNewsCell", for: indexPath) as! TopNewsCell
            
            return cell
        } else if collectionView == self.cvTrainingVideos {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrainingVideosCell", for: indexPath) as! TrainingVideosCell
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.cvTopPlayers {
            return CGSize(width: (collectionView.bounds.width) / 5, height: 75)
        } else if collectionView == self.cvTopNews {
            return CGSize(width: (collectionView.bounds.width) / 2.9, height: 215)
        } else if collectionView == self.cvTrainingVideos {
            return CGSize(width: (collectionView.bounds.width) / 1.9, height: 150)
        }
        return CGSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

//MARK:- UITableView datasource delegate methods
//MARK:-
extension AthleteDiscoveryVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let homeCell = tableView.dequeueReusableCell(withIdentifier: "HomeFeedCell") as! HomeFeedCell
        
        homeCell.selectionStyle = .none
        return homeCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 360
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
