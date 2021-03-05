//
//  PaymentHistoryCell.swift
//  Mission Athletics
//
//  Created by ChiragGajjar on 23/12/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class PaymentHistoryCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblRequestId: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setPaymentDetails(objDetail:WithdrawrequestList){
         selectionStyle = .none
         lblAmount.text = "$\(objDetail.amount ?? 0)"
        // 1:Pending , 2:Paid 3:Reject
         if objDetail.status == .Pending{
             lblStatus.text = "Pending"
         }else if objDetail.status == .Paid{
             lblStatus.text = "Paid"
         }else{
             lblStatus.text = "Reject"
         }
         lblRequestId.text = "Withdrawal Request ID - \(objDetail.id ?? 0)"
         lblDate.text = getDayTimeWithDate(stringDate: objDetail.createdAt ?? "")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        
        // Configure the view for the selected state
    }

}
