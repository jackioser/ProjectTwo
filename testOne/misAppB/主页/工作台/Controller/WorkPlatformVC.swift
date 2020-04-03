//
//  WorkPlatformVC.swift
//  misAppB
//
//  Created by XLiu on 2020/2/26.
//

import UIKit

class WorkPlatformVC: CustomViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cells = [Dictionary](arrayLiteral: ["title":"项目管理","image":"WP_ProjectManage"],
                 ["title":"人力资源管理","image":"WP_HRManage"],
                 ["title":"OA办公管理","image":"WP_OAManage"],
                 ["title":"文档管理","image":"WP_ DocumentManage"],
                 ["title":"采购管理","image":"WP_ProcureManage"],
                 ["title":"财务管理","image":"WP_FinancialManage"],
                 ["title":"销售管理","image":"WP_SaleManage"],
                 ["title":"合同管理","image":"WP_ContractManage"],
                 ["title":"库存管理","image":"WP_InventoryManage"]
                 )
    
    lazy var collectView : UICollectionView  = {
        let flow = UICollectionViewFlowLayout.init()
        flow.minimumLineSpacing = 24
        flow.minimumInteritemSpacing = 15
        flow.sectionInset = UIEdgeInsets(top: 22, left: 21, bottom: 10, right: 21)
        flow.itemSize = CGSize(width: (ScreenWidth - 72)/3, height: 116)
        let view = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), collectionViewLayout: flow)
        view.backgroundColor = .clear
        view.register(UINib(nibName: "WPMainCell", bundle: nil), forCellWithReuseIdentifier: "WPMainCell")
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "工作台"
        self.initView()
    }
    
    func initView() {
        self.view.addSubview(collectView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:WPMainCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WPMainCell", for: indexPath) as! WPMainCell
        let info:Dictionary = cells[indexPath.item]
        cell.setContent(imageName: info["image"]!, title: info["title"]!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            let wvc = WPProjectManageVC()
            wvc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(wvc, animated: true)
            return
        case 8:
            let vc = LeaveRequestVC()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            return
        default:
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}
