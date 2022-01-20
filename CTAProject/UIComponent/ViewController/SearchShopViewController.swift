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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.selectedItem = listTabBarItem
        
        //サンプル用のキーワード"寿司"
        APIClient.getAPI(searchWord: "寿司", completion: { result in
            switch result {
            case .success(let hotpepperResponse):
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
