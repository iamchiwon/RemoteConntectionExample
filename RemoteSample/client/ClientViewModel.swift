//
//  ClientViewModel.swift
//  RemoteSample
//
//  Created by iamchiwon on 2018. 6. 19..
//  Copyright © 2018년 ncode. All rights reserved.
//

import RxCocoa
import RxSwift

class ClientViewModel {
    
    var client: ClientMessengerWrapper!
    let disposeBag = DisposeBag()
    
    lazy var messageDriver = client.messages
        .asDriver(onErrorJustReturn: CommandMessage.empty())
        .filter({ isNotEmpty($0.sender) })
    
    init() {
        client = ClientMessengerWrapper()
        client.connectService(serviceName: "_remotimer")
        client.disposed(by: disposeBag)
    }
    
    func send(_ command: String, _ param: String = "") {
        let cmd = CommandMessage(command: command, parameter: param)
        client.sendMessage(command: cmd)
    }
}
