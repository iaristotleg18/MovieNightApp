//
//  AutoCompleteTableViewCell.swift
//  movieNightApp
//
//  Created by Spencer Brown on 3/18/18.
//  Copyright © 2018 Isaiah Glick. All rights reserved.
//

import UIKit

protocol AutoCompleteResultsDelegate {
    func selectedMovie(movie: Movie)
}

class AutoCompleteTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    var delegate: AutoCompleteResultsDelegate?;
    var data: Movie?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
