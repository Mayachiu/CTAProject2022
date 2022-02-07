//
//  SearchShopViewController.swift
//  CTAProject
//
//  Created by 内山和輝 on 2022/01/13.
//

import UIKit

final class SearchShopViewController: UIViewController {

    @IBOutlet private weak var topLabel: UILabel!
    @IBOutlet private weak var tabBar: UITabBar!
    @IBOutlet private weak var listTabBarItem: UITabBarItem!
    @IBOutlet private weak var favoriteTabBarItem: UITabBarItem!
    @IBOutlet private weak var shopTableView: UITableView!
    @IBOutlet private weak var searchShopBar: UISearchBar!
    
    private var shops: [Shop] = []
    private var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.selectedItem = listTabBarItem
        
        shopTableView.register(ShopTableViewCell.nib, forCellReuseIdentifier: ShopTableViewCell.identifier)
        shopTableView.delegate = self
        shopTableView.dataSource = self
        
        displayIndicator()
        // Do any additional setup after loading the view.
    }

    func displayIndicator() {
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        activityIndicator.layer.cornerRadius = activityIndicator.frame.size.width * 0.1
        activityIndicator.backgroundColor = .systemGray5
        activityIndicator.style = .large
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
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
        guard let searchWord = searchShopBar.text else {
            return
        }
        //50文字以上でアラート表示
        if searchWord.count >= 50 {
            let alertView:UIView = AlertView.nib.instantiate(withOwner: self, options: nil)[0] as! UIView
            view.addSubview(alertView)
        } else {
            self.activityIndicator.startAnimating()
            APIClient.getAPI(searchWord: searchWord, completion: { result in
                switch result {
                case .success(let hotpepperResponse):
                    self.shops = hotpepperResponse.results.shop
                    //クロージャの中はバックグラウンドスレッドになるからUIの更新をメインスレッドで行う
                    DispatchQueue.main.async {
                        self.shopTableView.reloadData()
                        self.activityIndicator.stopAnimating()
                    }
                    print(hotpepperResponse)
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
}
