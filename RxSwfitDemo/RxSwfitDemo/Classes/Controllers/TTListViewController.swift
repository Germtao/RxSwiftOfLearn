//
//  TTListViewController.swift
//  RxSwfitDemo
//
//  Created by QDSG on 2019/10/10.
//  Copyright © 2019 unitTao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TTListViewController: UIViewController {
    
    @IBOutlet weak var cardItem: UIBarButtonItem!
    @IBOutlet weak var listView: UITableView!
    
    let europeanCommodities = Observable.just(Commodity.ofEurope)
    
    private let disposeBag = DisposeBag()
}

extension TTListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "商品列表"
        
        setupCartObserver()
        setupCellConfiguration()
        setupCellTapHandling()
    }
}

// MARK: - Rx Setup
extension TTListViewController {
    func setupCartObserver() {
        // 1.
        TTShoppingCart.shared.commodities.asObservable()
            .subscribe(onNext: { // 2.
                [unowned self] commondites in
                self.cardItem.title = "\(commondites.count)🍫"
            }) // 3.
            .disposed(by: disposeBag)
    }
    
    func setupCellConfiguration() {
        // 1.
        europeanCommodities
            .bind(to: listView
                .rx // 2.
                .items(cellIdentifier: TTListViewCell.reuseIdentifier,
                       cellType: TTListViewCell.self)) { // 3.
                        (row, commodity, cell) in
                cell.configure(with: commodity) // 4.
        }
        .disposed(by: disposeBag) // 5.
    }
    
    func setupCellTapHandling() {
        listView
            .rx
            .modelSelected(Commodity.self) // 1.
            .subscribe(onNext: { [unowned self] (commodity) in // 2.
                let newValue = TTShoppingCart.shared.commodities.value + [commodity]
                TTShoppingCart.shared.commodities.accept(newValue) // 3.
                
                if let selectedRowIndexpath = self.listView.indexPathForSelectedRow {
                    self.listView.deselectRow(at: selectedRowIndexpath, animated: true)
                } // 4.
            })
            .disposed(by: disposeBag) // 5.
    }
}
