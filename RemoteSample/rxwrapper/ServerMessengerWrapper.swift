//
//  ServerMessengerWrapper.swift
//  RemoteSample
//
//  Created by iamchiwon on 2018. 6. 19..
//  Copyright © 2018년 ncode. All rights reserved.
//

import RxCocoa
import RxSwift
import Tibei

class ServerMessengerWrapper: ConnectionResponder, Disposable {
    
    private var server: ServerMessenger!
    
    let messages = PublishSubject<CommandMessage>()
    let accepted = PublishSubject<ConnectionID>()
    let lost = PublishSubject<ConnectionID>()
    let clients = BehaviorRelay<[ConnectionID]>(value: [])
    
    init(serviceName: String) {
        server = ServerMessenger(serviceIdentifier: serviceName)
    }
    
    func startServer() {
        server.registerResponder(self)
        server.publishService()
    }
    
    func stopServer() {
        server.unregisterResponder(self)
        server.unpublishService()
    }
    
    func dispose() {
        stopServer()
        accepted.onCompleted()
        lost.onCompleted()
        messages.onCompleted()
        server = nil
    }
    
    func sendMessage(command: CommandMessage, connectionId: ConnectionID) {
        guard clients.value.filter({ id in id == connectionId }).count > 0 else { return }
        do {
            try server.sendMessage(command, toConnectionWithID: connectionId)
        } catch let e {
            print(e)
        }
    }
    
    func broadcast(command: CommandMessage) {
        clients.value.forEach({ id in
            do {
                try server.sendMessage(command, toConnectionWithID: id)
            } catch let e {
                print(e)
            }
        })
    }
    
    // MARK: - ConnectionResponder
    
    var allowedMessages: [JSONConvertibleMessage.Type] {
        return [CommandMessage.self]
    }
    
    func processMessage(_ message: JSONConvertibleMessage, fromConnectionWithID connectionID: ConnectionID) {
        if let command = message as? CommandMessage {
            messages.onNext(command)
        }
    }
    
    func acceptedConnection(withID connectionID: ConnectionID) {
        accepted.onNext(connectionID)
        
        var appended = clients.value
        appended.append(connectionID)
        clients.accept(appended)
    }
    
    func lostConnection(withID connectionID: ConnectionID) {
        lost.onNext(connectionID)
        
        let removed = clients.value.filter({ id in connectionID != id })
        clients.accept(removed)
    }
    
    func processError(_ error: Error, fromConnectionWithID connectionID: ConnectionID?) {
        messages.onError(error)
    }
}
