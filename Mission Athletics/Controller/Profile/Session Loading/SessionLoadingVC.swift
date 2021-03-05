//
//  SessionLoadingVC.swift
//  Mission Athletic
//
//  Created by ChiragGajjar on 18/09/19.
//  Copyright © 2019 Trootech. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import TwilioVideo
import CallKit
import AVFoundation

class SessionLoadingVC: UIViewController {
    
    @IBOutlet weak var ImgUser: UIImageView!
    @IBOutlet weak var imgUserBackground: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var vwVideoView: UIView!
    @IBOutlet weak var lblCallTime: UILabel!
    @IBOutlet weak var previewView: VideoView!
    @IBOutlet weak var remoteView: VideoView!
    
    var objBookedSession:Bookedsession?
    
    var strRoomName = ""
    var strGeneratedTotken = ""
    var strSessionID = ""
    // Video SDK components
    var room: Room?
    /**
     * We will create an audio device and manage it's lifecycle in response to CallKit events.
     */
    var audioDevice: DefaultAudioDevice = DefaultAudioDevice()
    var camera: CameraSource?
    var localVideoTrack: LocalVideoTrack?
    var localAudioTrack: LocalAudioTrack?
    var remoteParticipant: RemoteParticipant?
    // CallKit components
    let callKitCallController = CXCallController()
    var callKitCompletionHandler: ((Bool)->Swift.Void?)? = nil
    var userInitiatedDisconnect: Bool = false
    
    let pulsator = Pulsator()
    let pulsatorTime = Pulsator()
    var timerCounter = Timer()
    var totalTime = 900

    var waitTimerCounter = Timer()
    var WaittotalTime = 45

//    required init?(coder aDecoder: NSCoder) {
//        let configuration = CXProviderConfiguration(localizedName: "Mission Athletic")
//        configuration.maximumCallGroups = 2
//        configuration.maximumCallsPerCallGroup = 2
//        configuration.supportsVideo = true
//        configuration.supportedHandleTypes = [.generic]
//
//        callKitCallController = CXCallController()
//
//        super.init(coder: aDecoder)
//    }
    
    
    //MARK:- Viewlifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TwilioVideoSDK.audioDevice = self.audioDevice;
        if timerCounter.isValid{
            timerCounter.invalidate()
        }
        if waitTimerCounter.isValid{
            waitTimerCounter.invalidate()
        }

        if GlobalConstants.appDelegate.notifiObjReqCalling.count == 0{
            
            if let userData = getUserInfo() {
                if userData.user_type == 2 {//coach
                    strRoomName = (objBookedSession?.athleteName ?? "") + (objBookedSession?.bookingTime ?? "")
                    lblMessage.text = "Hi \(userData.name ?? ""), Athlete \(objBookedSession?.athleteName ?? "") should be with you shortly..."
                    
                    if let videoThumbUrl = URL(string: objBookedSession?.athleteImage ?? "") {
                        self.imgUserBackground.sd_setImage(with: videoThumbUrl, placeholderImage: UIImage(), options: .refreshCached, completed: nil)
                        self.ImgUser.sd_setImage(with: videoThumbUrl, placeholderImage: UIImage(), options: .refreshCached, completed: nil)
                    }
                }else{
                    strRoomName = (objBookedSession?.coach_name ?? "") + (objBookedSession?.bookingTime ?? "")
                    lblMessage.text = "Hi \(userData.name ?? ""), Coach \(objBookedSession?.coach_name ?? "") should be with you shortly..."
                    if let videoThumbUrl = URL(string: objBookedSession?.coach_image ?? "") {
                        self.imgUserBackground.sd_setImage(with: videoThumbUrl, placeholderImage: UIImage(), options: .refreshCached, completed: nil)
                        self.ImgUser.sd_setImage(with: videoThumbUrl, placeholderImage: UIImage(), options: .refreshCached, completed: nil)
                    }
                }
                ImgUser.cornerRadius = ImgUser.frame.height / 2
                ImgUser.clipsToBounds = true
                strSessionID = "\(objBookedSession?.id ?? 0)"
            }
        }else{
            strRoomName = GlobalConstants.appDelegate.notifiObjReqCalling["room_name"] as? String ?? ""
            strSessionID = GlobalConstants.appDelegate.notifiObjReqCalling["id"] as? String ?? ""
        }
        
