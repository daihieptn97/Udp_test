//
//  ViewController.swift
//  Udp2
//
//  Created by Trần Hiệp on 5/9/20.
//  Copyright © 2020 Trần Hiệp. All rights reserved.
//

import UIKit
import Network

class ViewController: UIViewController {
    var connection: NWConnection?
    
    
    @IBOutlet weak var btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        someFunc();
    }
    
    func someFunc() {
        
        self.connection = NWConnection(host: "0.0.0.0", port: 8888, using: .udp)
        
        self.connection?.stateUpdateHandler = { (newState) in
            switch (newState) {
            case .ready:
                print("ready")
                self.send()
                self.receive()
            case .setup:
                print("setup")
            case .cancelled:
                print("cancelled")
            case .preparing:
                print("Preparing")
            default:
                print("waiting or failed")
                
            }
        }
        self.connection?.start(queue: .global())
        
    }
    
    func send() {
        self.connection?.send(content: "Test message".data(using: String.Encoding.utf8), completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
            if NWError != nil {
                print(NWError as Any);
            }
            
            }
            )
            )
        )
    }
    
    func receive() {
        print("Got it 0")
        self.connection?.receiveMessage { (data, context, isComplete, error) in
            print("Got it")
            print(data ?? "cha co gi");
        }
    }
    
    @IBAction func doSendUdpCommand(_ sender: Any) {
        self.showToast(message: "UDp Da send")
        self.send();
        
    }
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
}

