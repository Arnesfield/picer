//
//  Common.swift
//  Picer
//
//  Created by Jefferson Rylee on 19/11/2017.
//  Copyright © 2017 iOS Arnesfield. All rights reserved.
//

import UIKit

class Common: NSObject {
    private static let PRODUCTION = true
    public static let BASE_URL = Common.PRODUCTION
        ? "http://picer.x10.mx/"
        : "http://10.0.2.2/school/picer/public/"
}
