//
//  LeaveRequestFilterVC.swift
//  CheckSwift
//
//  Created by Mac on 20/2/25.
//  Copyright © 2020年 CheckSwift. All rights reserved.
//

import UIKit

protocol searchBtnDelegate: NSObjectProtocol {
    func searchBtnClick(searchName: String,ownXLId: String, deptId: String, leaveType: Int?)
}
class LeaveRequestFilterVC: PresentBottomVC {
    weak var filterDelegate: searchBtnDelegate?
    var isShowLeaveType: Bool = false //是否显示请假类别
    
    
    @IBOutlet weak var bottomView: UIView!
   private var dataArr = [[Dic]?]() //原始数据
   private var ownXLId: String?
   private var deptId: String?
   private var leaveType: Int?
   private let disGroup = DispatchGroup()
    //设置弹出控制器的高度
    override var controllerHeight: CGFloat {
        return ScreenHeight-60
    }
    lazy var collection : UICollectionView = {
        let layout =  UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 12
        layout.itemSize = CGSize(width: (ScreenWidth - 20*4)/3, height: 40)
//        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collect = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collect.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collect.backgroundColor = VCBackGroundColor
        collect.delegate = self
        collect.dataSource = self
        collect.register(LeaveFilterCollectionCell.self, forCellWithReuseIdentifier: "LeaveFilterCollectionCell")
        collect.register(CollectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionHeaderReusableView")
        return collect
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        disGroup.enter()
        HUDShow()
        getOwnXL()
        disGroup.enter()
        getDept()
        disGroup.notify(queue: DispatchQueue.main) {[weak self] in
            self?.HUDHide()
            if self!.isShowLeaveType {
                let type = ["事假","病假","婚假","产假","丧假","其他","年假","调休"]
                let leaveType = type.enumerated().map { (arg) -> Dic in
                    let (index, element) = arg
                    let dic = Dic()
                            dic.Id = "\(index)"
                           dic.Name = element
                           return dic
                       }
                self?.dataArr.append(leaveType)
            }
            self?.collection.reloadData()
        }
    }
    func initUI() {
        view.backgroundColor = VCBackGroundColor
        view.addSubview(collection)
        collection.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(searchBar.snp_bottomMargin)
            make.bottom.equalTo(bottomView.snp_topMargin)
        }
        
        titleLab.text = "筛选条件"
        searchBar.placeholder = "请输入姓名"
    }
    
    @IBAction func dismissVC(sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //重置
    override func rightBtnClick() {
        for i in 0..<dataArr.count {
            changeSelected(section: i, arr: dataArr[i]!)
       }
        searchBar.text = ""
         ownXLId = ""
         deptId = ""
         leaveType = nil
       collection.reloadData()
    }
    @IBAction func searchBtn(_ sender: Any) {
        filterDelegate?.searchBtnClick(searchName: searchBar.text ?? "" ,ownXLId: ownXLId ?? "", deptId: deptId ?? "", leaveType: leaveType ?? nil)
        dismissVC(sender: "")
        
    }
    func changeSelected(section: Int, arr: [Dic]){
        for (index,model) in arr.enumerated() {
            if section == 2 {
                model.selected = false
            }else{
                model.selected = index == 0 ? true : false
            }
        }
    }
    //所属序列
    func getOwnXL() {
        AFNetWorkingTool.shared.post(urlString: GetOwnXL, parampeters: nil, success: { [weak self] (ResponseInfo) in
                guard let strongSelf = self else { return }
                if ResponseInfo.error == 0 {
                    guard var arr = Array<Dic>.deserialize(from: ResponseInfo.items as? [Any]) else {return}
                    let all = Dic.init(id: "", name: "全部")
                    all.selected = true
                    arr.insert(all, at: 0)
                    strongSelf.dataArr.insert(arr as? [Dic], at: 0)
                }else{
                    strongSelf.HUDShowWithText(text: ResponseInfo.msg)
                }
                strongSelf.disGroup.leave()
            }) { [weak self] (error) in
                guard let strongSelf = self else { return }
                strongSelf.HUDShowWithText(text: error.localizedDescription)
            }
    }
    //部门
    func getDept() {
        AFNetWorkingTool.shared.post(urlString: GetDept, parampeters: nil, success: { [weak self] (ResponseInfo) in
            guard let strongSelf = self else { return }
            if ResponseInfo.error == 0 {
                guard var arr = Array<Dic>.deserialize(from: ResponseInfo.items as? [Any]) else {return}
                let all = Dic.init(id: "", name: "全部")
                all.selected = true
                arr.insert(all, at: 0)
                strongSelf.dataArr.append(arr as? [Dic])
                strongSelf.disGroup.leave()
            }else{
                strongSelf.HUDShowWithText(text: ResponseInfo.msg)
            }
            
        }) { [weak self] (error) in
            guard let strongSelf = self else { return }
            strongSelf.HUDShowWithText(text: error.localizedDescription)
        }
    }

}
extension LeaveRequestFilterVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataArr.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let data: Array = dataArr[section]!
        return data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LeaveFilterCollectionCell", for: indexPath) as! LeaveFilterCollectionCell
        let data = dataArr[indexPath.section]
        cell.deptModel = data?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionArr = dataArr[indexPath.section]
        let _ = sectionArr?.map({ (model: Dic) in
            model.selected = false
        })
        let model = dataArr[indexPath.section]?[indexPath.row]
        model?.selected = true
        switch indexPath.section {
        case 0:
            ownXLId = model?.Id
        case 1:
            deptId = model?.Id
        case 2:
            leaveType = Int(model!.Id!)
        default:
            break
        }
        
        UIView.performWithoutAnimation {
           collectionView.reloadSections(IndexSet(integer: indexPath.section))
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
               let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionHeaderReusableView", for: indexPath) as! CollectionHeaderReusableView
            switch indexPath.section {
            case 0:
                header.categorylab.text = "所属序列"
            case 1:
                header.categorylab.text = "所属部门"
            case 2:
                header.categorylab.text = "请假类别"
            default:
                break
            }
                return header
            }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
           
        return CGSize(width: ScreenWidth, height: 60)
    }
    
}