        CallingAnimation()
        GenerateCallTokenAPICall(strRoomName: strRoomName)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.layoutIfNeeded()
        pulsator.position = ImgUser.layer.position
        pulsatorTime.position = lblCallTime.layer.position
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    deinit {
        timerCounter.invalidate()
        waitTimerCounter.invalidate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        if let room = room, let uuid = room.uuid {
            userInitiatedDisconnect = true
            self.audioDevice.isEnabled = true
            performEndCallAction(uuid: uuid)
        }
        self.localAudioTrack = nil
        self.localVideoTrack = nil

        room?.disconnect()
        if timerCounter.isValid{
            timerCounter.invalidate()
        }
        
    }
    func SendCallRecieverCallAPICall(strRoomName:String){
        if Reachability.isConnectedToNetwork(){
            ShowProgress()
            var strSenderID = ""
            var strReceiverID = ""
            
            if let userData = getUserInfo() {
                if userData.user_type == 2 {//coach
                    strSenderID = "\(userData.id ?? 0)"
                    strReceiverID = "\(objBookedSession?.athleteId ?? 0)"
                }else{
                    strSenderID = "\(userData.id ?? 0)"
                    strReceiverID = "\(objBookedSession?.coachId ?? 0)"
                }
            }
            
            let url = WebService.createURLForWebService(WebService.sendPushNotificationToReciever)
            print(url)
            
            let reqParams:[String:Any] = ["room_name":strRoomName,"sender_id":strSenderID,"receiver_id":strReceiverID]
            print(reqParams)
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: reqParams) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true{
                    HideProgress()
                    let mapData  = Mapper<TokenGenerateModel>().map(JSONString: result!)
                    if mapData?.code == "200"{
                        print("success")
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5.0) {
                            
                            self.connectToCall()
                        }
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
    
    func connectToCall(){
        if PlatformUtils.isSimulator {
            self.previewView.removeFromSuperview()
        } else {
            // Preview our local camera track in the local video preview view.
            self.startPreview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5.0) {
            
            self.performRoomConnect(uuid: UUID(), roomName: self.strRoomName) { (success) in
                if (success) {
                    print("Room Conected")
                    self.pulsator.stop()
                    self.CallingTimeAnimation()
                    self.vwVideoView.isHidden = false
                } else {
                    print("Room Not conected")
                    self.vwVideoView.isHidden = true
                    if let room = self.room, let uuid = room.uuid {
                        self.userInitiatedDisconnect = true
                        self.audioDevice.isEnabled = false
                        self.performEndCallAction(uuid: uuid)
                    }
                    self.room?.disconnect()
                }
            }
        }
    }
    
    //MARK:- Calling Animation Methods
    private func CallingAnimation() {
        pulsator.position = ImgUser.layer.position
        pulsator.numPulse = 8
        pulsator.radius = 150
        pulsator.fromValueForRadius = 10
        pulsator.animationDuration = 8
        pulsator.backgroundColor = UIColor.appBlueColor.cgColor
        ImgUser.layer.superlayer?.insertSublayer(pulsator, below: ImgUser.layer)
        pulsator.start()
    }
    
    private func CallingTimeAnimation() {
        pulsatorTime.position = lblCallTime.layer.position
        pulsatorTime.numPulse = 3
        pulsatorTime.radius = 45
        pulsatorTime.animationDuration = 5
        pulsatorTime.backgroundColor = UIColor.appOrangeColor.cgColor
        lblCallTime.layer.superlayer?.insertSublayer(pulsatorTime, below: lblCallTime.layer)
        pulsatorTime.start()
    }
    
    
    
    //MARK:- IBActions
    @IBAction func btnCancelSession(_ sender: UIButton) {
        
         self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCloseVideoCall(_ sender: UIButton) {
        
        if let room = room, let uuid = room.uuid {
            userInitiatedDisconnect = true
            self.audioDevice.isEnabled = true
            performEndCallAction(uuid: uuid)
        }
        room?.disconnect()
        
        vwVideoView.isHidden = true
        CompleteCallAPICall()
    }
    
    //MARK:- API Calling
    func CompleteCallAPICall(){
        if Reachability.isConnectedToNetwork()
        {
            ShowProgress()
            //1= Accept, 2 = Cancel, 3 = Completed, 4= Reject
            let url = WebService.createURLForWebService(WebService.acceptCancelSessionRequest)
            var reqParam:[String:Any] = [:]
            reqParam["subscription_id"] = "3"
            reqParam["session_status"] = "3"
            if objBookedSession?.subscriptionType == "free"{
                reqParam["athlete_subscription_id"] = strSessionID
            }else{
                reqParam["booked_session_id"] = strSessionID
            }

            print(url)
            print(reqParam)
            
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: reqParam) { (result, IsSuccess) in
                print(result as Any)
                if IsSuccess == true{
                    HideProgress()
                    if result?.contains("error") ?? false{
                        let mapData  = Mapper<TokenDetailsErorModel>().map(JSONString: result!)
                        AlertView.showMessageAlert(mapData?.error?.message ?? "Something went wrong", viewcontroller: self)
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    HideProgress()
                }
            }
        }else{
            AlertView.showMessageAlert(AlertMessage.noInternetConnectionText, viewcontroller: self)
        }
    }

    
    func GenerateCallTokenAPICall(strRoomName:String){
        if Reachability.isConnectedToNetwork(){
            ShowProgress()
            
            let url = WebService.createURLForWebService(WebService.twillioToken)
            print(url)
            
            let reqParams:[String:Any] = ["room_name":strRoomName,"identity":randomString()]
            print(reqParams)
            ServiceRequestResponse.servicecallWithHeader(VC: UIViewController(), url: url, HttpMethod: .post, InputParameter: reqParams) { (result, IsSuccess) in
//                print(result as Any)
                if IsSuccess == true{
                    HideProgress()
                    let mapData  = Mapper<TokenGenerateModel>().map(JSONString: result!)
                    if mapData?.code == "200"{
                        print("success")
                        self.strGeneratedTotken = mapData?.data?.token ?? ""
                        if GlobalConstants.appDelegate.notifiObjReqCalling.count == 0{
                            self.SendCallRecieverCallAPICall(strRoomName: strRoomName)
                        }else{
                            GlobalConstants.appDelegate.notifiObjReqCalling = [:]
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5.0) {
                                self.connectToCall()
                            }
                        }
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
    
    func startTimer() {
        self.totalTime = 900
        timerCounter = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerDiscount), userInfo: nil, repeats: true)
    }
    
    @objc func timerDiscount() {
        print(self.totalTime)
        self.lblCallTime.text = self.timeFormatted(self.totalTime) // will show timer
        if totalTime != 0 {
            totalTime -= 1  // decrease counter timer
        } else {
            if self.timerCounter.isValid {
                timerCounter.invalidate()
                waitTimerCounter.invalidate()
                CompleteCallAPICall()
            }
        }
    }
    
    func waitForUserConnectToRoomTimer() {
        self.WaittotalTime = 45
        waitTimerCounter = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(waitForConnect), userInfo: nil, repeats: true)
    }
    @objc func waitForConnect() {
        print(self.WaittotalTime)
        if WaittotalTime != 0 {
            WaittotalTime -= 1  // decrease counter timer
        } else {
            if self.waitTimerCounter.isValid {
                waitTimerCounter.invalidate()
                if self.timerCounter.isValid {
                    timerCounter.invalidate()
                }
                AlertView.showAlert("", strMessage: "Person you are calling cannot accept calls at this time.", button: ["Okay"], viewcontroller: self, blockButtonClicked: { (button) in
                    if button == 0{
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            }
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

   
}

extension SessionLoadingVC  {
    
    func muteAudio(isMuted: Bool) {
        if let localAudioTrack = self.localAudioTrack {
            localAudioTrack.isEnabled = !isMuted
            
            // Update the button title
            if (!isMuted) {
                //  self.micButton.setTitle("Mute", for: .normal)
            } else {
                //  self.micButton.setTitle("Unmute", for: .normal)
            }
        }
    }
    
    // MARK:- Private
    func startPreview() {
        if PlatformUtils.isSimulator {
            return
        }
        
        let frontCamera = CameraSource.captureDevice(position: .front)
        let backCamera = CameraSource.captureDevice(position: .back)
        
        if (frontCamera != nil || backCamera != nil) {
            // Preview our local camera track in the local video preview view.
            camera = CameraSource(delegate: self)
            localVideoTrack = LocalVideoTrack(source: camera!, enabled: true, name: "Camera")
            
            // Add renderer to video track for local preview
            localVideoTrack!.addRenderer(self.previewView)
            print("Video track created")
            
            if (frontCamera != nil && backCamera != nil) {
                // We will flip camera on tap.
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.flipCamera))
                self.previewView.addGestureRecognizer(tap)
            }
            
            camera!.startCapture(device: frontCamera != nil ? frontCamera! : backCamera!) { (captureDevice, videoFormat, error) in
                if let error = error {
                    print("Capture failed with error.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                } else {
                    self.previewView.shouldMirror = (captureDevice.position == .front)
                }
            }
        }
        else {
            print("No front or back capture device found!")
        }
    }
    
    @objc func flipCamera() {
        var newDevice: AVCaptureDevice?
        
        if let camera = self.camera, let captureDevice = camera.device {
            if captureDevice.position == .front {
                newDevice = CameraSource.captureDevice(position: .back)
            } else {
                newDevice = CameraSource.captureDevice(position: .front)
            }
            
            if let newDevice = newDevice {
                camera.selectCaptureDevice(newDevice) { (captureDevice, videoFormat, error) in
                    if let error = error {
                        print("Error selecting capture device.\ncode = \((error as NSError).code) error = \(error.localizedDescription)")
                    } else {
                        self.previewView.shouldMirror = (captureDevice.position == .front)
                    }
                }
            }
        }
    }
    
    func prepareLocalMedia() {
        // We will share local audio and video when we connect to the Room.
        
        // Create an audio track.
        if (localAudioTrack == nil) {
            localAudioTrack = LocalAudioTrack()
            
            if (localAudioTrack == nil) {
                print("Failed to create audio track")
            }
        }
        
        // Create a video track which captures from the camera.
        if (localVideoTrack == nil) {
            self.startPreview()
        }
    }
    
    func renderRemoteParticipant(participant : RemoteParticipant) -> Bool {
        // This example renders the first subscribed RemoteVideoTrack from the RemoteParticipant.
        let videoPublications = participant.remoteVideoTracks
        for publication in videoPublications {
            if let subscribedVideoTrack = publication.remoteTrack,
                publication.isTrackSubscribed {
                subscribedVideoTrack.addRenderer(self.remoteView)
                self.remoteParticipant = participant
//                remoteView.backgroundColor = .yellow
                //                self.view.sendSubviewToBack(self.vwremoteView)
                view.setNeedsLayout()
                view.layoutIfNeeded()
                return true
            }
        }
        return false
    }
    
    func renderRemoteParticipants(participants : Array<RemoteParticipant>) {
        for participant in participants {
            // Find the first renderable track.
            if participant.remoteVideoTracks.count > 0,
                renderRemoteParticipant(participant: participant) {
                break
            }
        }
    }
    
    func cleanupRemoteParticipant() {
        if self.remoteParticipant != nil {
            self.remoteView?.removeFromSuperview()
            self.remoteView = nil
            self.remoteParticipant = nil
        }
    }
    func holdCall(onHold: Bool) {
        localAudioTrack?.isEnabled = !onHold
        localVideoTrack?.isEnabled = !onHold
    }
}

// MARK:- RoomDelegate
extension SessionLoadingVC : RoomDelegate {
    func roomDidConnect(room: Room) {
        // At the moment, this example only supports rendering one Participant at a time.
        
        print("Connected to room \(room.name) as \(room.localParticipant?.identity ?? "")")
        // This example only renders 1 RemoteVideoTrack at a time. Listen for all events to decide which track to render.
        startTimer()
        waitForUserConnectToRoomTimer()

        if (room.remoteParticipants.count > 0) {
            self.remoteParticipant = room.remoteParticipants[0]
            self.remoteParticipant?.delegate = self
        }
        self.callKitCompletionHandler!(true)
    }
    
    func roomDidDisconnect(room: Room, error: Error?) {
        print("Disconnected from room \(room.name), error = \(String(describing: error))")
        
        self.cleanupRemoteParticipant()
        self.room = nil
        self.callKitCompletionHandler = nil
        self.userInitiatedDisconnect = false
    }
    
    func roomDidFailToConnect(room: Room, error: Error) {
        print("Failed to connect to room with error: \(error.localizedDescription)")
        
        self.callKitCompletionHandler!(false)
        self.room = nil
    }
    
    func roomIsReconnecting(room: Room, error: Error) {
        print("Reconnecting to room \(room.name), error = \(String(describing: error))")
    }
    
    func roomDidReconnect(room: Room) {
        print("Reconnected to room \(room.name)")
    }
    
    func participantDidConnect(room: Room, participant: RemoteParticipant) {
        // Listen for events from all Participants to decide which RemoteVideoTrack to render.
        if (self.remoteParticipant == nil) {
            self.remoteParticipant = participant
            self.remoteParticipant?.delegate = self
        }

        print("Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
        print("Participant Room\(room.name) connected ")

        if waitTimerCounter.isValid{
            waitTimerCounter.invalidate()
        }
        
    }
    
    func participantDidDisconnect(room: Room, participant: RemoteParticipant) {
        print("Room \(room.name), Participant \(participant.identity) disconnected")
        
        self.navigationController?.popViewController(animated: true)
        // Nothing to do in this example. Subscription events are used to add/remove renderers.
    }
}

// MARK:- RemoteParticipantDelegate
extension SessionLoadingVC : RemoteParticipantDelegate {
    func remoteParticipantDidPublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has offered to share the video Track.
        
        print("Participant \(participant.identity) published video track")
    }
    
    func remoteParticipantDidUnpublishVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        // Remote Participant has stopped sharing the video Track.
        
        print("Participant \(participant.identity) unpublished video track")
    }
    
    func remoteParticipantDidPublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        // Remote Participant has offered to share the audio Track.
        
        print("Participant \(participant.identity) published audio track")
    }
    
    func remoteParticipantDidUnpublishAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        print("Participant \(participant.identity) unpublished audio track")
    }
    
    func didSubscribeToVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // The LocalParticipant is subscribed to the RemoteParticipant's video Track. Frames will begin to arrive now.
        
        print("Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")
        
        if waitTimerCounter.isValid{
            waitTimerCounter.invalidate()
        }
        if (self.remoteParticipant == participant) {
            self.remoteView.shouldMirror = true
            self.remoteView.contentMode = .scaleAspectFit
            let isTrue = renderRemoteParticipant(participant: participant)
            print(isTrue)
        }

    }
    
    func didUnsubscribeFromVideoTrack(videoTrack: RemoteVideoTrack, publication: RemoteVideoTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
        // remote Participant's video.
        
        print("Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")
        
        if self.remoteParticipant == participant {
            cleanupRemoteParticipant()
            
            // Find another Participant video to render, if possible.
            if var remainingParticipants = room?.remoteParticipants,
                let index = remainingParticipants.index(of: participant) {
                remainingParticipants.remove(at: index)
                renderRemoteParticipants(participants: remainingParticipants)
            }
        }
    }
    
    func didSubscribeToAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are subscribed to the remote Participant's audio Track. We will start receiving the
        // remote Participant's audio now.
        
        print("Subscribed to audio track for Participant \(participant.identity)")
    }
    
    func didUnsubscribeFromAudioTrack(audioTrack: RemoteAudioTrack, publication: RemoteAudioTrackPublication, participant: RemoteParticipant) {
        // We are unsubscribed from the remote Participant's audio Track. We will no longer receive the
        // remote Participant's audio.
        
        print("Unsubscribed from audio track for Participant \(participant.identity)")
    }
    
    func remoteParticipantDidEnableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        print("Participant \(participant.identity) enabled video track")
    }
    
    func remoteParticipantDidDisableVideoTrack(participant: RemoteParticipant, publication: RemoteVideoTrackPublication) {
        print("Participant \(participant.identity) disabled video track")
    }
    
    func remoteParticipantDidEnableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        print("Participant \(participant.identity) enabled audio track")
    }
    
    func remoteParticipantDidDisableAudioTrack(participant: RemoteParticipant, publication: RemoteAudioTrackPublication) {
        print("Participant \(participant.identity) disabled audio track")
    }
    
    func didFailToSubscribeToAudioTrack(publication: RemoteAudioTrackPublication, error: Error, participant: RemoteParticipant) {
        print("FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
    }
    
    func didFailToSubscribeToVideoTrack(publication: RemoteVideoTrackPublication, error: Error, participant: RemoteParticipant) {
        print("FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
    }
}

// MARK:- VideoViewDelegate
extension SessionLoadingVC : VideoViewDelegate {
    func videoViewDimensionsDidChange(view: VideoView, dimensions: CMVideoDimensions) {
        self.view.setNeedsLayout()
    }
}

// MARK:- CameraSourceDelegate
extension SessionLoadingVC : CameraSourceDelegate {
    func cameraSourceDidFail(source: CameraSource, error: Error) {
        print("Camera source failed with error: \(error.localizedDescription)")
    }
}

// MARK:- Call Kit Actions
extension SessionLoadingVC {
    
    func performEndCallAction(uuid: UUID) {
        let endCallAction = CXEndCallAction(call: uuid)
        let transaction = CXTransaction(action: endCallAction)
        
        callKitCallController.request(transaction) { error in
            if let error = error {
                NSLog("EndCallAction transaction request failed: \(error.localizedDescription).")
                return
            }
            NSLog("EndCallAction transaction request successful")
        }
    }
    
    func performRoomConnect(uuid: UUID, roomName: String? , completionHandler: @escaping (Bool) -> Swift.Void) {
        // Configure access token either from server or manually.
        // If the default wasn't changed, try fetching from server.
        
        // Prepare local media which we will share with Room Participants.
        self.prepareLocalMedia()
        print("Token:-\(strGeneratedTotken)")
        // Preparing the connect options with the access token that we fetched (or hardcoded).
        let connectOptions = ConnectOptions(token: strGeneratedTotken) { (builder) in
            
            // Use the local media that we prepared earlier.
            builder.audioTracks = self.localAudioTrack != nil ? [self.localAudioTrack!] : [LocalAudioTrack]()
            builder.videoTracks = self.localVideoTrack != nil ? [self.localVideoTrack!] : [LocalVideoTrack]()
            
            // Use the preferred audio codec
            if let preferredAudioCodec = Settings.shared.audioCodec {
                builder.preferredAudioCodecs = [preferredAudioCodec]
            }
            
            // Use the preferred video codec
            if let preferredVideoCodec = Settings.shared.videoCodec {
                builder.preferredVideoCodecs = [preferredVideoCodec]
            }
            
            // Use the preferred encoding parameters
            if let encodingParameters = Settings.shared.getEncodingParameters() {
                builder.encodingParameters = encodingParameters
            }
            
            // Use the preferred signaling region
            if let signalingRegion = Settings.shared.signalingRegion {
                builder.region = signalingRegion
            }
            // The name of the Room where the Client will attempt to connect to. Please note that if you pass an empty
            // Room `name`, the Client will create one for you. You can get the name or sid from any connected Room.
            builder.roomName = roomName
            // The CallKit UUID to assoicate with this Room.
            builder.uuid = uuid
        }
        // Connect to the Room using the options we provided.
        room = TwilioVideoSDK.connect(options: connectOptions, delegate: self)
        
        print("Attempting to connect to room \(roomName ?? "")")
        self.callKitCompletionHandler = completionHandler
    }
}
