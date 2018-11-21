//
//  SafeArray.swift
//  GCD
//
//  Created by Sergey Pogrebnyak on 20.11.2018.
//  Copyright © 2018 Sergey Pogrebnyak. All rights reserved.
//

import UIKit

protocol SafeArrayDelegate{
    func reloadTable()
}

class SafeArray<T> {
    var delegate: SafeArrayDelegate?
    private var array = [T]()
    private let queue = DispatchQueue(label: "Array queue", attributes: .concurrent)

    public func append(_ value: T) {
        queue.async(flags: .barrier) {
            self.array.append(value)
            //self.delegate?.reloadTable()
        }
    }

    public var valueArray: [T] {
        var result = [T]()
        queue.sync {
            result = self.array
        }
        return result
    }

    public func removeAll() {
        queue.sync {
            self.array.removeAll()
        }
    }
}
