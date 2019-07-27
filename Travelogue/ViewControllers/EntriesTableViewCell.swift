//
//  EntriesTableViewCell.swift
//  Travelogue
//
//  Created by Felipe Costa on 7/23/19.
//  Copyright © 2019 Felipe Costa. All rights reserved.
//

import UIKit

class EntriesTableViewCell: UITableViewCell {

    @IBOutlet weak var entryImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
