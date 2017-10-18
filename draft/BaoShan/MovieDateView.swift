//
//  MovieDateView.swift
//  CIASMovie
//
//  Created by Albert on 05/06/2017.
//  Copyright © 2017 cias. All rights reserved.
//

import UIKit
import DateEngine_KKZ

class MovieDateView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var collectionView:UICollectionView!
    private var selectedRow = 0
    
    open var dateList: [String] = [] {
        didSet {
            
            displayList = dateList.enumerated().map{
                if $1 != "全部" {
                    let date = DateEngine.shared().date(from: $1, withFormat: "yyyy-MM")
                    let content = DateEngine.shared().string(from: date, withFormat:$1.contains(currentYear) ? "M月" : "yyyy年M月")
                    return content!
                }else {
                    return $1
                }
            }
            collectionView.reloadData()
            
        }
    }
    
    open var selectedCallback: ((Int) -> ())?
    
    private var displayList: [String] = []
    private let cellId = "IncomingDateCollectionViewCell"
    
    private var currentYear:String {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        return String(year)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init(dateList:[String]) {
        self.init(frame: CGRect.zero)
        self.dateList = dateList
    }
    
    func setup() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        collectionView.register(IncomingDateCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayList.count
    }
    
    //MARK: - layout
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: IncomingDateCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! IncomingDateCollectionViewCell
        cell.sizeToFit()
        cell.dateString = displayList[indexPath.row]
        cell.updateLayout()
        cell.isSelect = indexPath.row == selectedRow
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    //MARK: -
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let content = displayList[indexPath.row]
        let size = content.size(attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 13)])
        
        return CGSize(width: size.width + 34, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        collectionView.reloadData()
        selectedCallback?(indexPath.row)
    }
}
