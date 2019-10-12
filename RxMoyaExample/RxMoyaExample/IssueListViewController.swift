//
//  IssueListViewController.swift
//  RxMoyaExample
//
//  Created by QDSG on 2019/10/12.
//  Copyright © 2019 unitTao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya_ModelMapper
import Moya

class IssueListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let reuseIdentifier = "resultCellId"
    
    private let disposeBag = DisposeBag()
    
    private var provider = MoyaProvider<GitHub>()
    
    private var latestRepositoryName: Observable<String> {
        return
            searchBar
                .rx
                .text
                .orEmpty
                .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
                .distinctUntilChanged()
    }
}

extension IssueListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
    }
}

// MARK: - Rx Setup
private extension IssueListViewController {
    func setupRx() {
        tableView
            .rx
            .itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                if self.searchBar.isFirstResponder {
                    self.view.endEditing(true)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Rx Moya
private extension IssueListViewController {
    
}
