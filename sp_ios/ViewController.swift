//
//  ViewController.swift
//  sp_ios
//
//  Created by Danish Rehman on 8/30/15.
//  Copyright (c) 2015 Danish Rehman. All rights reserved.
//

import UIKit
import MediaPlayer
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var moviePlayer : MPMoviePlayerController?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup_location()
        make_request()
    }
    
    func make_request() {
        let urlPath: String = "https://api.github.com/users/mralexgray/repos"
        var url: NSURL = NSURL(string: urlPath)!
        var request1: NSURLRequest = NSURLRequest(URL: url)
        let queue:NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request1, queue: queue,
            completionHandler:{
                (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                
                self.handle_response(data)
                
        })
    }
    
    func setup_location() {
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            
            // Ask for Authorisation from the User.
            self.locationManager.requestAlwaysAuthorization()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func handle_response(data : NSData) {
        var myError: NSError?
        if let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &myError) as? NSArray, let dictionary = json.firstObject as? NSDictionary {
            //println(dictionary["archive_url"])
            //println(json[0])
            println(json.count)
        } else {
            println(myError)
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var userLocation:CLLocation = locations[0] as! CLLocation
        let long = userLocation.coordinate.longitude;
        let lat = userLocation.coordinate.latitude;
        println(lat, long);
    }
    
    override func viewDidAppear(animated: Bool) {
        //displayVideoFromURL("http://giant.gfycat.com/ParallelHiddenArmyant.mp4")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayVideoFromURL( address: String ) {
        
        if let url:NSURL = NSURL( string: address ) {
            
            if let moviePlayer = MPMoviePlayerController( contentURL: url ) {
                
                view.addSubview( moviePlayer.view )
                moviePlayer.fullscreen = true
                
                moviePlayer.view.frame = self.view.bounds
                moviePlayer.scalingMode = .AspectFill
                
                
                moviePlayer.controlStyle = MPMovieControlStyle.Embedded
                moviePlayer.movieSourceType = MPMovieSourceType.Streaming
                
                moviePlayer.play()
            }
        }
    }
    
}

