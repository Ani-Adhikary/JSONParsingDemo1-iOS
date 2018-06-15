//
//  ViewController.swift
//  JSONParsingDemo1
//
//  Created by Ani Adhikary on 05/06/18.
//  Copyright © 2018 TheTechStory. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

     //this method will call the service and get all route between two cordinates
    func getRouteBetweenPoints(sourcePOICoordinate: CLLocationCoordinate2D, destinationPOICoordinate: CLLocationCoordinate2D, sourceFloorId: Int, completion: @escaping QueryResultRoute) {
        
        guard let url = URL(string: Constants.routeURLString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("text/html;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        let dictionary = ["x1":sourcePOICoordinate.longitude  ,"y1":sourcePOICoordinate.latitude,"x2":destinationPOICoordinate.longitude,"y2":destinationPOICoordinate.latitude,"f1":sourceFloorId,"f2":poiSearchFloor] as [String: Any]
        let dataToSend = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
        
        let jsonString = String(data: dataToSend!, encoding: .utf8)
//        print("jsonString is as below=============")
//        print(jsonString)
        ConsoleStatement.printStatement(printstatement: "jsonString is \(jsonString)")
        
        request.httpBody = dataToSend

        let postTask = defaultSession.dataTask(with: request) { data, response, error in

            if let error = error {
                self.errorMessage += "Route Service System error: " + error.localizedDescription + "\n"
            } else if let response = response as? HTTPURLResponse,
                response.statusCode == 404 {
                DispatchQueue.main.async {
                    completion(self.geom, "Route Data could not be fetched")
                }
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                self.getRouteData(data)
                DispatchQueue.main.async {
                    completion(self.geom, self.errorMessage)
                }
            }
        }
        postTask.resume()
    }
    
    //this method will process route cordinate got from service
    func getRouteData(_ data: Data)
    {
        
        do {
            guard let rootObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]  else {
                return
            }
            
            guard let featureObjects = rootObject["features"] as? [[String: AnyObject]] else {
                return
            }
            var icount = 0
            var coordinatesData = [CLLocationCoordinate2D]()
            var floorno = [Int]()
            
            var featureType = String()
            for featureObject in featureObjects {
                icount = icount + 1
                if let _ = featureObject["type"] as? String,
                    let geomData = featureObject["geometry"] as? [String: AnyObject] {
                    
                    if let type = geomData["type"] as? String,
                        let coordinates = geomData["coordinates"] as? [[Double]]
                    {
                        featureType = type
                        for coord in coordinates {
                            let coordVal = CLLocationCoordinate2DMake(coord[1], coord[0])
                            coordinatesData.append(coordVal)
                            
                            if let floorData = featureObject["properties"] as? [String: AnyObject] {
                                
                                let routeFloor = floorData["floor"] as? Int
                                floorno.append(routeFloor!)
                            }
                            
                        }
                    }
                    geom = GeometryData(type: featureType,floorRoute: floorno , coordinates: coordinatesData)
                    
                }
                
            }
        } catch {
            
        }
        
    }
    

}

