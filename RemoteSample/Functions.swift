//
//  Functions.swift
//  RemoteSample
//
//  Created by iamchiwon on 2018. 6. 19..
//  Copyright © 2018년 ncode. All rights reserved.
//

import Foundation

let i2s: (Int) -> String = { "\($0)" }

let isEmpty: (String?) -> Bool = { $0?.isEmpty ?? true }
let isNotEmpty: (String?) -> Bool = { !isEmpty($0) }
