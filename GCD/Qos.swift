//
//  Qos.swift
//  GCD
//
//  Created by Sergey Pogrebnyak on 20.11.2018.
//  Copyright © 2018 Sergey Pogrebnyak. All rights reserved.
//

import UIKit

struct Qos {
    static let background = (string: "background", qos: DispatchQoS.background)
    static let unspecified = (string: "unsecified", qos: DispatchQoS.unspecified)
    static let userInitiated = (string: "userInitiated", qos: DispatchQoS.userInitiated)
    static let userInteractive = (string: "userInteractive", qos: DispatchQoS.userInteractive)
    static let utility = (string: "utility", qos: DispatchQoS.utility)
    static let qosArray = [background, unspecified, userInitiated, userInteractive, utility]
}
