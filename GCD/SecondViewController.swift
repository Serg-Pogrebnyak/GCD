//
//  SecondViewController.swift
//  GCD
//
//  Created by Sergey Pogrebnyak on 20.11.2018.
//  Copyright © 2018 Sergey Pogrebnyak. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SafeArrayDelegate {

    //fileprivate var arrayImages = [(first: UIImage, second: UIImage)]()
    fileprivate var safeArrayImages = SafeArray<UIImage>()
    fileprivate let arrayImagesURL = ["https://image.ibb.co/iDPYS0/action-america-architecture-378570.jpg",
                                      "https://image.ibb.co/cbD4Zf/autumn-colorful-colourful-33109.jpg",
                                      "https://image.ibb.co/kgrrEf/alcohol-beverage-black-background-1028637.jpg",
                                      "https://image.ibb.co/nD5ZZf/atmosphere-cloudiness-clouds-844297.jpg",
                                      "https://image.ibb.co/eOjHn0/1-wtc-america-architecture-374710.jpg",
                                      "https://image.ibb.co/bwFwfL/bloom-blossom-close-up-36764.jpg",
                                      "https://image.ibb.co/bFAe0L/adorable-animal-blur-406014.jpg",
                                      "https://image.ibb.co/dbQZZf/beautiful-clouds-conifers-1064162.jpg",
                                      "https://image.ibb.co/mGUp0L/beautiful-bloom-blooming-1157970.jpg",
                                      "https://image.ibb.co/cpp6fL/africa-african-animal-33045.jpg"]

    @IBOutlet weak var concurrentButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        safeArrayImages.delegate = self
        let nib = UINib.init(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
    }

    func reloadTable() {
        if safeArrayImages.valueArray.count == arrayImagesURL.count {
            let alert = UIAlertController(title: "Alert", message: "End loading", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.concurrentButton.isEnabled = true
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func concurrentAction(_ sender: Any) {
        concurrentButton.isEnabled = false
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        safeArrayImages.removeAll()
        tableView.reloadData()
        let queue = DispatchQueue.init(label: "Concurrent", attributes: .concurrent)
        //DispatchQueue.concurrentPerform(iterations: arrayImagesURL.count) { (i) in
            for i in (0...self.arrayImagesURL.count-1 ){
                queue.async {
            do {
                let dataImage = try Data(contentsOf: URL(string: self.arrayImagesURL[i])!)
                self.safeArrayImages.append(UIImage(data: dataImage)!)
                self.reloadTable()
            } catch {
                print("error loading image \(error)")
            }
        }
        }
    }

    //MARK: - table view methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(safeArrayImages.valueArray.count)
        return Int(safeArrayImages.valueArray.count/2)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        let imageArray = safeArrayImages.valueArray
        cell.setDataInImage(imageLeft: imageArray[2*indexPath.row], imageRight: imageArray[2*indexPath.row+1])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

