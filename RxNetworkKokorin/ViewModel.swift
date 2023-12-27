//
//  ViewModel.swift
//  RxNetworkKokorin
//
//  Created by Yevhen Lukhtan on 20.12.2023.
//

import Foundation
import RxSwift
import RxCocoa

struct ViewModel {
    
    let searchText = BehaviorRelay(value: "")
    //let disposebag = DisposeBag()
    
    let APIManager: APIManager
    var data: Driver<[Repos]>
    
    init(APIManager: APIManager) {
        self.APIManager = APIManager
        
        data = self.searchText.asObservable()
            .throttle(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest({
                APIManager.getRepositories($0)
            })
            .asDriver(onErrorJustReturn: [])
    }
}
