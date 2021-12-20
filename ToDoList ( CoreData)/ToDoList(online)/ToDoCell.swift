//
//  ToDoCell.swift
//  ToDoList(online)
//
//  Created by Fatimah Ayeidh (فاطمة عايض) on 13/05/1443 AH.
//

import UIKit

class ToDoCell: UITableViewCell {
    
    @IBOutlet weak var todoTitleLable: UILabel!
    
    @IBOutlet weak var todoCreationDateLable: UILabel!
    
    @IBOutlet weak var todoImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
}
