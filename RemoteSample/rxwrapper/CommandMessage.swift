//
//  CommandMessage.swift
//  RemoteSample
//
//  Created by iamchiwon on 2018. 6. 19..
//  Copyright © 2018년 ncode. All rights reserved.
//

import Tibei

class CommandMessage: JSONConvertibleMessage {
    var sender: String
    var command: String
    var parameter: String
    
    static func empty() -> CommandMessage {
        return CommandMessage(sender: "", command: "", parameter: "")
    }
    
    init(sender: String = UIDevice.current.name, command: String, parameter: String = "") {
        self.sender = sender
        self.command = command
        self.parameter = parameter
    }
    
    required init(jsonObject: [String: Any]) {
        self.sender = jsonObject["sender"] as! String
        self.command = jsonObject["command"] as! String
        self.parameter = jsonObject["parameter"] as! String
    }
    
    func toJSONObject() -> [String: Any] {
        return [
            "sender": self.sender,
            "command": self.command,
            "parameter": self.parameter
        ]
    }
}
