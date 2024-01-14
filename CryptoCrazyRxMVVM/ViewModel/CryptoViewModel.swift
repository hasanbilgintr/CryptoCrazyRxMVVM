//
//  CryptoViewModel.swift
//  CryptoCrazyRxMVVM
//
//  Created by hasan bilgin on 19.10.2023.
//

import Foundation
import RxSwift
import RxCocoa

//rxjava androide sadece keşlemiyo burda statik bir data olup viewede aktarmaızı sağlayan veri sağlıyo diyebiliriz. baya işlemi rxWfit ile yapıuyoruz

class CryptoViewModel {
    
    //PublishSubject RxSwiftten gelir
    let cryptos : PublishSubject<[Crypto]> = PublishSubject()
    let error : PublishSubject<String> = PublishSubject()
    let loading : PublishSubject<Bool> = PublishSubject()
    
    func requestData(){
        //loading true yaptık
        self.loading.onNext(true)
        let url = URL(string: "\(Constants.url)/master/crypto.json")!
        Webservice().downloadCurrencies(url: url) { result in
            
            print(url)
            self.loading.onNext(false)
            switch result{
            case .success(let cryptos):
                self.cryptos.onNext(cryptos)
            
            case .failure(let error):
                //detaysız hata mesajı için böle ama biz daha detaylı kullanıya bilgi verebildik
                //self.error.onNext(error)
                switch error {
                case .parsingError:
                    self.error.onNext("Parsing Error")
                case .serverError:
                    self.error.onNext("Server Error")
                }
            }
        }
    }
}
