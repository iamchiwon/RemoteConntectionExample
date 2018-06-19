//
//  ClientMessengerWrapper.swift
//  RemoteSample
//
//  Created by iamchiwon on 2018. 6. 19..
//  Copyright © 2018년 ncode. All rights reserved.
//

import RxCocoa
import RxSwift
import Tibei

class ClientMessengerWrapper: ClientConnectionResponder, Disposable {

    private var client: ClientMessenger!
    private var connectedId: ConnectionID?

    let messages = PublishSubject<CommandMessage>()
    let connected = BehaviorRelay<Bool>(value: false)

    init() {
        client = ClientMessenger()
    }

    func connectService(serviceName: String) {
        client.registerResponder(self)
        client.browseForServices(withIdentifier: serviceName)
    }

    func disconnectService() {
        client.unregisterResponder(self)
        client.disconnect()
    }

    func dispose() {
        disconnectService()
        messages.onCompleted()
        client = nil
    }

    func sendMessage(command: CommandMessage) {
        do {
            try client.sendMessage(command)
        } catch let e {
            print(e)
        }
    }

    // MARK: - ClientConnectionResponder

    func availableServicesChanged(availableServiceIDs: [String]) {
        do {
            if let connectableId = availableServiceIDs.first {
                try client.connect(serviceName: connectableId)

            } else if let connectedId = self.connectedId {
                lostConnection(withID: connectedId)
            }
        } catch let e {
            print(e)
        }
    }

    var allowedMessages: [JSONConvertibleMessage.Type] {
        return [CommandMessage.self]
    }

    func processMessage(_ message: JSONConvertibleMessage, fromConnectionWithID connectionID: ConnectionID) {
        if let command = message as? CommandMessage {
            messages.onNext(command)
        }
    }

    func acceptedConnection(withID connectionID: ConnectionID) {
        connectedId = connectionID
        connected.accept(true)
    }

    func lostConnection(withID connectionID: ConnectionID) {
        connectedId = nil
        connected.accept(false)
    }
}
