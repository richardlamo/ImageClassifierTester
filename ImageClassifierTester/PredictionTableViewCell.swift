//
//  PredictionTableViewCell.swift
//  ImageClassifierTester
//
//  Created by Richard Lam on 3/1/21.
//

import UIKit

class PredictionTableViewCell: UITableViewCell {

    @IBOutlet weak var classifierLabel: UILabel!
    
    @IBOutlet weak var identifiderLabel: UILabel!
    
    @IBOutlet weak var confidenceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
