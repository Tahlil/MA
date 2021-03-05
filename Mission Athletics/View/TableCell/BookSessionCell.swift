//
//  BookSessionCell.swift
//  Mission Athletics
//
//  Created by MAC  on 13/09/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class BookSessionCell: UITableViewCell
{
    @IBOutlet weak var lblMinutes: UILabel!
    @IBOutlet weak var lblMinsSession: UILabel!
    @IBOutlet weak var ivCheckmark: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class BookSessionSelectedCell: UITableViewCell
{
    @IBOutlet weak var lblMinutes: UILabel!
    @IBOutlet weak var lblMinsSession: UILabel!
    @IBOutlet weak var ivCheckmark: UIImageView!
    @IBOutlet weak var lblSessionType: UILabel!
    @IBOutlet weak var lblSessionDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
