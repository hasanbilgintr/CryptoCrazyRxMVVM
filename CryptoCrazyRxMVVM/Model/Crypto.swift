//
//  Crypto.swift
//  CryptoCrazyRxMVVM
//
//  Created by hasan bilgin on 19.10.2023.
//

import Foundation

//apple struct kullanmmamızı ister inherit alınmadığı sürece diyebiliriz
//Codable = Decodable + Encodable
//Decodable eğer json olarak gelecek olan veriyi kendi okuyabilceğim şekilde çevirmek istiyorsam kullanabiliriz
//Encodable eğer json olarak gidecek olan veriyi çevirdikten sonra göndermek istiyorsak bunada denir
struct Crypto : Decodable{
    //datda veriler String olduğu için
    let currency : String
    let price : String
    
    //quicktype.io gibi json modeli oluşturur otomatik kotlin swift hertürlü çıkışları mevcut
    
    
    
}
