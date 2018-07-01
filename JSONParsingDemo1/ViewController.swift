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
    
    @objc func goToTopButtonClicked(_ button: UIButton) {
        //elementTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        
        if #available(iOS 11.0, *) {
            elementTableView.setContentOffset(CGPoint(x: 0, y: -elementTableView.adjustedContentInset.top), animated: true)
        } else {
            elementTableView.setContentOffset(CGPoint(x: 0, y: -elementTableView.contentInset.top), animated: true)
        }
    }
    
}

