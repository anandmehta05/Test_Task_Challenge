//
//  StoryListTableViewCell.swift
//  Tasky
//
//  Created by Tej Shah on 2020-08-29.
//  Copyright © 2020 GeekMindz Solutions LLP. All rights reserved.
//

import UIKit

class StoryListTableViewCell: UITableViewCell {

    @IBOutlet weak var id_Label: UILabel!
    @IBOutlet weak var summary_Label: UILabel!
    @IBOutlet weak var type_Label: UILabel!
    @IBOutlet weak var complexity_Label: UILabel!
    @IBOutlet weak var estimateTime_Label: UILabel!
    @IBOutlet weak var cost_Label: UILabel!
    @IBOutlet weak var description_Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
