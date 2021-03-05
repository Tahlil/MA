//
//  CallingVC.swift
//  Mission Athletics
//
//  Created by ChiragGajjar on 26/03/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import AVFoundation
import ObjectMapper

class CallingVC: UIViewController {

    @IBOutlet weak var lblCallerTitle: UILabel!

    var player: AVAudioPlayer?

    func playSound() {
        guard let url = Bundle.main.url(forResource: "ringtone", withExtension: "caf") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        playSound()
        // Do any additional setup after loading the view.
    }
    //MARK:- Button Action
    //MARK:-
    @IBAction func btnAccept(_ sender: UIButton) {
        GlobalConstants.appDelegate.notifiObjHome = "videoCall"
        
        if let _ = getUserInfo() {//userData
            if let tabVC = GlobalConstants.MainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as? TabBarVC {
                tabVC.selectedIndex = 0
            }
            NotificationCenter.default.post(name: Notification.Name("changeSelectedIndexForHome"), object: GlobalConstants.appDelegate.notifiObjReqCalling)
        }
    }
    @IBAction func btnReject(_ sender: UIButton) {
        cancelCallAPICall()
        self.navigationController?.popViewController(animated: false)
    }

    //MARK:- API Call -
    func cancelCallAPICall()
    {
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.cancelCall)
            print(url)
            var reqParam:[String: Any] = [:]
            reqParam["sender_id"] = "\(0)"
            reqParam["receiver_id"] = "\(0)"

            print(reqParam)
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .get, InputParameter: reqParam) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true
                {
                    HideProgress()
                    
                    let mapData  = Mapper<GetSettingsResModel>().map(JSONString: result!)
                    if mapData?.code == "200"
                    {
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
