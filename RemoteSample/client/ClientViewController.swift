//
//  ClientViewController.swift
//  RemoteSample
//
//  Created by iamchiwon on 2018. 6. 19..
//  Copyright © 2018년 ncode. All rights reserved.
//

import RxCocoa
import RxSwift
import Tibei
import UIKit

class ClientViewController: UIViewController {
    
    @IBOutlet var connectedIndicator: UIView!
    @IBOutlet var textView: UITextView!
    
    lazy var viewModel = ClientViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.messageDriver.map({ "\($0.sender) \($0.command) \($0.parameter)" })
            .drive(textView.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.client.connected.map({ $0 ? UIColor.green : UIColor.red })
            .subscribe(onNext: { [weak self] color in
                self?.connectedIndicator.backgroundColor = color
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func sendMessageButtonTapped(_ sender: Any) {
        viewModel.send("Hello")
    }
}
