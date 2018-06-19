//
//  ViewController.swift
//  RemoteSample
//
//  Created by iamchiwon on 2018. 6. 19..
//  Copyright © 2018년 ncode. All rights reserved.
//

import RxCocoa
import RxSwift
import Tibei
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var clientCountLabel: UILabel!
    @IBOutlet var clientIdLabel: UILabel!
    @IBOutlet var commandLabel: UILabel!
    @IBOutlet var parameterLabel: UILabel!
    
    lazy var viewModel = ServerViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }
    
    func bindUI() {
        viewModel.clientCount.map(i2s)
            .bind(to: clientCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.messageDriver.map({ $0.sender })
            .drive(clientIdLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.messageDriver.map({ $0.command })
            .drive(commandLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.messageDriver.map({ $0.parameter })
            .drive(parameterLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    @IBAction func sendToClient() {
        viewModel.send("World", "Hello")
    }
}
