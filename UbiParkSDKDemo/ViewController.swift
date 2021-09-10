//
//  ViewController.swift
//  UbiParkSDKDemo
//
//  Created by Admin on 10/1/21.
//

/*
 
https://stackoverflow.com/questions/63932158/xcode12-issus-ld-building-for-ios-simulator-but-linking-in-object-file-built

 Exclude arm64 for "Any iOS Simulator SDK"

*/

import UIKit
import UbiParkSDK
import Toaster

class ViewController: UIViewController {
    @IBOutlet weak var closestLaneLabel: UITextField!
    
    let beaconService = BeaconService()
    let username = "test1@ubipark.com" // Username
    let password = "test1" // Password

    override func viewDidLoad() {
        super.viewDidLoad()

        // Request location
        BlueCatsSDK.requestAlwaysLocationAuthorization()
        
        UbiParkSDKConfig.setServerName(serverName: "https://staging.ubipark.com") // Production api is located: https://api.ubipark.com

        // Set supplied configuration secrets
        UbiParkSDKConfig.setAppId(appId: "{ADD YOUR AppID HERE") // AppID
        UbiParkSDKConfig.setBeaconToken(beaconToken: "ADD YOUR BeaconToken HERE") // BeaconToken
        UbiParkSDKConfig.setClientSecret(clientSecret: "ADD YOU ClientSecret HERE") // Client Secret
       
        UbiParkSDKConfig.setBeaconLogLevel(beaconLogLevel: BeaconLogLevel.verbose)
        
        // When app is sent to background call beaconService.onBackground()
        //beaconService.onBackground()
        
        // When app returns to foreground call beaconService.onForeground
        //beaconService.onForeground()
    }

    @IBAction func createClick(_ sender: Any) {
        let spinner = showLoader(view: self.view)

        let email = ""
        let password = ""
        let firstname = ""
        let lastname = ""
        let phoneNo = ""
        
        let userRequest = UserRequest()
        userRequest.email = email
        userRequest.password = password
        userRequest.firstname = firstname
        userRequest.lastname = lastname
        userRequest.phoneNo = phoneNo
        
        let userResult = UserAPI.create(userRequest: userRequest)


        do {
            let jsonData = try JSONEncoder().encode(userResult)
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
            NSLog("Create result:" + jsonString)
            let toast = Toast(text: "Create result:" + jsonString, duration: Delay.long)
            toast.show()
            
            if (userResult.result == "Success") {
                UbiParkSDKConfig.setUserId(userId: userResult.userId)
                UbiParkSDKConfig.setUserToken(userToken: userResult.authenticationToken)
            }
        } catch {
            NSLog(error.localizedDescription)
        }

        spinner.dismissLoader()
    }
    
    @IBAction func createUserClick(_ sender: Any) {
        let spinner = showLoader(view: self.view)

        let email = "test99@ubipark.com"
        let firstname = "TestFirstName"
        let lastname = "TestLastName"
        let phoneNo = "+61414000000"
        
        
        let createUserRequest = CreateUserRequest()
        createUserRequest.email = email
        createUserRequest.firstname = firstname
        createUserRequest.lastname = lastname
        createUserRequest.phoneNo = phoneNo
        
        let createUserResult = UserAPI.createUser(createUserRequest: createUserRequest)

        do {
            let jsonData = try JSONEncoder().encode(createUserResult)
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
            NSLog("CreateUser result:" + jsonString)
            let toast = Toast(text: "CreateUser result:" + jsonString, duration: Delay.long)
            toast.show()
            
            if (createUserResult.result == "Success") {
                UbiParkSDKConfig.setUserId(userId: createUserResult.userId)
                UbiParkSDKConfig.setUserToken(userToken: createUserResult.authenticationToken)
            }
        } catch {
            NSLog(error.localizedDescription)
        }
       
        spinner.dismissLoader()
    }
    
    @IBAction func loginClick(_ sender: Any) {
        let spinner = showLoader(view: self.view)
        
        let loginResult = UserAPI.login(username: username, password: password)

        do {
            let jsonData = try JSONEncoder().encode(loginResult)
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
            NSLog("Login result:" + jsonString)
            let toast = Toast(text: "Login result:" + jsonString, duration: Delay.long)
            toast.show()

            if (loginResult.result == "Success") {
                UbiParkSDKConfig.setUserId(userId: loginResult.userId)
                UbiParkSDKConfig.setUserToken(userToken: loginResult.authenticationToken)
            } else {
                UbiParkSDKConfig.resetUser()
            }
        } catch {
            NSLog(error.localizedDescription)
        }
    
        spinner.dismissLoader()
    }
    
