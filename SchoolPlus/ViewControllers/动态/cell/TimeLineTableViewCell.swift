//
//  TimeLineTableViewCell.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/8/25.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit

class TimeLineTableViewCell: UITableViewCell {
    static let identifier = "timeLineTableViewCell"
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var picView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initTableView()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.backgroundColor = UIColor.blue
    }
}

extension TimeLineTableViewCell: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cellid = "cellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellid)
        if cell==nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellid)
        }
        cell?.textLabel?.text = "这个是内容~"
        return cell!
    }
    
    
}
