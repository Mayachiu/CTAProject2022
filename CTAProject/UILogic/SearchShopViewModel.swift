//
//  SearchShopViewModel.swift
//  CTAProject
//
//  Created by 内山和輝 on 2022/02/24.
//

//import Foundation
import RxSwift
import RxCocoa
import PKHUD
import SwiftMessages

protocol SearchShopViewModelInput { // ViewからViewModelに流す用のインターフェース
    var searchBarSearchButtonClicked: AnyObserver<String>{get}
    var searchTextInput: AnyObserver<String>{get}
}

protocol SearchShopViewModelOutput { // Viewへ値を流す用のインターフェース
    var shopData: Observable<[Shop]>{get}
    var hudShow: Observable<HUDContentType>{get}
    var hudHide: Observable<Void>{get}
    var showPopup: Observable<Void>{get}
    var showAlert: Observable<Void>{get}
}

protocol SearchShopViewModelType { //外部で型として使う部分。inputs、outputsとアクセスをわけ、入力と出力を明確にする
    var inputs: SearchShopViewModelInput {get}
    var outputs: SearchShopViewModelOutput {get}
}

class SearchShopViewModel: SearchShopViewModelInput, SearchShopViewModelOutput {
    
    //Input
    @AnyObserverWrapper var searchBarSearchButtonClicked: AnyObserver<String>
    @AnyObserverWrapper var searchTextInput: AnyObserver<String>
    //Output
    @PublishRelayWrapper var shopData: Observable<[Shop]>
    @PublishRelayWrapper var hudShow: Observable<HUDContentType>
    @PublishRelayWrapper var hudHide: Observable<Void>
    @PublishRelayWrapper var showPopup: Observable<Void>
    @PublishRelayWrapper var showAlert: Observable<Void>
    //property
    private let disposeBag = DisposeBag()
    
    init() {
        $searchBarSearchButtonClicked
            .filter{1..<50 ~= $0.count}
            .withUnretained(self)
            .subscribe(onNext: { me, searchWord in
                me.$hudShow.accept(.progress)
                APIClient.searchShop(searchWord: searchWord, completion: { result in
                    switch result {
                    case .success(let hotpepperResponse):
                        me.$shopData.accept(hotpepperResponse.results.shop)
                        me.$hudHide.accept(())
                        print(hotpepperResponse)
                    case .failure(let error):
                        print(error)
                        me.$hudShow.accept(.progress)
                    }
                })
            })
            .disposed(by: disposeBag)
        
        $hudShow
            .withUnretained(self)
            .delay(.seconds(4), scheduler: MainScheduler.instance)
            .subscribe(onNext: { me, hudContentType in
                if case .error = hudContentType {
                    me.$hudHide.accept(())
                }
            })
            .disposed(by: disposeBag)
        
        $searchBarSearchButtonClicked
            .withUnretained(self)
            .subscribe(onNext: { me, text in
                print(text)
                if text.count == 0 {
                    me.$showPopup.accept(())
                } else if text.count >= 50 {
                    me.$showAlert.accept(())
                }
            })
            .disposed(by: disposeBag)
    }
}

extension SearchShopViewModel: SearchShopViewModelType {
    var inputs: SearchShopViewModelInput {return self}
    var outputs: SearchShopViewModelOutput {return self}
}
