//
//  CreatAnnouncementTVC.swift
//  misAppB
//
//  Created by XLiu on 2020/2/29.
//

import UIKit

class CreatAnnouncementTVC: UITableViewController, UploadFileCellDelegate {
    
    var isToTop = false
    var isShow = false
    var cells : Array<Int>? {
        didSet {
            self.tableView.reloadSections(IndexSet.init(arrayLiteral: 1), with: .fade)
        }
    }
    
    @IBOutlet var toTopBtns: [UIButton]!
    @IBOutlet var showBtn: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = .init()
        self.tableView.tableHeaderView = .init()
        self.tableView.register(UINib(nibName: "UploadFileCell", bundle: nil), forCellReuseIdentifier: "UploadFileCell")
    }

    func DeleteFile(cell: UploadFileCell) {
        cells?.remove(at: self.tableView.indexPath(for: cell)?.row ?? 0)
        self.tableView.reloadData()
    }
    
    @IBAction func toTopAction(_ sender: UIButton) {
        for btn in toTopBtns {
            btn.isSelected = sender.tag == btn.tag
        }
        isToTop = sender.tag == 1
    }
    
    @IBAction func ShowAction(_ sender: UIButton) {
        for btn in showBtn {
            btn.isSelected = sender.tag == btn.tag
        }
        isShow = sender.tag == 11
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
            let cell : UploadFileCell = tableView.dequeueReusableCell(withIdentifier: "UploadFileCell") as! UploadFileCell
            cell.delegate = self
            return cell
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 66
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if indexPath.section == 1 {
            let newIndexPath = IndexPath(row: 0, section: indexPath.section)
            return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
        }
        return super.tableView(tableView, indentationLevelForRowAt: indexPath)
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
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
