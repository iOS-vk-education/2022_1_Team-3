//
//  DemoTableViewCell.swift
//  DeadLine
//
//  Created by Андрей Кравцов on 19.04.2022.
//

import UIKit

class DemoTableViewCell: UITableViewCell {
    
    @IBOutlet var myLablel: UILabel!
    @IBOutlet var myOption: UIButton!
    @IBOutlet weak var cell: UIView!
    @IBOutlet weak var roundIndicator: UIImageView!
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cell.layer.cornerRadius = 15
        cell.layer.shadowRadius = 5
        cell.layer.shadowOpacity = 0.25
        cell.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    func setCellHeader(_ title:String){
        self.myLablel.text = title
    }
    
    @IBAction func radioSelected(_ sender: UIButton){
        self.myOption.isSelected = !self.myOption.isSelected
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
