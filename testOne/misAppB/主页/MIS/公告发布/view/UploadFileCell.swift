//
//  UploadFileCell.swift
//  misAppB
//
//  Created by XLiu on 2020/2/29.
//

import UIKit

protocol UploadFileCellDelegate {
    func DeleteFile(cell:UploadFileCell)
   }

class UploadFileCell: UITableViewCell {
    
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var dateLab: UILabel!
    @IBOutlet weak var fileSizeLab: UILabel!
    var delegate:UploadFileCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func deletAction(_ sender: UIButton) {
        delegate?.DeleteFile(cell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
