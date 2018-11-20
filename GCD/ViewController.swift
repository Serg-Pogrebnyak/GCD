//
//  ViewController.swift
//  GCD
//
//  Created by Sergey Pogrebnyak on 16.11.2018.
//  Copyright © 2018 Sergey Pogrebnyak. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    fileprivate var textFieldEditingNow = false
    fileprivate var arrayImages = [(first: UIImage, second: UIImage)]()
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

    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var textField: UITextField!
    @IBOutlet fileprivate weak var serialButton: UIButton!
    @IBOutlet fileprivate weak var concurrentButton: UIButton!
    fileprivate let picker = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib.init(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")

        picker.selectRow(0, inComponent: 0, animated: false)
        textField.text = Qos.qosArray[picker.selectedRow(inComponent: 0)].string
        picker.delegate = self
        textField.inputView = picker
    }

    @IBAction func concurrentAction(_ sender: Any) {
        concurrentButton.isEnabled = false
        serialButton.isEnabled = false
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        arrayImages.removeAll()
        tableView.reloadData()
        let QosCurrent = Qos.qosArray[picker.selectedRow(inComponent: 0)].qos
        let queue = DispatchQueue.init(label: "Cuncurrent", qos: QosCurrent, attributes: .concurrent)
        for i in stride(from: 0, to: arrayImagesURL.count, by: 2) {
            asyncLoadImages(firstImageURL: URL(string: arrayImagesURL[i])!, secondImageURL: URL(string: arrayImagesURL[i+1])!, runQueue: queue)
        }
        queue.async(flags: .barrier) {
            let alert = UIAlertController(title: "Alert", message: "End loading", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
            DispatchQueue.main.async {
                self.serialButton.isEnabled = true
                self.concurrentButton.isEnabled = true
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func serialAction(_ sender: Any) {
        self.concurrentButton.isEnabled = false
        serialButton.isEnabled = false
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        arrayImages.removeAll()
        tableView.reloadData()
        let QosCurrent = Qos.qosArray[picker.selectedRow(inComponent: 0)].qos
        let queue = DispatchQueue.init(label: "Serial", qos: QosCurrent)
        for i in stride(from: 0, to: arrayImagesURL.count, by: 2) {
            asyncLoadImages(firstImageURL: URL(string: arrayImagesURL[i])!, secondImageURL: URL(string: arrayImagesURL[i+1])!, runQueue: queue)
        }
        queue.async() {
            let alert = UIAlertController(title: "Alert", message: "End loading", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
            DispatchQueue.main.async {
                self.concurrentButton.isEnabled = true
                self.serialButton.isEnabled = true
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.present(alert, animated: true, completion: nil)
            }
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
    //MARK: - table view methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayImages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.setDataInImage(imageLeft: arrayImages[indexPath.row].first, imageRight: arrayImages[indexPath.row].second)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if textFieldEditingNow {
            textField.endEditing(true)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    //MARK: - picker View methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Qos.qosArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Qos.qosArray[row].string
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = Qos.qosArray[row].string
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldEditingNow = true
    }
}

