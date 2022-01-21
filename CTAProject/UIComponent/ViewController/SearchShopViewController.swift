//
//  SearchShopViewController.swift
//  CTAProject
//
//  Created by 内山和輝 on 2022/01/13.
//

import UIKit

final class SearchShopViewController: UIViewController {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var listTabBarItem: UITabBarItem!
    @IBOutlet weak var favoriteTabBarItem: UITabBarItem!
    @IBOutlet weak var shopTableView: UITableView!
    var shop:[Shop] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.selectedItem = listTabBarItem
        
        shopTableView.register(UINib(nibName: "ShopTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        shopTableView.delegate = self
        shopTableView.dataSource = self
        
        //サンプル用のキーワード"寿司"
        APIClient.getAPI(searchWord: "寿司", completion: { result in
            switch result {
            case .success(let hotpepperResponse):
                self.shop = hotpepperResponse.results.shop
                //クロージャの中はバックグラウンドスレッドになるからUIの更新をメインスレッドで行う
                DispatchQueue.main.async {
                    self.shopTableView.reloadData()
                }
                print(hotpepperResponse)
            case .failure(let error):
                print(error)
            }
        })
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
        return shop.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ShopTableViewCell
        cell.configureCell(shop: shop[indexPath.row])
        return cell
    }
}
