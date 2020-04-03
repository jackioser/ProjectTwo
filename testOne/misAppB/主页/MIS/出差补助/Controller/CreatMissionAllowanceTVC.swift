//
//  CreatMissionAllowanceTVCTableViewController.swift
//  misAppB
//
//  Created by XLiu on 2020/3/1.
//

import UIKit

class CreatMissionAllowanceTVC: UITableViewController {
    
    var cells : Array<Int>?{
        didSet {
            self.tableView.reloadSections(IndexSet.init(arrayLiteral: 1), with: .fade)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = .init()
        self.tableView.tableHeaderView = .init()
        self.tableView.register(UINib(nibName: "MissionDetailCell", bundle: nil), forCellReuseIdentifier: "MissionDetailCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return cells?.count ?? 0
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell:MissionDetailCell = tableView.dequeueReusableCell(withIdentifier: "MissionDetailCell") as! MissionDetailCell
            return cell
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
             let vc = UIStoryboard.init(name: "MissionAllowance", bundle: nil).instantiateViewController(withIdentifier: "MissionDetailTVC")
            parent?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 66
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let view = UIView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 50))
            view.backgroundColor = .clear
            
            let subvView = UIView.init(frame: CGRect(x: 20, y: 0, width: ScreenWidth - 15, height: 0.2))
            subvView.backgroundColor = UIColorFromRGB(color_vaule: "#B1B2B6")
            
            let lab = UILabel.init(frame: CGRect(x: 20, y: 20, width: 100, height: 20))
            lab.font = UIFont.systemFont(ofSize: 18)
            lab.textColor = UIColorFromRGB(color_vaule: "#424D5C")
            lab.backgroundColor = .clear
            lab.text = "出差明细"
            
            view.addSubview(subvView)
            view.addSubview(lab)
            return view
        }
        return super.tableView(tableView, viewForHeaderInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 50
        }
        return super.tableView(tableView, heightForHeaderInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if indexPath.section == 1 {
            let newIndexPath = IndexPath(row: 0, section: indexPath.section)
            return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
        }
        return super.tableView(tableView, indentationLevelForRowAt: indexPath)
    }
    
    func UIColorFromRGB(color_vaule : String , alpha : CGFloat = 1) -> UIColor {
        if color_vaule.isEmpty {
            return UIColor.clear
        }
        var cString = color_vaule.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if cString.count == 0 {
            return UIColor.clear
        }
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        if cString.count < 6 && cString.count != 6 {
            return UIColor.clear
        }
        let value = "0x\(cString)"
        let scanner = Scanner(string:value)
        var hexValue : UInt64 = 0
        //查找16进制是否存在
        if scanner.scanHexInt64(&hexValue) {
            print(hexValue)
            let redValue = CGFloat((hexValue & 0xFF0000) >> 16)/255.0
              let greenValue = CGFloat((hexValue & 0xFF00) >> 8)/255.0
              let blueValue = CGFloat(hexValue & 0xFF)/255.0
              return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: alpha)
        }else{
            return UIColor.clear
        }
    }

}
