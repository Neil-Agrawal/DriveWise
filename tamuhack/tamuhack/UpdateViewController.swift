//
//  UpdateViewController.swift
//  tamuhack
//
//  Created by Yesh N on 1/28/23.
//

import UIKit

protocol UpdateStatusDelegate{
    func updateStatus(s1: String, s2: String, s3: String, s4: String)
}

class UpdateViewController: UIViewController {
    
    var delegate: UpdateStatusDelegate?

    @IBOutlet weak var batSwitch: UISwitch!
    @IBOutlet weak var fluidSwitch: UISwitch!
    @IBOutlet weak var tireSwitch: UISwitch!
    @IBOutlet weak var oilSwitch: UISwitch!
    
    var newcarBat = ""
    var newcarFluid = ""
    var newcarTire = ""
    var newcarOil = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goBack(_ sender: Any) {
        if (batSwitch.isOn) {newcarBat = "yes"}
        if (fluidSwitch.isOn) {newcarFluid = "yes"}
        if (tireSwitch.isOn) {newcarTire = "yes"}
        if (oilSwitch.isOn) {newcarOil = "yes"}
        
        
        print(newcarBat, newcarFluid, newcarTire, newcarOil)
        delegate?.updateStatus(s1: newcarBat, s2: newcarFluid, s3: newcarTire, s4: newcarOil)
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
