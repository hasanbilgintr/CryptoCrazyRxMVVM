/*
 Mvvm
 Model-View-ViewModel
 (
 RxSwift
 Apple çıkardığı combayn
 Hiç kütüphanesiz delegat pattern ilede olur
 )
 
 
 -json beautifier datayı daha net görebiliriz
 
 -RxSwift yüklemek için  SPM den https://github.com/ReactiveX/RxSwift dan olan projeye dikkat edelim, tümünü yükledik RxSwift , RxCocoa Build Phasesten 2 sini bırakmak yeterli burda sadece kullanıma açık yada kapalı yapabiliyoruz. package tamamenen silmek için add package dependencies te sağ tıklayıp remove package demek laazım
 
 
 -Activity indicator View demek bir işlem indirilme açılma gibi işlemleri yaparken bekletme itemi diyebiliriz.İtemi koyarken hiyerarşi tarafındna başkasının içine koyarsak üste koyarak değiştirebiliriz. Hides When Stopped demek durduğunda gizle demek. Açılır açılmaz döndürmek istersek Animating tıklayabiliriz. Bide View en altında olursa en üstte görünecektir storyboard kısmında bilginiz olsun
 */

import UIKit
import RxSwift
import RxCocoa

//  //tableview bindik için kapandı UITableViewDataSource
class ViewController: UIViewController ,UITableViewDelegate/*, UITableViewDataSource*/{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var cryptoList = [Crypto]()
    let crytoVM = CryptoViewModel()
    //    hafızayı gerektiğinde  için kullanıyoruz // çöp çatnası anlamına gelir
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("ViewController viewDidLoad")
        
        //tableview bindik için kapandı
//        tableView.dataSource = self
//        tableView.dataSource = self
        
        //işimizi rxe delege etmiş oluyoruz
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        //getData()
        getDataWithViewModel()
        
        //viewi tamamen siyah yaptık table view hariç
        view.backgroundColor = .black
        //tableview satır arka plan için yani CryptoCell backgrpound siyah yaparsak satırlar siyah olucaktır
        //labllerin renklerini değiştireibliriz
        //tableview seçip seperator (çizgi) verilebilri renkte verilebilir
    
    }
    
    func getData(){
        //metine data ekleme diyebiliriz //"\(Constants.url)/master/crypto.json""
        let url = URL(string: "\(Constants.url)/master/crypto.json")!
        Webservice().downloadCurrencies(url: url) { result in
            switch result{
            case .success(let cryptos):
                print(Constants.url)
                //print(cryptos)
                self.cryptoList = cryptos
                //istek arka planda çalıştığı için burası öle tableViewde kullanıcı trhreadine geçtik yani maine ondna doalyı
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func getDataWithViewModel(){
        //yapılabilir bir sorun yok ama biz bool sonucuna göre manuel işlem yapıcaz biz direk o manuel işlemi loadinge bağlıcaz ondna dolayı binding kullanıcaz
        //diğerlerindede kullanabilirdik
        //loadingte observe(on: MainScheduler.asyncInstance) yazılabilir ama kullanılmadığı iletti
//        crytoVM.loading.subscribe { bool in
//            if bool {
//                self.indicatorView.startAnimating()
//            }else{
//                self.indicatorView.stopAnimating()
//            }
//        }
        crytoVM.loading.bind(to: self.indicatorView.rx.isAnimating).disposed(by: disposeBag)
        
        
        //observe RxSwiftten gelir ve threadlerin yapılcağı yeri söleriz
        //MainScheduler.asyncInstance ta  asyncInstance demek  DispatchQueue.main.async { ile girmeden halletmektir diyebiliriz
        //subscribe on next metodu kullandık ellede yazılabilirs
        crytoVM.error.observe(on: MainScheduler.asyncInstance).subscribe { errorString in
            print(errorString)
        }.disposed(by: disposeBag)
        
        //tableViewide bindign yaptık
        /*
        crytoVM.cryptos.observe(on: MainScheduler.asyncInstance).subscribe { cryptos in
            self.cryptoList = cryptos
            self.tableView.reloadData()
        }.disposed(by: disposeBag)
        */
        //table view i binding ile kullanabilmek için tableview cell atamamız lazım sınfıta aynı şekilde....
        crytoVM.cryptos.observe(on: MainScheduler.asyncInstance)
            .bind(to: tableView.rx.items(cellIdentifier: "CryptoCell", cellType: CryptoTableViewCell.self)){row,item,cell in
                //CryptoTableViewCell sınıfındaki itemi aldık cell.item dekine eşitlemiş olduk
                cell.item = item
            }.disposed(by: disposeBag)
        
        
        crytoVM.requestData()
        
    }
    
    //tableview binding için bunları kapadık bunların yönetimini rxe bırakıcaz
    /*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = cryptoList[indexPath.row].currency
        content.secondaryText = cryptoList[indexPath.row].price
        cell.contentConfiguration = content
        return cell
    }
    */
    
    //cell sotryboardda zorlanırsak heigh direk sayı ataması yapabiliriz
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}


