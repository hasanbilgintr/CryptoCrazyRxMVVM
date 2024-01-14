//
//  Webservice.swift
//  CryptoCrazyRxMVVM
//
//  Created by hasan bilgin on 19.10.2023.
//

import Foundation

//hata verdiğinde enum oluşturuduk
enum CryptoError : Error {
    case serverError
    case parsingError
}

class Webservice {
    //url parametre alıcak istek çalıştıırldığında Crypto modelindeki sonuç döndürücek anlamaında
    //func downloadCurrencies(url: URL, completion : @escaping (Crypto) -> () ){ //ve çağırırkende böle olur
    /*
     Webservice().downloadCurrencies(url: URL(string: "www.hasanbilgin.web.tr.......")!) { crypto in
        //
     }
     */
    //Result<[Crypto],NSError> // burda başarılı olduğunda [Crypto] vericek hatalı olduğunda NSError vericek anlamaındadır
    func downloadCurrencies(url: URL, completion : @escaping (Result<[Crypto],CryptoError>) -> () ){
        
        //escaping iş bittikten sonra çalıştırılcak
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                //hata olduğunda serverError değeri neyse onu alıcaktır
                //Result.failure ile .failure aynıdır zaten bunlar enum oluğu için  böle
                //CryptoError.serverError aynı şekilde .serverError kullandık
                completion(.failure(.serverError))
            } else if let data = data {
              //try? olursa [cryptoList]? optinal çıkar
                //try! ise hata olursa uygulama çöker catch olmadığı sürece
                //cryptoList döndürceğimiz için orda @escaping (Result<[Crypto]?,CryptoError>) -> () ){  ? konulabilir ama gerek yok if let ile hallederiz
                let cryptoList = try? JSONDecoder().decode([Crypto].self, from: data)
                
                if let cryptoList = cryptoList {
                    completion(.success(cryptoList))
                }else{
                    completion(.failure(.parsingError))
                }
              
            }
            //isteği başlatıcaktır
        }.resume()
    }
}
