//
//  ServerViewModel.swift
//  RemoteSample
//
//  Created by iamchiwon on 2018. 6. 19..
//  Copyright © 2018년 ncode. All rights reserved.
//

import RxCocoa
import RxSwift

class ServerViewModel {
    
    var server: ServerMessengerWrapper!
    let disposeBag = DisposeBag()
    
    let clientCount = BehaviorRelay<Int>(value: 0)
    lazy var messageDriver = server.messages
        .asDriver(onErrorJustReturn: CommandMessage.empty())
        .filter({ isNotEmpty($0.sender) })
    
    init() {
        server = ServerMessengerWrapper(serviceName: "_remotimer")
        server.startServer()
        server.clients.map({$0.count}).bind(to: clientCount).disposed(by: disposeBag)
        server.disposed(by: disposeBag)
    }
    
    func send(_ command: String, _ param: String = "") {
        let cmd = CommandMessage(command: command, parameter: param)
        server.broadcast(command: cmd)
    }
}
