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
        
        searchShopBar.rx.searchButtonClicked
            .bind(to: searchShopViewModel.inputs.searchBarSearchButtonClicked)
            .disposed(by: disposeBag)
        
        searchShopBar.rx.text.orEmpty
            .bind(to: searchShopViewModel.inputs.searchTextInput)
            .disposed(by: disposeBag)
        
        searchShopViewModel.outputs.shopData
            .bind(to: shopTableView.rx.items(cellIdentifier: ShopTableViewCell.identifier, cellType: ShopTableViewCell.self)) {
                _, shop, cell in
                cell.configureCell(shop: shop)
            }
            .disposed(by: disposeBag)
        
        searchShopViewModel.outputs.hudShow
            .subscribe(onNext: { type in
                HUD.show(type)
            })
            .disposed(by: disposeBag)
        
        searchShopViewModel.outputs.hudHide
            .subscribe(onNext: { _ in
                HUD.hide()
            })
            .disposed(by: disposeBag)
        
        searchShopViewModel.outputs.showPopup
            .subscribe(onNext: { _ in
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

extension SearchShopViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchShopBar.resignFirstResponder()
    }
}
