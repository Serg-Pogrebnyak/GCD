//
//  ThirdViewController.swift
//  GCD
//
//  Created by Sergey Pogrebnyak on 22.11.2018.
//  Copyright © 2018 Sergey Pogrebnyak. All rights reserved.
//

import UIKit
import Alamofire

class QOSViewController: UIViewController {

    @IBOutlet fileprivate weak var label1Qos: UILabel!
    @IBOutlet fileprivate weak var label1Percent: UILabel!
    @IBOutlet fileprivate weak var progressBar1: UIProgressView!
    @IBOutlet fileprivate weak var image1: UIImageView!
    @IBOutlet fileprivate weak var label2Qos: UILabel!
    @IBOutlet fileprivate weak var label2Percent: UILabel!
    @IBOutlet fileprivate weak var progressBar2: UIProgressView!
    @IBOutlet fileprivate weak var image2: UIImageView!
    @IBOutlet fileprivate weak var label3Qos: UILabel!
    @IBOutlet fileprivate weak var label3Percent: UILabel!
    @IBOutlet fileprivate weak var progressBar3: UIProgressView!
    @IBOutlet fileprivate weak var image3: UIImageView!
    @IBOutlet fileprivate weak var label4Qos: UILabel!
    @IBOutlet fileprivate weak var label4Percent: UILabel!
    @IBOutlet fileprivate weak var progressBar4: UIProgressView!
    @IBOutlet fileprivate weak var image4: UIImageView!

    fileprivate let imageURL = "http://www.effigis.com/wp-content/uploads/2015/02/Iunctus_SPOT5_5m_8bit_RGB_DRA_torngat_mountains_national_park_8bits_1.jpg"

    override func viewDidLoad() {
        super.viewDidLoad()
        cleare()
    }
    
    @IBAction func start(_ sender: Any) {
        cleare()

        label1Qos.text = "background"
        let queue1 = DispatchQueue.init(label: "Concurrent1", qos: .background, attributes: .concurrent)
        asyncLoadImages(imageURL: URL(string: imageURL)!, runQueue: queue1,  progressBar: progressBar1, imageView: image1, label: label1Percent)

        label2Qos.text = "utility"
        let queue2 = DispatchQueue.init(label: "Concurrent2", qos: .utility, attributes: .concurrent)
        asyncLoadImages(imageURL: URL(string: imageURL)!, runQueue: queue2,  progressBar: progressBar2, imageView: image2, label: label2Percent)

        label3Qos.text = "userInitiated"
        let queue3 = DispatchQueue.init(label: "Concurrent3", qos: .userInitiated, attributes: .concurrent)
        asyncLoadImages(imageURL: URL(string: imageURL)!, runQueue: queue3,  progressBar: progressBar3, imageView: image3, label: label3Percent)

        label4Qos.text = "userInteractive"
        let queue4 = DispatchQueue.init(label: "Concurrent3", qos: .userInteractive, attributes: .concurrent)
        asyncLoadImages(imageURL: URL(string: imageURL)!, runQueue: queue4,  progressBar: progressBar4, imageView: image4, label: label4Percent)

    }

    fileprivate func asyncLoadImages(imageURL: URL, runQueue: DispatchQueue, progressBar: UIProgressView, imageView: UIImageView, label: UILabel) {
            request(imageURL).downloadProgress(closure: { (progress) in
                label.text = String(Int(progress.fractionCompleted*100))
                progressBar.setProgress(Float(progress.fractionCompleted), animated: true)
            }).response(queue: runQueue, completionHandler: { (response) in
                print(Thread.current)
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: response.data!)
                }
            })

    }

    fileprivate func cleare() {
        progressBar1.setProgress(0.0, animated: false)
        progressBar2.setProgress(0.0, animated: false)
        progressBar3.setProgress(0.0, animated: false)
        progressBar4.setProgress(0.0, animated: false)
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
