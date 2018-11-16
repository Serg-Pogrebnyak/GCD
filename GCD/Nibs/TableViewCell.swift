//
//  TableViewCell.swift
//  GCD
//
//  Created by Sergey Pogrebnyak on 16.11.2018.
//  Copyright © 2018 Sergey Pogrebnyak. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var imageLeft: UIImageView!
    @IBOutlet fileprivate weak var imageRight: UIImageView!

    func setDataInImage(imageLeft: UIImage, imageRight: UIImage) {
        self.imageLeft.image = imageLeft
        self.imageRight.image = imageRight
    }

}
