//
//  SemaphoreViewController.swift
//  GCD
//
//  Created by Sergey Pogrebnyak on 12/4/18.
//  Copyright © 2018 Sergey Pogrebnyak. All rights reserved.
//

import UIKit

class SemaphoreViewController: UIViewController {

    @IBOutlet fileprivate weak var label1Qos: UILabel!
    @IBOutlet fileprivate weak var label1Percent: UILabel!
    @IBOutlet fileprivate weak var image1: UIImageView!


    @IBOutlet fileprivate weak var label2Qos: UILabel!
    @IBOutlet fileprivate weak var label2Percent: UILabel!
    @IBOutlet fileprivate weak var image2: UIImageView!

    @IBOutlet fileprivate weak var label3Qos: UILabel!
    @IBOutlet fileprivate weak var label3Percent: UILabel!
    @IBOutlet fileprivate weak var image3: UIImageView!

    @IBOutlet fileprivate weak var label4Qos: UILabel!
    @IBOutlet fileprivate weak var label4Percent: UILabel!
    @IBOutlet fileprivate weak var image4: UIImageView!

    fileprivate let imageURL = URL(string: "http://www.effigis.com/wp-content/uploads/2015/02/DigitalGlobe_WorldView1_50cm_8bit_BW_DRA_Bangkok_Thailand_2009JAN06_8bits_sub_r_1.jpg")!

    override func viewDidLoad() {
        super.viewDidLoad()
        cleare()
    }

    @IBAction func startButtonAction(_ sender: Any) {
        cleare()
        let semaphore = DispatchSemaphore(value: 1)
        label1Qos.text = "userInteractive"
        label2Qos.text = "userInteractive"
        label3Qos.text = "userInteractive"
        label4Qos.text = "userInteractive"
        let queue = DispatchQueue.init(label: "Concurrent", qos: .userInteractive, attributes: .concurrent)
        asyncLoadImages(imageURL:  imageURL, runQueue: queue, imageView: image1, label: label1Percent, sem: semaphore)
        asyncLoadImages(imageURL:  imageURL, runQueue: queue, imageView: image2, label: label2Percent, sem: semaphore)
        asyncLoadImages(imageURL:  imageURL, runQueue: queue, imageView: image3, label: label3Percent, sem: semaphore)
        asyncLoadImages(imageURL:  imageURL, runQueue: queue, imageView: image4, label: label4Percent, sem: semaphore)
    }

    fileprivate func asyncLoadImages(imageURL: URL, runQueue: DispatchQueue, imageView: UIImageView, label: UILabel, sem: DispatchSemaphore) {
        runQueue.async() {
            sem.wait()
            DispatchQueue.main.async {label.text = "Start"}
            let data = try? Data(contentsOf: self.imageURL)
            print(Thread.current)
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data!)
            }
            sem.signal()
        }
    }


    fileprivate func cleare() {
        image1.image = nil
        image2.image = nil
        image3.image = nil
        image4.image = nil
        label1Percent.text = "Empty"
        label2Percent.text = "Empty"
        label3Percent.text = "Empty"
        label4Percent.text = "Empty"
    }
}
