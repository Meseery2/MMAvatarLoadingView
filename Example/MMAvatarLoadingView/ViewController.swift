//
//  ViewController.swift
//  MMAvatarLoadingView
//
//  Created by m7med4ever@gmail.com on 07/21/2018.
//  Copyright (c) 2018 m7med4ever@gmail.com. All rights reserved.
//

import UIKit
import MMAvatarLoadingView

class ViewController: UIViewController {

    @IBOutlet weak var avatarView: MMAvatarLoadingView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loadAvatar(sender: AnyObject) {
        let imageURL = URL.init(string: "https://source.unsplash.com/random")
        self.avatarView.loadImage(fromURL: imageURL!,
                                  progressBarColor: UIColor.blue,
                                  progressBarLineWidth: 10.0)
    }

}

