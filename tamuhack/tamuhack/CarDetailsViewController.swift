//
//  CarDetailsViewController.swift
//  tamuhack
//
//  Created by Yesh N on 1/28/23.
//

import UIKit

class CarDetailsViewController: UIViewController, UpdateStatusDelegate {
    func updateStatus(s1: String, s2: String, s3: String, s4: String) {
        self.carBat = s1;
        self.carFluid = s2;
        self.carTire = s3;
        self.carOil = s4;
        imgB.image = UIImage(named: carBat)
        imgF.image = UIImage(named: carFluid)
        imgT.image = UIImage(named: carTire)
        imgO.image = UIImage(named: carOil)
    }
    

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var inspection: UILabel!
    @IBOutlet weak var imgB: UIImageView!
    @IBOutlet weak var imgF: UIImageView!
    @IBOutlet weak var imgT: UIImageView!
    @IBOutlet weak var imgO: UIImageView!
    
    @IBOutlet weak var ecolabel: UILabel!
    @IBOutlet weak var ecoimg: UIImageView!
    
    var carnum = 0
    
    var carBat = ""
    var carFluid = ""
    var carTire = ""
    var carOil = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (carnum == 1){
            img.image = UIImage(named: "civic2")
            name.text = "2022 Honda Civic"
            inspection.text = "Last Inspection: 2 months ago"
            imgB.image = UIImage(named: carBat)
            imgF.image = UIImage(named: carFluid)
            imgT.image = UIImage(named: carTire)
            imgO.image = UIImage(named: carOil)
            
            ecoimg.isHidden = false
            ecolabel.isHidden = false
            
        }
        else{
            img.image = UIImage(named: "porsche")
            name.text = "2017 Porsche Cayenne"
            inspection.text = "Last Inspection: 8 months ago"
            imgB.image = UIImage(named: carBat)
            imgF.image = UIImage(named: carFluid)
            imgT.image = UIImage(named: carTire)
            imgO.image = UIImage(named: carOil)
        }

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? UpdateViewController
        vc?.newcarBat = self.carBat
        vc?.newcarOil = self.carOil
        vc?.newcarFluid = self.carFluid
        vc?.newcarTire = self.carTire
        vc?.delegate = self;
    }
    
    @objc func updateLevels(){
        let controller = UpdateViewController()
        controller.delegate = self
        
        self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    
    @IBAction func goback(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

}
