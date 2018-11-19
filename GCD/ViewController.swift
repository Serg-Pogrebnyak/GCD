//
//  ViewController.swift
//  GCD
//
//  Created by Sergey Pogrebnyak on 16.11.2018.
//  Copyright © 2018 Sergey Pogrebnyak. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    fileprivate let arrayImagesURL = ["http://agoge.su/wp-content/uploads/2017/09/shutup.jpg",
                                   "http://img.1001mem.ru/posts_temp/16-08-24/3856256.jpg",
                                   "https://pm1.narvii.com/6389/65066466857083f0445af8c19972bde6bbef86fe_hq.jpg",
                                   "https://cs5.pikabu.ru/images/big_size_comm/2015-11_5/1448407751129180442.jpg",
                                   "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTngv2iKdBx_PuXDML3Fmhcf-tgAthWfFfYKXA1nVQv7z93ZgHIQ",
                                   "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuqdmBHSeyfG8Y3ye6ofDc7WjPWZhSYsNeOtHe7z24LWnz440g",
                                   "https://www.meme-arsenal.ru/memes/ea02e1852c818c808e52c87fda1c0d11.jpg",
                                   "https://cs9.pikabu.ru/post_img/2017/04/03/7/1491215311199111895.png",
                                   "https://bryansktoday.ru/media/k2/items/cache/c803f34f838a7cde7be0d34d45574749_XL.jpg",
                                   "https://i.ytimg.com/vi/lYyuXKuc8jM/maxresdefault.jpg"]
    fileprivate var arrayImages = [(first: UIImage, second: UIImage)]()

    @IBOutlet fileprivate weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib.init(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayImages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.setDataInImage(imageLeft: arrayImages[indexPath.row].first, imageRight: arrayImages[indexPath.row].second)
        return cell
    }

    @IBAction func concurrentAction(_ sender: Any) {
        arrayImages.removeAll()
        tableView.reloadData()
        let queue = DispatchQueue.init(label: "Cuncurrent", attributes: .concurrent)
        for i in stride(from: 0, to: arrayImagesURL.count, by: 2) {
            asyncLoadImages(firstImageURL: URL(string: arrayImagesURL[i])!, secondImageURL: URL(string: arrayImagesURL[i+1])!, runQueue: queue)
        }
    }

    @IBAction func serialAction(_ sender: Any) {
        arrayImages.removeAll()
        tableView.reloadData()
        let queue = DispatchQueue.init(label: "Serial")
        for i in stride(from: 0, to: arrayImagesURL.count, by: 2) {
            asyncLoadImages(firstImageURL: URL(string: arrayImagesURL[i])!, secondImageURL: URL(string: arrayImagesURL[i+1])!, runQueue: queue)
        }
    }

    fileprivate func asyncLoadImages(firstImageURL: URL, secondImageURL: URL, runQueue: DispatchQueue) {
        runQueue.async {
            do {
                let dataFirstImage = try Data(contentsOf: firstImageURL)
                let dataSecondImage = try Data(contentsOf: secondImageURL)
                DispatchQueue.main.async {
                    self.arrayImages.append((first: UIImage(data: dataFirstImage)!, second: UIImage(data: dataSecondImage)!))
                    self.tableView.reloadData()
                }
            } catch {
                print("error loading image \(error)")
            }
        }
    }

}

