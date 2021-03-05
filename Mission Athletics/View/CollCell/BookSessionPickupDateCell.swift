//
//  BookSessionPickupDateCell.swift
//  Mission Athletic
//
//  Created by ChiragGajjar on 13/09/19.
//  Copyright © 2019 Trootech. All rights reserved.
//

import UIKit

class BookSessionPickupDateCell: UICollectionViewCell {
    
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var vwBackground: UIView!
    
    
    func setBookSessionPickupDetails(objData:[String:Any]){
        lblDate.text = objData["date"] as? String ?? ""
        lblMonth.text = objData["month"] as? String ?? ""
        let strDate = objData["date"] as? String ?? ""
        
        if strDate.last == "1"{
            lblDate.text = "\(strDate)st"
        }else if strDate.last == "2"{
            lblDate.text = "\(strDate)nd"
        }else if strDate.last == "3"{
            lblDate.text = "\(strDate)rd"
        }else{
            lblDate.text = "\(strDate)th"
        }
    }
}
