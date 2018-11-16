//
//  ViewController.swift
//  GCD
//
//  Created by Sergey Pogrebnyak on 16.11.2018.
//  Copyright © 2018 Sergey Pogrebnyak. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    fileprivate let imagesArray = ["https://pp.vk.me/c837633/v837633627/12d10/WzE_c9um7Ek.jpg",
                                   "http://img.1001mem.ru/posts_temp/16-08-24/3856256.jpg",
                                   "https://pm1.narvii.com/6389/65066466857083f0445af8c19972bde6bbef86fe_hq.jpg",
                                   "https://cs5.pikabu.ru/images/big_size_comm/2015-11_5/1448407751129180442.jpg",
                                   "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTngv2iKdBx_PuXDML3Fmhcf-tgAthWfFfYKXA1nVQv7z93ZgHIQ",
                                   "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuqdmBHSeyfG8Y3ye6ofDc7WjPWZhSYsNeOtHe7z24LWnz440g",
                                   "https://www.meme-arsenal.ru/memes/ea02e1852c818c808e52c87fda1c0d11.jpg",
                                   "https://cs9.pikabu.ru/post_img/2017/04/03/7/1491215311199111895.png",
                                   "https://bryansktoday.ru/media/k2/items/cache/c803f34f838a7cde7be0d34d45574749_XL.jpg",
                                   "https://i.ytimg.com/vi/lYyuXKuc8jM/maxresdefault.jpg"]
    fileprivate var arrayImage = [(first: UIImage, second: UIImage)]()

    @IBOutlet fileprivate weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib.init(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesArray.count/2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.setDataInImage(imageLeft: arrayImage[indexPath.row].first, imageRight: arrayImage[indexPath.row].second)
        return cell
    }

    fileprivate func loadImages() {
        
    }

}

