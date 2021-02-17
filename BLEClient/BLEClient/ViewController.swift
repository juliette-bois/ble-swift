//
//  ViewController.swift
//  BLEClient
//
//  Created by Juliette Bois on 12.02.21.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {

    @IBOutlet weak var readField: UITextField!
    @IBOutlet weak var writeField: UITextField!
    var periphReady: Bool = false
    var periph: CBPeripheral?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func scanClicked(_ sender: Any) {
        print("scan")
        BLEManager.instance.scan { periph, name in
            print(name)
            if name == "TUTU" {
                BLEManager.instance.stopScan()
                BLEManager.instance.connectPeripheral(periph) { per in
                
                    self.periph = periph
                    
                    BLEManager.instance.discoverPeripheral(per) { (periphReady) in
                        self.periphReady = true
                    }
                }
            }
        }
    }
    
    @IBAction func readClicked(_ sender: Any) {
        print("read")
        if self.periphReady == true {
            BLEManager.instance.listenForMessages(callback: { (data) in
                print("read \(String(describing: data))")
            })
        }
    }
    
    @IBAction func writeClicked(_ sender: Any) {
        print("write")
        if self.periphReady == true {
            if let data = writeField.text?.data(using: .utf8) {
                BLEManager.instance.sendData(data: data) { (success) in
                    print("success")
                }
            }
        }
    }
}

