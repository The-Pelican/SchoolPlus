//
//  TestViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/9/1.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit
 
class TestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
     
    var tableView:UITableView?
     
    var items = ["这个是条目1","这个是条目2","这个是条目3","这个是条目4",
                 "这个是条目5","这个是条目6","这个是条目7","这个是条目8",]
     
    override func viewDidLoad() {
        super.viewDidLoad()
         
        //创建表格视图
        self.tableView = UITableView(frame:self.view.frame, style:.plain)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self,
                                 forCellReuseIdentifier: "SwiftCell")
        self.view.addSubview(self.tableView!)
    }
     
    //在本例中，有1个分区
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
     
    //返回表格行数（也就是返回控件数）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
     
    //创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            //为了提供表格显示性能，已创建完成的单元需重复使用
            let identify:String = "SwiftCell"
            //同一形式的单元格重复使用，在声明时已注册
            let cell = tableView.dequeueReusableCell(
                withIdentifier: identify, for: indexPath)
            cell.textLabel?.text = items[indexPath.row]
            return cell
    }
     
    //头部滑动事件按钮（右滑按钮）
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt
        indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //创建“更多”事件按钮
        let unread = UIContextualAction(style: .normal, title: "未读") {
            (action, view, completionHandler) in
            UIAlertController.showingAlert(message: "点击了“未读”按钮")
            completionHandler(true)
        }
        unread.backgroundColor = UIColor(red: 52/255, green: 120/255, blue: 246/255,
                                         alpha: 1)
         
        //返回所有的事件按钮
        let configuration = UISwipeActionsConfiguration(actions: [unread])
        return configuration
    }
     
    //尾部滑动事件按钮（左滑按钮）
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt
        indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //创建“更多”事件按钮
        let more = UIContextualAction(style: .normal, title: "更多") {
            (action, view, completionHandler) in
            UIAlertController.showingAlert(message: "点击了“更多”按钮")
            completionHandler(true)
        }
        more.backgroundColor = .lightGray
         
        //创建“旗标”事件按钮
        let favorite = UIContextualAction(style: .normal, title: "旗标") {
            (action, view, completionHandler) in
            UIAlertController.showingAlert(message: "点击了“旗标”按钮")
            completionHandler(true)
        }
        favorite.backgroundColor = .orange
         
         
        //创建“删除”事件按钮
        let delete = UIContextualAction(style: .destructive, title: "删除") {
            (action, view, completionHandler) in
            //将对应条目的数据删除
            self.items.remove(at: indexPath.row)
            completionHandler(true)
        }
         
        //返回所有的事件按钮
        let configuration = UISwipeActionsConfiguration(actions: [delete, favorite, more])
        return configuration
    }
     
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
 
//扩展UIAlertController
extension UIAlertController {
    //在指定视图控制器上弹出普通消息提示框
    static func showingAlert(message: String, in viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .cancel))
        viewController.present(alert, animated: true)
    }
     
    //在根视图控制器上弹出普通消息提示框
    static func showingAlert(message: String) {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            showAlert(message: message, in: vc)
        }
    }
}
