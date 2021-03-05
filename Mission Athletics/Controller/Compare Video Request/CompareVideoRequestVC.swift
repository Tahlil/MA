//
//  CompareVideoRequestVC.swift
//  Mission Athletics
//
//  Created by ChiragGajjar on 23/12/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import PDFKit


class CompareVideoRequestVC: UIViewController {
    
    @IBOutlet weak var tblCompareVidep: UITableView!
    
    var arrCompareVideoList = [VideoDataComparisionModel]()
    @IBOutlet var pdfView: PDFView!
    @IBOutlet weak var vwPDFview: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwPDFview.isHidden = true
        getCompareVideoListAPICall()
        
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.vwPDFview.isHidden = true

    }
    //MARK:- API Call
    //MARK:-
    func getCompareVideoListAPICall()
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.viewAllComparisionRequest)
            print(url)
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: [:]) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<ComparisionRequestModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
                        if let data = mapData?.data {
                            self.arrCompareVideoList = data.videodata ?? []
                            
                            if self.arrCompareVideoList.count > 0 {
                                self.tblCompareVidep.reloadData()
                            }else{
                                self.tblCompareVidep.setEmptyMessage("Compare Video not found.")
                                self.tblCompareVidep.reloadData()
                            }
                        }
                        print("success")
                    }else{
                        AlertView.showMessageAlert(mapData?.message ?? "Something went wrong", viewcontroller: self)
                    }
                }else{
                    HideProgress()
                }
            }
        }else{
            AlertView.showMessageAlert(AlertMessage.noInternetConnectionText, viewcontroller: self)
        }
    }
    
}
//MARK:- Tableview Delegate DataSource Methods
//MARK:-
extension CompareVideoRequestVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCompareVideoList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompareVideoCell", for: indexPath) as! CompareVideoCell
        
        let objDetails = arrCompareVideoList[indexPath.row]
        
        cell.setCompareVideoDeails(objDetails)
        
        cell.btnPlayCoachVideo.tag = indexPath.row
        cell.btnPlayCoachVideo.addTarget(self, action: #selector(PlayCoachVideo(sender:)), for: .touchUpInside)
        
        cell.btnPlayAthleteVideo.tag = indexPath.row
        cell.btnPlayAthleteVideo.addTarget(self, action: #selector(PlayAthleteVideo(sender:)), for: .touchUpInside)
        
        cell.btnCompareReport.tag = indexPath.row
        cell.btnCompareReport.addTarget(self, action: #selector(VideoReport(sender:)), for: .touchUpInside)

        if objDetails.report == ""{
            cell.btnCompareReport.isHidden = true
        }else{
            cell.btnCompareReport.isHidden = false
        }
        
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    @objc func VideoReport(sender:UIButton){
        let objDetails = arrCompareVideoList[sender.tag]
        print("play video")
        ShowProgress()
        self.vwPDFview.isHidden = false
        let strURL = objDetails.report ?? ""
        if let path = URL.init(string: strURL){
            if let pdfDocument = PDFDocument(url:path) {
                pdfView.displayMode = .singlePageContinuous
                pdfView.autoScales = true
                pdfView.displayDirection = .horizontal
                pdfView.document = pdfDocument
                HideProgress()
            }else{
                HideProgress()
            }
        }
    }
    
    @objc func PlayCoachVideo(sender:UIButton){
        let objDetails = arrCompareVideoList[sender.tag]
        print("play video")
        if let videoUrl = URL.init(string: objDetails.coachVideourl ?? ""){
            playVideoAvPlayerViewController(videoUrl:videoUrl)
        }
    }
    @objc func PlayAthleteVideo(sender:UIButton){
        let objDetails = arrCompareVideoList[sender.tag]
        print("play video")
        
        if let videoUrl = URL.init(string: objDetails.athleteVideourl ?? ""){
            playVideoAvPlayerViewController(videoUrl:videoUrl)
        }
    }
    //MARK:- Play Video
}