    @IBAction func detailClick(_ sender: Any) {
        let spinner = showLoader(view: self.view)
        
        let detailsResult = UserAPI.detail()

        do {
            let jsonData = try JSONEncoder().encode(detailsResult)
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
            NSLog("UserDetail result:" + jsonString)
            let toast = Toast(text: "UserDetail result:" + jsonString, duration: Delay.long)
            toast.show()
        } catch {
            NSLog(error.localizedDescription)
        }

        spinner.dismissLoader()
    }
    
    @IBAction func updateClick(_ sender: Any) {
        let spinner = showLoader(view: self.view)
        
        let detailsResult = UserAPI.detail()
        let updateRequest = UpdateRequest()
        updateRequest.email = detailsResult.email
        updateRequest.firstName = detailsResult.firstName
        updateRequest.lastName = detailsResult.lastName
        updateRequest.phoneNo = detailsResult.phoneNo
 
        // Just append an x to the user's last name
        updateRequest.lastName = updateRequest.lastName + "x"
        
        let updateResult = UserAPI.update(updateRequest: updateRequest)
        
        do {
            let jsonData = try JSONEncoder().encode(updateResult)
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
            NSLog("Update result:" + jsonString)
            let toast = Toast(text: "Update result:" + jsonString, duration: Delay.long)
            toast.show()
        } catch {
            NSLog(error.localizedDescription)
        }
        
        spinner.dismissLoader()
    }
    
    @IBAction func statusClick(_ sender: Any) {
        let spinner = showLoader(view: self.view)
        
        let statusResult = UserAPI.status()
        
        do {
            let jsonData = try JSONEncoder().encode(statusResult)
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
            NSLog("Status result:" + jsonString)
            let toast = Toast(text: "Status result:" + jsonString, duration: Delay.long)
            toast.show()
            
            if (statusResult.result == "Success") {
                // Set the status of the user, so that the beacon service
                // knows where state the user is in
                // e.g. if user is not in car park then search for entry beacons
                //      if user is in car park search for exit beacons
                beaconService.setUserStatus(userStatus: statusResult)
            }
        } catch {
            NSLog(error.localizedDescription)
        }
        
        spinner.dismissLoader()
    }
    
    @IBAction func authTokenClick(_ sender: Any) {
        let spinner = showLoader(view: self.view)
        
        var authTokenResult = UserAPI.authToken(email: "test1@ubipark.com", userId: nil)

        do {
            let jsonData = try JSONEncoder().encode(authTokenResult)
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
            NSLog("AuthToken result:" + jsonString)
            let toast = Toast(text: "AuthToken result:" + jsonString, duration: Delay.long)
            toast.show()
        } catch {
            NSLog(error.localizedDescription)
            return
        }
        
        authTokenResult = UserAPI.authToken(email: nil, userId: 69358)

        do {
            let jsonData = try JSONEncoder().encode(authTokenResult)
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
            NSLog("AuthToken result #2:" + jsonString)
            let toast = Toast(text: "AuthToken result #2:" + jsonString, duration: Delay.long)
            toast.show()
        } catch {
            NSLog(error.localizedDescription)
        }
        
        spinner.dismissLoader()
    }

    @IBAction func carParkDetailClick(_ sender: Any) {
        let spinner = showLoader(view: self.view)
        
        let testBeaconID = "7134D0B8-49DF-487B-B2A5-0ED7CAAB2818:5:8"
        
        let detailsResult = CarParkAPI.detail(beaconID: testBeaconID, carParkID: nil)

        do {
            let jsonData = try JSONEncoder().encode(detailsResult)
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
            NSLog("CarPark Detail result:" + jsonString)
            let toast = Toast(text: "CarPark Detail result:" + jsonString, duration: Delay.long)
            toast.show()
        } catch {
            NSLog(error.localizedDescription)
        }
        
        spinner.dismissLoader()
    }
    
    @IBAction func enterClick(_ sender: Any) {
        let spinner = showLoader(view: self.view)
        
        let laneId:Int64 = 290 // Test entry lane
        
        let enterResult = CarParkAPI.enter(laneId: laneId, calculatedLaneId: nil)

        do {
            let jsonData = try JSONEncoder().encode(enterResult)
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
            NSLog("CarPark Enter result:" + jsonString)
            let toast = Toast(text: "CarPark Enter result:" + jsonString, duration: Delay.long)
            toast.show()
        } catch {
            NSLog(error.localizedDescription)
        }
        
        spinner.dismissLoader()
    }

    @IBAction func exitClick(_ sender: Any) {
        let spinner = showLoader(view: self.view)
        
        let laneId:Int64 = 293 // Test exit lane
        
        let exitResult = CarParkAPI.exit(laneId: laneId, calculatedLaneId: laneId)
        NSLog("carParkExit result:")

        do {
            let jsonData = try JSONEncoder().encode(exitResult)
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
            NSLog("CarPark Exit result:" + jsonString)
            let toast = Toast(text: "CarPark Exit result:" + jsonString, duration: Delay.long)
            toast.show()
        } catch {
            NSLog(error.localizedDescription)
        }
        
        spinner.dismissLoader()
    }
    
