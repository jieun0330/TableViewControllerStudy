//
//  TravelCity3ViewController.swift
//  SeSAC_HW_TableViewController
//
//  Created by 박지은 on 1/9/24.
//

import UIKit
import Kingfisher

enum segmentCase: String, CaseIterable {
    case all = "모두"
    case domestic = "국내"
    case overseas = "해외"
    
    var index: Int {
        switch self {
        case .all:
            return 0
        case .domestic:
            return 1
        case .overseas:
            return 2
        }
    }
}

// 열거형 타입을 갖고있는 프로퍼티
var userSelect: segmentCase = .all


class TravelCity3ViewController: UIViewController {
    
    @IBOutlet var cityView: UICollectionView!
    @IBOutlet var citySearchBar: UISearchBar!
    @IBOutlet var domesticSegment: UISegmentedControl!
    
    var list: [City] = CityInfo.city {
        didSet {
            cityView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSegmentControl()
        configureView()
        setLayout()
        
        
        
    }
    
    @IBAction func changeSegmentValue(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == segmentCase.domestic.index {
            let domestic = CityInfo.city.filter( { $0.domestic_travel })
            list = domestic
        }
        else if sender.selectedSegmentIndex == segmentCase.overseas.index {
            let abroad = CityInfo.city.filter( { !$0.domestic_travel })
            list = abroad
        } else {
            list = CityInfo.city
        }
    }
}

extension TravelCity3ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var filterData: [City] = []
        
        if searchBar.text == "" {
            list = CityInfo.city
        } else {
            for item in CityInfo.city {
                if item.city_name.contains(searchBar.text!) || item.city_explain.contains(searchBar.text!) || item.city_english_name.lowercased().contains(searchBar.text!) {
                    filterData.append(item)
                }
            }
            list = filterData
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        list = CityInfo.city
    }
}

extension TravelCity3ViewController {
    
    func setupSegmentControl() {
        // 기본 세팅되어있는 세그먼트 값을 지워준다는걸까 -> 그런듯 아무것도 안보임
        domesticSegment.removeAllSegments()
        // 미리 선언해둔 Enum에 접근.모든케이스.enumerated()는 모든 인덱스를 리턴해준다
        // 인덱스에 접근하여 세그먼트에 문자열을 insert해준다
        segmentCase.allCases.enumerated().forEach{ (index, section) in domesticSegment.insertSegment(withTitle: section.rawValue, at: index, animated: false)}
        // 초기 시작 상태를 0번째 인덱스로 두고 시작한다
        domesticSegment.selectedSegmentIndex = 0
    }
    
    func configureView() {
        cityView.delegate = self
        cityView.dataSource = self
        
        citySearchBar.delegate = self
        citySearchBar.showsCancelButton = true
        
        let xib = UINib(nibName: TravelCity3CollectionViewCell.identifier, bundle: nil)
        cityView.register(xib, forCellWithReuseIdentifier: TravelCity3CollectionViewCell.identifier)
    }
    
    func setLayout() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 24
        let cellWidth = UIScreen.main.bounds.width - (spacing * 3)
        
        layout.itemSize = CGSize(width: cellWidth / 2.5, height: cellWidth / 1.7)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        cityView.collectionViewLayout = layout
    }
    
}

extension TravelCity3ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TravelCity3CollectionViewCell.identifier, for: indexPath) as! TravelCity3CollectionViewCell
        
        cell.imageView.kf.setImage(with: URL(string: list[indexPath.row].city_image))
        cell.titleLabel.text = "\(list[indexPath.row].city_name) | \(list[indexPath.row].city_english_name)"
        cell.cityLabel.text = list[indexPath.row].city_explain
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailSB = UIStoryboard(name: "Detail", bundle: nil)
        let detailVC = detailSB.instantiateViewController(identifier: TravelDetailViewController.identifier) as! TravelDetailViewController
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
