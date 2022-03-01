//
//  SearchShopViewController.swift
//  CTAProject
//
//  Created by 内山和輝 on 2022/01/13.
//

import UIKit
import PKHUD
import SwiftMessages
import RxSwift
import RxCocoa

final class SearchShopViewController: UIViewController {

    @IBOutlet private weak var topLabel: UILabel!
    @IBOutlet private weak var tabBar: UITabBar!
    @IBOutlet private weak var listTabBarItem: UITabBarItem!
    @IBOutlet private weak var favoriteTabBarItem: UITabBarItem!
    @IBOutlet private weak var shopTableView: UITableView!
    @IBOutlet private weak var searchShopBar: UISearchBar!
    
    private var shops: [Shop] = []
    
    private let searchShopViewModel = SearchShopViewModel(hotPepperAPI: APIClient())
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topLabel.text = L10n.topLabelText
        topLabel.textColor = .white
        listTabBarItem.title = L10n.listTabBarItemTitle
        favoriteTabBarItem.title = L10n.favoriteTabBarItemTitle
        
        tabBar.selectedItem = listTabBarItem
        tabBar.tintColor = .systemYellow
        
        shopTableView.register(ShopTableViewCell.nib, forCellReuseIdentifier: ShopTableViewCell.identifier)
        shopTableView.delegate = self
        shopTableView.dataSource = self
        
        searchShopBar.rx.searchButtonClicked
            .withLatestFrom(searchShopBar.rx.text.orEmpty)
            .bind(to: searchShopViewModel.inputs.searchBarSearchButtonClicked)
            .disposed(by: disposeBag)
        
        searchShopViewModel.outputs.shopData
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { me, shopData in
                me.shops = shopData
                me.shopTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        searchShopViewModel.outputs.hudShow
            .subscribe(onNext: { type in
                HUD.show(type)
            })
            .disposed(by: disposeBag)
        
        searchShopViewModel.outputs.hudHide
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                HUD.hide()
            })
            .disposed(by: disposeBag)
        
        searchShopViewModel.outputs.showPopup
            .subscribe(onNext: {
                let popupView = MessageView.viewFromNib(layout: .cardView)
                popupView.configureTheme(.warning)
                popupView.configureContent(title: L10n.noCharactersInput, body: "")
                popupView.button?.isHidden = true
                popupView.backgroundView.backgroundColor = .systemYellow
                var config = SwiftMessages.Config()
                config.presentationStyle = .center
                SwiftMessages.show(config: config, view: popupView)
            })
            .disposed(by: disposeBag)
        
        searchShopViewModel.outputs.showAlert
            .withUnretained(self)
            .subscribe(onNext: { me, _ in
                let alertView = AlertView.nib.instantiate(withOwner: self, options: nil)[0] as! UIView
                me.view.addSubview(alertView)
            })
            .disposed(by: disposeBag)
            
        // Do any additional setup after loading the view.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: TableViewDelegate
extension SearchShopViewController: UITableViewDelegate {
}

// MARK: TableViewDataSource
extension SearchShopViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShopTableViewCell.identifier, for: indexPath) as! ShopTableViewCell
        cell.configureCell(shop: shops[indexPath.row])
        return cell
    }
}

extension SearchShopViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchShopBar.resignFirstResponder()
    }
}
