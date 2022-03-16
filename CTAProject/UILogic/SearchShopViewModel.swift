//
//  SearchShopViewModel.swift
//  CTAProject
//
//  Created by 内山和輝 on 2022/02/24.
//

import RxSwift
import RxCocoa
import PKHUD
import SwiftMessages

protocol SearchShopViewModelInput { // ViewからViewModelに流す用のインターフェース
    var searchBarSearchButtonClicked: AnyObserver<Void>{get}
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
    var inputs: SearchShopViewModelInput{get}
    var outputs: SearchShopViewModelOutput{get}
}

class SearchShopViewModel: SearchShopViewModelInput, SearchShopViewModelOutput {
    
    //Input
    @AnyObserverWrapper var searchBarSearchButtonClicked: AnyObserver<Void>
    @AnyObserverWrapper var searchTextInput: AnyObserver<String>
    //Output
    @PublishRelayWrapper var shopData: Observable<[Shop]>
    @PublishRelayWrapper var hudShow: Observable<HUDContentType>
    @PublishRelayWrapper var hudHide: Observable<Void>
    @PublishRelayWrapper var showPopup: Observable<Void>
    @PublishRelayWrapper var showAlert: Observable<Void>
    //property
    private let disposeBag = DisposeBag()
    
    init(hotPepperAPI: HotPepperAPIType) {
        $searchBarSearchButtonClicked
            .withLatestFrom($searchTextInput)
            .withUnretained(self)
            .do(onNext: { me, searchWord in
                if searchWord.count == 0 {
                    me.$showPopup.accept(())
                } else if searchWord.count >= 50 {
                    me.$showAlert.accept(())
                }
            })
            .filter{ 1..<50 ~= $1.count }
            .flatMapLatest { me, text -> Observable<Event<HotPepper>> in
                me.$hudShow.accept(.progress)
                return hotPepperAPI.searchShop(searchWord: text)
                    .timeout(.milliseconds(Int(5000)), scheduler: ConcurrentMainScheduler.instance)
                    .asObservable()
                    .materialize()
            }.observe(on: MainScheduler.instance)
            .subscribe(with: self,
                       onNext: { me, event in
                switch event {
                case .next(let hotpepperResponse):
                    me.$shopData.accept(hotpepperResponse.results.shop)
                    me.$hudHide.accept(())
                    print(hotpepperResponse)
                case .error(let error):
                    me.$hudShow.accept(.error)
                    print(error)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        $hudShow
            .withUnretained(self)
            .filter { $1 == .error }
            .delay(.milliseconds(700), scheduler: ConcurrentMainScheduler.instance)
            .subscribe(onNext: { me, _ in
                me.$hudHide.accept(())
            })
            .disposed(by: disposeBag)
    }
}

extension SearchShopViewModel: SearchShopViewModelType {
    var inputs: SearchShopViewModelInput {return self}
    var outputs: SearchShopViewModelOutput {return self}
}
