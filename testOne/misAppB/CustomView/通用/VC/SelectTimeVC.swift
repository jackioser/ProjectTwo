//
//  SelectTimeVC.swift
//  misAppA
//
//  Created by 苏奎 on 2020/3/2.
//
import Foundation
import UIKit

class SelectTimeVC: PresentBottomVC, UICollectionViewDataSource, UICollectionViewDelegate, UIPopoverPresentationControllerDelegate {
    
    var startDate: Date? //如果用户是在选择结束时间，与其比较下 yyyy-MM-dd HH:mm 格式
    var selectDate:((String)->())?
    var calculationTime: Bool = false //是否计算时间
    var selectEndDateWithdurationTime:((_ endDtae: String, _ duration: String)->())?
    //设置弹出控制器的高度
    override var controllerHeight: CGFloat {
        return ScreenHeight-120
    }
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSize.init(width: ScreenWidth/7.0, height: ScreenWidth/7.0)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 128, width: ScreenWidth, height: ScreenWidth), collectionViewLayout: flowLayout)
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib.init(nibName: "SelectTimeCollectionCell", bundle: nil), forCellWithReuseIdentifier: "SelectTimeCollectionCell")
        collectionView.backgroundColor = VCBackGroundColor
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    //backgroundView和屏幕高度的差别
    lazy var backgroundViewTopSpace: CGFloat = 0
    lazy var backgroundView: UIView = {
        let view = UIView.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: backgroundViewTopSpace), size: CGSize.init(width: ScreenWidth, height: ScreenHeight-backgroundViewTopSpace)))
        view.backgroundColor = .clear
        let view1 = UIView.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 64), size: CGSize.init(width: ScreenWidth, height: ScreenHeight-backgroundViewTopSpace-64)))
        view1.backgroundColor = VCBackGroundColor
        view.addSubview(view1)
        
        let layer = CAShapeLayer.init()
        let path = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 64), byRoundingCorners: [.topLeft, . topRight], cornerRadii: CGSize.init(width: 5, height: 5))
        layer.path = path.cgPath
        layer.fillColor = UIColor.white.cgColor
        view.layer.addSublayer(layer)
        
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "navLeftXX"), for: .normal)
        button.frame = CGRect.init(origin: CGPoint.init(x: 0, y: 7), size: CGSize.init(width: 50, height: 50))
        view.addSubview(button)
        button.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        
        let label = UILabel.init()
        label.center = CGPoint.init(x: ScreenWidth/2, y: 32)
        label.bounds = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 150, height: 20))
        label.textAlignment = .center
        label.textColor = .darkText
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = showText ?? "请选择时间"
        view.addSubview(label)
        
        let button1 = UIButton.init(type: .custom)
        button1.setTitle("确定", for: .normal)
        button1.setTitleColor(.darkText, for: .normal)
        button1.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button1.frame = CGRect.init(origin: CGPoint.init(x: ScreenWidth-60, y: 7), size: CGSize.init(width: 50, height: 50))
        view.addSubview(button1)
        button1.addTarget(self, action: #selector(confirm(_:)), for: .touchUpInside)
        
        let line = UIView.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 63), size: CGSize.init(width: ScreenWidth, height: 1)))
        line.backgroundColor = VCBackGroundColor
        view.addSubview(line)
        return view
    }()
    
    lazy var monthSelectView: UIView = {
        let view = UIView.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 64), size: CGSize.init(width: ScreenWidth, height: 64)))
        view.backgroundColor = .white
        
        let leftBtn = UIButton.init(type: .system)
        leftBtn.setTitle("<<", for: .normal)
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        leftBtn.setTitleColor(.black, for: .normal)
        leftBtn.bounds = CGRect.init(x: 0, y: 0, width: 30, height: 50)
        leftBtn.center = CGPoint.init(x: 27, y: 32)
        leftBtn.addTarget(self, action: #selector(lastYear(_:)), for: .touchUpInside)
        view.addSubview(leftBtn)
        
        let leftOneBtn = UIButton.init(type: .system)
        leftOneBtn.setTitle("<", for: .normal)
        leftOneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        leftOneBtn.setTitleColor(.black, for: .normal)
        leftOneBtn.bounds = CGRect.init(x: 0, y: 0, width: 30, height: 50)
        leftOneBtn.center = CGPoint.init(x: 69, y: 32)
        leftOneBtn.addTarget(self, action: #selector(lastMonth(_:)), for: .touchUpInside)
        view.addSubview(leftOneBtn)
        
        let rightBtn = UIButton.init(type: .system)
        rightBtn.setTitle(">>", for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        rightBtn.setTitleColor(.black, for: .normal)
        rightBtn.bounds = CGRect.init(x: 0, y: 0, width: 30, height: 50)
        rightBtn.center = CGPoint.init(x: ScreenWidth-27, y: 32)
        rightBtn.addTarget(self, action: #selector(nextYear(_:)), for: .touchUpInside)
        view.addSubview(rightBtn)
        
        let rightOneBtn = UIButton.init(type: .system)
        rightOneBtn.setTitle(">", for: .normal)
        rightOneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        rightOneBtn.setTitleColor(.black, for: .normal)
        rightOneBtn.bounds = CGRect.init(x: 0, y: 0, width: 30, height: 50)
        rightOneBtn.center = CGPoint.init(x: ScreenWidth-69, y: 32)
        rightOneBtn.addTarget(self, action: #selector(nextMonth(_:)), for: .touchUpInside)
        view.addSubview(rightOneBtn)
        
        let mLabel = UILabel.init()
        mLabel.textAlignment = .center
        mLabel.font = UIFont.systemFont(ofSize: 16)
        mLabel.center = CGPoint.init(x: ScreenWidth/2-50, y: 32)
        mLabel.bounds = CGRect.init(x: 0, y: 0, width: 50, height: 20)
        view.addSubview(mLabel)
        monthLabel = mLabel
        
        let yLabel = UILabel.init()
        yLabel.textAlignment = .center
        yLabel.font = UIFont.systemFont(ofSize: 16)
        yLabel.center = CGPoint.init(x: ScreenWidth/2+50, y: 32)
        yLabel.bounds = CGRect.init(x: 0, y: 0, width: 50, height: 20)
        view.addSubview(yLabel)
        yearLabel = yLabel
        
        return view
    }()
    
    lazy var timeView: UIView = {
        let view = UIView.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 128+ScreenWidth), size: CGSize.init(width: 150, height: 64)))
        view.backgroundColor = .clear
        
        let mLabel = UILabel.init()
        mLabel.textAlignment = .center
        mLabel.text = "时间"
        mLabel.font = UIFont.boldSystemFont(ofSize: 16)
        mLabel.center = CGPoint.init(x: 30, y: 32)
        mLabel.bounds = CGRect.init(x: 0, y: 0, width: 40, height: 20)
        view.addSubview(mLabel)
        
        let button = UIButton.init(type: .system)
        button.center = CGPoint.init(x: 75, y: 32)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.bounds = CGRect.init(x: 0, y: 0, width: 40, height: 35)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.setTitleColor(.black, for: .normal)
        view.addSubview(button)
        button.addTarget(self, action: #selector(selectHour(_:)), for: .touchUpInside)
        hourButton = button
        
        let colonLabel = UILabel.init()
        colonLabel.textAlignment = .center
        colonLabel.text = ":"
        colonLabel.font = UIFont.boldSystemFont(ofSize: 16)
        colonLabel.center = CGPoint.init(x: 100, y: 32)
        colonLabel.bounds = CGRect.init(x: 0, y: 0, width: 10, height: 20)
        view.addSubview(colonLabel)
        
        let button1 = UIButton.init(type: .system)
        button1.center = CGPoint.init(x: 125, y: 32)
        button1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button1.bounds = CGRect.init(x: 0, y: 0, width: 40, height: 35)
        button1.backgroundColor = .white
        button1.layer.cornerRadius = 5
        button1.setTitleColor(.black, for: .normal)
        view.addSubview(button1)
        button1.addTarget(self, action: #selector(selectMinute(_:)), for: .touchUpInside)
        minuteButton = button1
        
        return view
    }()
    
    lazy var calendar: Calendar = {
        var calendar = Calendar.init(identifier: .gregorian)
        calendar.firstWeekday = 1
        return calendar
    }()
    
    lazy var numberFormatter: NumberFormatter = {
        var numberFormatter = NumberFormatter.init()
        numberFormatter.numberStyle = .spellOut
        numberFormatter.locale = Locale.init(identifier: "zh_Hans")
        return numberFormatter
    }()
    
    lazy var dateFormatter: DateFormatter = {
        var formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()
    
    var monthLabel: UILabel?
    var yearLabel: UILabel?
    var hourButton: UIButton?
    var minuteButton: UIButton?
    
    var showText: String?
    var currentDate = Date.init() //用来获取collectionView的显示数据，不是用户点击选择的日期
    lazy var selectedComponents: DateComponents? = {
        return calendar.dateComponents([.day, .year, .month], from: Date.init())
    }()

    var headerArray = ["日", "一", "二" , "三" , "四" , "五" , "六"]
    var dataArray: [DateComponents]?
    var index: (begin: Int, end: Int) = (0, 0)
    
    //MARK: -
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.addSubview(monthSelectView)
        backgroundView.addSubview(collectionView)
        backgroundView.addSubview(timeView)
        view.addSubview(backgroundView)
        
        getData()
        let str = dateFormatter.string(from: currentDate)
        hourButton?.setTitle(String.init(str.suffix(5).prefix(2)), for: .normal)
        minuteButton?.setTitle(String.init(str.suffix(5).suffix(2)), for: .normal)
    }
    
    //MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 7 : 42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectTimeCollectionCell", for: indexPath) as! SelectTimeCollectionCell
        if indexPath.section == 0 {
            //section0为星期
            cell.contentLabel.text = headerArray[indexPath.item]
            cell.contentLabel.textColor = .darkText
            cell.bottomLine.isHidden = false
            cell.isUserInteractionEnabled = false
        }else {
            cell.isUserInteractionEnabled = true
            if indexPath.row < index.begin || indexPath.row > index.end {
                cell.contentLabel.textColor = .lightGray
            }else if indexPath.row%7 == 0 || (indexPath.row+1)%7 == 0 {
                cell.contentLabel.textColor = .red
            }else {
                cell.contentLabel.textColor = .darkText
            }
            if let components = dataArray?[indexPath.item] {
                cell.isSelected = false
                if let selected = selectedComponents, selected.year == components.year, selected.month == components.month, selected.day == components.day {
                    cell.contentLabel.textColor = .white
                    //置为选中状态
                    cell.isSelected = true
                    collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
                }
                cell.contentLabel.text = "\(components.day ?? 0)"
            }
            cell.bottomLine.isHidden = true
        }
        return cell
    }
    
    //MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 && !(indexPath.row < index.begin || indexPath.row > index.end) {
            if let cell = collectionView.cellForItem(at: indexPath) as? SelectTimeCollectionCell {
                cell.contentLabel.textColor = .white
                cell.isSelected = true
                selectedComponents = dataArray?[indexPath.item] ?? nil
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 && !(indexPath.row < index.begin || indexPath.row > index.end) {
            if let cell = collectionView.cellForItem(at: indexPath) as? SelectTimeCollectionCell {
                if indexPath.row%7 == 0 || (indexPath.row+1)%7 == 0 {
                    cell.contentLabel.textColor = .red
                }else {
                    cell.contentLabel.textColor = .darkText
                }
                cell.isSelected = false
            }
        }
    }
    
//    //MARK: - UIViewControllerTransitioningDelegate
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return SelectVCAnimator.init(type: .present)
//    }
//
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return SelectVCAnimator.init(type: .dismiss)
//    }
    
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        return TestPresentationController.init(presentedViewController: presented, presenting: presenting)
//    }
//
    
    //MARK: - UIAdaptivePresentationControllerDelegate
    //必须加上此方法才能有popOver的效果
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    //MARK: - action
    
    @objc func back(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func confirm(_ sender: UIButton) {
        guard let components = selectedComponents, let date = calendar.date(from: components) else {
            HUDShowWithText(text: "请选择日期")
            return
        }
        let dates = dateFormatter.string(from: date)
        let str = "\(dates.prefix(10)) \(hourButton!.currentTitle!):\(minuteButton!.currentTitle!)"
        if let compare = dateFormatter.date(from: str), let start = startDate, compare.compare(start) != .orderedDescending {
            HUDShowWithText(text: "结束时间须晚于开始时间")
            return
        }
        if calculationTime {
            //选择结束时间后，需要显示请假时长，由于可能存在法定节假日，需要调用接口获取请假时长
            let beginStr = dateFormatter.string(from: startDate!)
            AFNetWorkingTool.shared.post(urlString: GetWorkTimeSpan, parampeters: ["BeginTime": beginStr, "EndTime": str], success: { [weak self](responseInfo) in
                guard let strongSelf = self else { return }
                strongSelf.HUDHide()
                if responseInfo.error == 0 {
                    if let duration = responseInfo.items as? String {
                        if strongSelf.selectEndDateWithdurationTime != nil{
                            strongSelf.selectEndDateWithdurationTime!(str, duration)
                        }
                    }
                }else {
                    strongSelf.HUDShowWithText(text: responseInfo.msg)
                }
            }) { [weak self] (error) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.HUDHide()
                strongSelf.HUDShowWithText(text: error.localizedDescription)
            }
        }else{
            if selectDate != nil{
                selectDate!(str)
            }
        }
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func lastMonth(_ sender: UIButton) {
        var components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        guard let month = components.month else { return }
        if month > 1 {
            components.month! -= 1
        }else if month == 1 {
            components.month = 12
        }
        if let date = calendar.date(from: components) {
            currentDate = date
            getData()
        }
    }
    
    @objc func lastYear(_ sender: UIButton) {
        var components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        guard let _ = components.year else { return }
        if let leap = components.isLeapMonth, leap {
            if let day = components.day, day == 29 {
                components.day! -= 1
            }
        }
        components.year! -= 1
        if let date = calendar.date(from: components) {
            currentDate = date
            getData()
        }
    }
    
    @objc func nextYear(_ sender: UIButton) {
        var components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        guard let _ = components.year else { return }
        if let leap = components.isLeapMonth, leap {
            if let day = components.day, day == 29 {
                components.day! -= 1
            }
        }
        components.year! += 1
        if let date = calendar.date(from: components) {
            currentDate = date
            getData()
        }
    }
    
    @objc func nextMonth(_ sender: UIButton) {
        var components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        guard let month = components.month else { return }
        if month < 12 {
            components.month! += 1
        }else if month == 12 {
            components.month = 1
        }
        if let date = calendar.date(from: components) {
            currentDate = date
            getData()
        }
    }
    
    @objc func selectHour(_ sender: UIButton) {
        selectTime(isHour: true)
    }
    
    @objc func selectMinute(_ sender: UIButton) {
        selectTime(isHour: false)
    }
    
    func selectTime(isHour: Bool) {
        let vc = HourMinuteVC.init()
        vc.isHour = isHour
        vc.selectTime = {
            [weak self] in
            guard let strongSelf = self else { return }
            var str = $0
            if str.count == 1 {
                str = "0".appending(str)
            }
            if $1 {
                strongSelf.hourButton?.setTitle(str, for: .normal)
            }else {
                strongSelf.minuteButton?.setTitle(str, for: .normal)
            }
        }
        vc.preferredContentSize = CGSize.init(width: 220, height: isHour ? 150 : 360)
        vc.modalPresentationStyle = .popover
        
        let popoverVC = vc.popoverPresentationController
        popoverVC?.permittedArrowDirections = UIPopoverArrowDirection.down
        popoverVC?.sourceView = isHour ? hourButton : minuteButton
        popoverVC?.sourceRect = isHour ? hourButton!.bounds : minuteButton!.bounds
        popoverVC?.popoverLayoutMargins = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        popoverVC?.delegate = self
        
        self.present(vc, animated: true, completion: nil)
    }
    
    //MAKR: - private
    func getData() {
        let secondOneDay: TimeInterval = 3600*24
        var result = [DateComponents]()
        var components = calendar.dateComponents([.year, .month], from: currentDate)
        yearLabel?.text = components.year != nil ? "\(components.year!)" : ""
        if let month = components.month, let str = numberFormatter.string(from: NSNumber.init(value: month)) {
            monthLabel?.text = "\(str)月"
        }
        
        var firstDate: Date = Date.init()
        var interval: TimeInterval = 1
        if calendar.dateInterval(of: .month, start: &firstDate, interval: &interval, for: currentDate) {
            //由于当前月的1号可能并不是星期天，需要加入上个月的末尾几天
            if let weekDay = calendar.ordinality(of: .weekday, in: .weekOfMonth, for: firstDate), weekDay > 0 {
                let minDate = firstDate.advanced(by: -secondOneDay*TimeInterval((weekDay-1)))
                for before in stride(from: minDate, to: firstDate, by: secondOneDay) {
                    result.append(calendar.dateComponents([.day, .month, .year], from: before))
                }
                index.begin = result.count
            }
        }
        
        //加入本月的数据
        if let range = calendar.range(of: .day, in: .month, for: currentDate), let year = components.year, let month = components.month {
            for day in range {
                var com = DateComponents.init()
                com.year = year
                com.month = month
                com.day = day
                result.append(com)
            }
            index.end = result.count-1
            components.day = range.upperBound
            if let finalDate = calendar.date(from: components), let weekDay = calendar.ordinality(of: .weekday, in: .weekOfMonth, for: finalDate), weekDay > 0 {
                //由于取的upperBound，此时finalDate已经是下个月的1号
                let maxDate = finalDate.advanced(by: secondOneDay*TimeInterval((7-weekDay)))
                for after in stride(from: finalDate, through: maxDate, by: secondOneDay) {
                    result.append(calendar.dateComponents([.day, .month, .year], from: after))
                }
                if result.count < 42 {
                    let count = 42 - result.count
                    if let last = result.last {
                        for i in 1...count {
                            var com = DateComponents.init()
                            com.year = last.year
                            com.month = last.month
                            com.day = (last.day ?? 0) + i
                            result.append(com)
                        }
                    }
                }
            }
        }
        dataArray = result
        UIView.transition(with: collectionView, duration: 0.6, options: .transitionCurlUp, animations: {
            self.collectionView.reloadData()
        }, completion: nil)
    }
    
}

@available(iOS 10, *)
extension Date: Strideable {
    public typealias Stride = TimeInterval
    
    public func distance(to other: Date) -> TimeInterval {
        return timeIntervalSince(other)
    }
    
    public func advanced(by n: TimeInterval) -> Date {
        return addingTimeInterval(n)
    }
}

class HourMinuteVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSize.init(width: 35, height: 35)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: preferredContentSize.width, height: preferredContentSize.height), collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib.init(nibName: "SelectTimeCollectionCell", bundle: nil), forCellWithReuseIdentifier: "SelectTimeCollectionCell")
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        return collectionView
    }()
    
    var isHour: Bool = true
    var dataArray: [String]?
    var selectTime:((String, Bool)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.backgroundColor = .orange
        
        let max = isHour ? 23 : 59
        var array = [String]()
        for i in 0...max {
            array.append("\(i)")
        }
        dataArray = array
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isHour ? 24 : 60
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectTimeCollectionCell", for: indexPath) as! SelectTimeCollectionCell
        cell.contentLabel.text = dataArray?[indexPath.item]
        cell.contentLabel.font = UIFont.systemFont(ofSize: 15)
        cell.isTimeCell = true
        if isHour {
            cell.bottomLine.isHidden = indexPath.item > 17
        }else {
            cell.bottomLine.isHidden = indexPath.item > 53
        }
        cell.contentView.backgroundColor = .clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectTime != nil, let str = dataArray?[indexPath.item] {
            selectTime!(str, isHour)
        }
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
