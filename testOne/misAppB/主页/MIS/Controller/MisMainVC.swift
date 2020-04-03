//
//  MisMainVC.swift
//  misAppB
//
//  Created by XLiu on 2020/2/26.
//

import UIKit

class MisMainVC: CustomViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MisMainHeaderViewDelegate {
    
    var audits = [AuditList?]()
    var submits = [SubmitList?]()
    var messages = [MessageList?]()
    var notices = [NoticeList?]()
    
    lazy var collectView : UICollectionView  = {
        let flow = UICollectionViewFlowLayout.init()
        let view = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), collectionViewLayout: flow)
        view.backgroundColor = VCBackGroundColor
        view.register(UINib(nibName: "MisSquareCell", bundle: nil), forCellWithReuseIdentifier: "MisSquareCell")
        view.register(UINib(nibName: "MisMessageCell", bundle: nil), forCellWithReuseIdentifier: "MisMessageCell")
        view.register(UINib(nibName: "MisMainHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MisMainHeaderView")
        view.register(UINib(nibName: "MisMainFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "MisMainFooterView")
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    func initView() {
        self.view.addSubview(collectView)
        
//        self.navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(), style: UIBarButtonItem.Style.done, target: self, action: nil)
//        self.LeftTitle(title: "Hi, Alpha")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for indx in 0...3 {
            getData(type: indx)
        }
    }

    
//    MARK:NetWorking
    
    func getData(type:Int) {
        var param = [String:Any]()
        param["pageIndex"] = "1"
        param["pageSize"] = "10"
        var urlString:String!
        switch type {
        case 0:
            param["IsPaging"] = false
            urlString = GetAuditList //获取审批列表
        case 1:
            param["IsPaging"] = false
            urlString = GetSubmitList //提交申请列表
        case 2:
            urlString = GetMessageList //获取消息列表（首页）
        case 3:
            urlString = GetNoticeList //获取公告列表（首页)
        default:
            break
        }
        AFNetWorkingTool.shared.post(urlString: urlString, parampeters: param, success: { [weak self] (ResponseInfo) in
            guard let strongSelf = self else { return }
            switch type {
            case 0:
                let ary = Array<AuditList>.deserialize(from: ResponseInfo.items as? [Any])
                if ary != nil {
                    strongSelf.audits += ary!
                }
            case 1:
                let ary = Array<SubmitList>.deserialize(from: ResponseInfo.items as? [Any])
                if ary != nil {
                    strongSelf.submits += ary!
                }
            case 2:
                let ary = Array<MessageList>.deserialize(from: ResponseInfo.items as? [Any])
                if ary != nil {
                    strongSelf.messages += ary!
                }
                
            case 3:
                let ary = Array<NoticeList>.deserialize(from: ResponseInfo.items as? [Any])
                if ary != nil {
                    strongSelf.notices += ary!
                }
            default:
                break
            }
            strongSelf.collectView.reloadSections(NSIndexSet(index: type) as IndexSet)
        }) { (Error) in
            
        }
    }
    
//    MARK:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return audits.count > 4 ? 4 : audits.count
        }
        if section == 1 {
            return submits.count > 4 ? 4 : submits.count
        }
        if section == 2 {
            return messages.count > 4 ? 4 : messages.count
        }
        if section == 3 {
            return notices.count > 4 ? 4 : notices.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell : MisSquareCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MisSquareCell", for: indexPath) as! MisSquareCell
            cell.setAudit(info: audits[indexPath.item]!)
            return cell
        }
        if indexPath.section == 1 {
            let cell : MisSquareCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MisSquareCell", for: indexPath) as! MisSquareCell
            cell.setSubmit(info: submits[indexPath.item]!)
            return cell
        }
        if indexPath.section == 2 {
            let cell : MisMessageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MisMessageCell", for: indexPath) as! MisMessageCell
            return cell
        }
        if indexPath.section == 3 {
            let cell : MisMessageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MisMessageCell", for: indexPath) as! MisMessageCell
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MisSquareCell", for: indexPath)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 || indexPath.section == 1 {
            return CGSize.init(width: (ScreenWidth - 51)/2, height: 116)
        }
        return CGSize.init(width: ScreenWidth - 40, height: 72)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 11
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 11
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header : MisMainHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MisMainHeaderView", for: indexPath) as! MisMainHeaderView
            header.delegate = self;
            header.pullBtn.tag = indexPath.section
            switch indexPath.section {
            case 0:
                header.titleLab.text = "待审批"
            case 1:
                header.titleLab.text = "我的申请"
            case 2:
                header.titleLab.text = "消息"
            case 3:
                header.titleLab.text = "公告"
            default:
                break
            }
            
            return header
        } else if kind == UICollectionView.elementKindSectionFooter {
            let footer : MisMainFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "MisMainFooterView", for: indexPath) as! MisMainFooterView
            if indexPath.row == 0 || indexPath.row == 1 {
                footer.footerView.backgroundColor = .clear
            } else {
                footer.footerView.backgroundColor = .white
            }
            if indexPath.section == 0 && audits.count > 4 {
                footer.redCircelLab.text = String(audits.count - 4)
            }
            if indexPath.section == 1 && submits.count > 4 {
                footer.redCircelLab.text = String(submits.count - 4)
            }
            return footer
        }
        return UICollectionReusableView.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: ScreenWidth, height: 54)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: ScreenWidth, height: audits.count > 4 ? 44 : 0)
        }
        if  section == 1 {
            return CGSize(width: ScreenWidth, height: submits.count > 4 ? 44 : 0)
        }
        return CGSize(width: ScreenWidth, height: 0)
    }
    
    func pullDown(index: NSInteger) {
//        collectView.reloadSections(NSIndexSet.init(index: index) as IndexSet)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