    @IBAction func startServiceClick(_ sender: Any) {
        let spinner = showLoader(view: self.view)
        
        beaconService.delegate = BeaconServiceDelegateImpl(viewController: self)
        beaconService.initService()
        
        // Disable the timer on the BeaconService so that beacon detection
        // is not reset while debugging
        beaconService.setTimerEnabled(enabled: false)
        
        // Modify any BluecatsSDK options if needed
        // The BlueCastSDK has been left exposed deliberately
        // to enable finer control or debugging of beacon services
        // full documentation can be found: https://s3-us-west-1.amazonaws.com/sdk-guide/ios/2.0/index.html
        
        //BlueCatsSDK.setOptions([
        //    BCOptionMaximumDailyBackgroundUsageInMinutes: 1440,
        //    BCOptionBackgroundSessionTimeIntervalInSeconds: 3 * 60 * 60
        //])

 
        // Start scanning for beacons
        // Can be run as a background service on OS startup
       
        // See BeaconServiceDelegateImpl class at bottom of this file
        // for responding to beacon events
        beaconService.startService { beaconServiceResult in
            do {
                let jsonData = try JSONEncoder().encode(beaconServiceResult)
                let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
                NSLog("startService result:" + jsonString)
                let toast = Toast(text: "startService result:" + jsonString, duration: Delay.long)
                toast.show()
            } catch {
                NSLog(error.localizedDescription)
            }

            spinner.dismissLoader()
        }
    }
    
    @IBAction func stopServiceClick(_ sender: Any) {
        let spinner = showLoader(view: self.view)
      
        beaconService.stopService { beaconServiceResult in
            do {
                let jsonData = try JSONEncoder().encode(beaconServiceResult)
                let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
                NSLog("stopService result:" + jsonString)
                let toast = Toast(text: "stopService result:" + jsonString, duration: Delay.long)
                toast.show()
            } catch {
                NSLog(error.localizedDescription)
            }

            spinner.dismissLoader()
        }
    }

    
    public class BeaconServiceDelegateImpl: BeaconServiceDelegate {
        private var _viewController: ViewController
        
        init(viewController: ViewController) {
            _viewController = viewController
        }
        
        public func carParkNameChanged(_ carParkName: String) {
            // Raised when a new car park is found
            NSLog("Car Park Found: " + carParkName)
        }
        
        public func carParkIdChanged(_ carParkId: Int64) {
            // Raised when a new car park is found
            NSLog("CarParkId: " + String(carParkId))
        }

        public func beaconsChanged(_ beacons: [BeaconModel]?) {
            // Raised whenever beacons being detected have changed
            NSLog("BeaconsChanged")
        }
        
        public func lanesChanged(_ lanes: [LaneModel]?) {
            // Raised when the lanes associated with closest beacon has changed
            // these should be the list of lanes that are presented to the user to select
            // from
            NSLog("LanesChanged: ")
            for lane in lanes! {
                NSLog("Lane: " + lane.name + ", " + lane.shortName)
            }
        }
        
        public func laneBeaconsChanged(_ laneBeaconss: [LaneModel]?) {
            // Can be used to examine the details of all beacons read
            // associated with the lanes
            NSLog("LaneBeaconsChanged")
        }
        
        public func closestLaneChanged(_ closestLane: LaneModel?) {
            // Raised once the closest lane is detected, or goes out of range
            if let currentClosestLane = closestLane {
                NSLog("Closest Lane is now: " + currentClosestLane.name + ", " + currentClosestLane.shortName + ", " + String(currentClosestLane.laneId))
                _viewController.closestLaneLabel.text = currentClosestLane.name + " (" + String(currentClosestLane.laneId) + ")"
            } else {
                NSLog("No Closest lane")
                _viewController.closestLaneLabel.text = "No closest lane"
                return
            }
        }
        
    }
    
    func showLoader(view: UIView) -> UIActivityIndicatorView {
        //Customize as per your need
        let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height:40))
        spinner.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        spinner.layer.cornerRadius = 3.0
        spinner.clipsToBounds = true
        spinner.hidesWhenStopped = true
        spinner.style = UIActivityIndicatorView.Style.medium;
            spinner.center = view.center
            view.addSubview(spinner)
            spinner.startAnimating()
        //UIApplication.shared.beginIgnoringInteractionEvents()
        self.view.isUserInteractionEnabled = false

        return spinner
    }
}

extension UIActivityIndicatorView {
     func dismissLoader() {
        self.stopAnimating()
        //UIApplication.shared.endIgnoringInteractionEvents()
        self.superview?.isUserInteractionEnabled = true
     }
 }
