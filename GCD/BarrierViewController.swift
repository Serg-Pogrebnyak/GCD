//
//  GroupAndBarierViewController.swift
//  GCD
//
//  Created by Sergey Pogrebnyak on 12/4/18.
//  Copyright © 2018 Sergey Pogrebnyak. All rights reserved.
//

import UIKit

class BarrierViewController: UIViewController {


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

    @IBOutlet fileprivate weak var barierImageView: UIImageView!
    
    fileprivate let imageURL = URL(string: "http://www.effigis.com/wp-content/uploads/2015/02/Iunctus_SPOT5_5m_8bit_RGB_DRA_torngat_mountains_national_park_8bits_1.jpg")!
    fileprivate let imageBarierURL = URL(string: "http://www.effigis.com/wp-content/uploads/2015/02/Airbus_Pleiades_50cm_8bit_RGB_Yogyakarta.jpg")!

    override func viewDidLoad() {
        super.viewDidLoad()
        cleare()
    }

    @IBAction func startButtonAction(_ sender: Any) {
        cleare()

        label1Qos.text = "userInteractive"
        label2Qos.text = "userInteractive"
        label3Qos.text = "userInteractive"
        label4Qos.text = "userInteractive"
        let queue = DispatchQueue.init(label: "Concurrent", qos: .userInteractive, attributes: .concurrent)
        asyncLoadImages(imageURL:  imageURL, runQueue: queue, imageView: image1, label: label1Percent)
        asyncLoadImages(imageURL:  imageURL, runQueue: queue, imageView: image2, label: label2Percent)
        queue.async(flags: .barrier) {
            let data = try? Data(contentsOf: self.imageBarierURL)
            print(Thread.current)
            DispatchQueue.main.async {
                self.barierImageView.image = UIImage(data: data!)
            }
        }
        asyncLoadImages(imageURL:  imageURL, runQueue: queue, imageView: image3, label: label3Percent)
        asyncLoadImages(imageURL:  imageURL, runQueue: queue, imageView: image4, label: label4Percent)
    }

    fileprivate func asyncLoadImages(imageURL: URL, runQueue: DispatchQueue, imageView: UIImageView, label: UILabel) {
        runQueue.async() {
            DispatchQueue.main.async {label.text = "Start"}
            let data = try? Data(contentsOf: self.imageURL)
            print(Thread.current)
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data!)
            }
        }
    }

    fileprivate func showAlertWithAction(header: String, body: String, action: @escaping () -> Void) {
        let alert = UIAlertController(title: header, message: body, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Next Group", style: .default, handler: { (_) in
            action()
        }))
        self.present(alert, animated: true, completion: nil)
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
