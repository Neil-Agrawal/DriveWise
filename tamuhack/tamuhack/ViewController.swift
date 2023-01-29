//
//  ViewController.swift
//  tamuhack
//
//  Created by Yesh N on 1/28/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var button: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var googleSign: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.layer.cornerRadius = 15
        password.layer.cornerRadius = 15
        signIn.layer.cornerRadius = 15
        googleSign.layer.cornerRadius = 15
        
    }

    @IBAction func goToHome(_ sender: Any) {
        print("hello")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is HomePageViewController{
            let vc = segue.destination as? HomePageViewController
            vc?.name = username.text!
        }
    }
    
    
}

