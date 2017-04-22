//
//  TableViewController.swift
//  MyApp
//
//  Created by ernist on 16/04/2017.
//  Copyright © 2017 ernist. All rights reserved.
//
/*
 id     : ID,
 t      : StockSymbol,
 e      : Index,
 l      : LastTradePrice,
 l_cur  : LastTradeWithCurrency,
 ltt    : LastTradeTime,
 lt_dts : LastTradeDateTime,
 lt     : LastTradeDateTimeLong,
 div    : Dividend,
 yld    : Yield,
 s      : LastTradeSize,
 c      : Change,
 cp     : ChangePercent,
 el     : ExtHrsLastTradePrice,
 el_cur : ExtHrsLastTradeWithCurrency,
 elt    : ExtHrsLastTradeDateTimeLong,
 ec     : ExtHrsChange,
 ecp    : ExtHrsChangePercent,
 pcls_fix: PreviousClosePrice
 */
import UIKit
class Stock {
    init(stkId: String, stkSymbol: String, stkLastPrice: String, stkChangePrecent: String, stkColor: UIColor) {
        self.stkId = stkId
        self.stkSymbol = stkSymbol
        self.stkLastPrice = stkLastPrice
        self.stkChangePrecent = stkChangePrecent
        self.stockColor = stkColor
    }
    var stkId: String!
    var stkSymbol: String!
    //let stkIndex: String!
    var stkLastPrice: String!
    //let stkLastCurrency: String!
    //let stkLastTime: String!
    //let stkLastDateTime: String!
   // let stkDivident: String!
  //  let stkYield: String!
  //  let stkLastSize: String!
   // let stkChange: String!
    var stkChangePrecent: String!
    
    
    var stockColor: UIColor!
}

extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
var StockIndex = 0
var Stocks = [Stock]()
var QuotesName = ["AAPL", "YHOO", "SBUX", "NKE", "NDAQ", "KS","TSLA","INTC","AMZN","BIDU","ORCL","MSFT","ORCL","ATVI","NVDA"]//,"GME","LNKD","NFLX"]
class TableViewController: UITableViewController {
    
    var isSetting = true
    @IBOutlet weak var SearchBar: UISearchBar!
    
    @IBAction func deleteRow(_ sender: Any) {
        let btnDelete = sender as! UIButton
        let btnTag = btnDelete.tag
        
        //if Stocks.contains(where: { $0.stockId == String(btnTag)})
        //{
            let index = Stocks.index(where: { $0.stkId == String(btnTag)})
            //let item = Stocks[index!]
            let quote = QuotesName.index(of: Stocks[index!].stkSymbol)
            QuotesName.remove(at: quote!)
            Stocks.remove(at: index!)
            tableView.reloadData()
        //}
    }
    var timer = Timer()
    override func viewDidLoad() {
         timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.requiestData), userInfo: nil, repeats: true)
    
    }
    func requiestData(){
        for quote in QuotesName {
            getQuote(quoteName: quote)
        }
        
    }
    
    @IBAction func btnSettings(_ sender: Any) {
        
        if isSetting == true {
            isSetting = false
            timer.invalidate()
        }
        else
        {
            isSetting = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.requiestData), userInfo: nil, repeats: true)
            
        }
        
        tableView.reloadData()
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Stocks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StockTableViewCell
        let tags = Stocks[indexPath.row].stkId
        cell.btnDelete.tag = Int(tags!)!
        cell.QuoteName.text = Stocks[indexPath.row].stkSymbol
        cell.QuotePrice.text = Stocks[indexPath.row].stkLastPrice
        cell.QuotePrice2.text = Stocks[indexPath.row].stkChangePrecent
        cell.QuotePrice2.backgroundColor = Stocks[indexPath.row].stockColor
        cell.QuotePrice2.highlightedTextColor = Stocks[indexPath.row].stockColor
       /*
        if Stocks[indexPath.row].stockColor == UIColor.red {
            cell.lbIndicate.text = ""//"▼"
            cell.lbIndicate.textColor = UIColor.red
            //cell.QuotePrice2.layer.borderColor = UIColor.red.cgColor
        } else {
            cell.lbIndicate.text = ""//"▲"
            cell.lbIndicate.textColor = UIColor.green
            //cell.QuotePrice2.layer.borderColor = UIColor.green.cgColor
        }
        */
        cell.lbIndicate.text = ""//"▲"
        cell.btnDelete.isHidden = isSetting
        cell.lbIndicate.isHidden = (isSetting != true)
        //cell.QuotePrice2.layer.borderWidth = 1
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // let selectedRow: UITableViewCell = tableView.cellForRow(at: indexPath)!
       // selectedRow.contentView.backgroundColor = UIColor.black
        StockIndex = indexPath.row
        timer.invalidate()
        performSegue(withIdentifier: "segue", sender: self)
    }
   // override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
       // let deselectedRow: UITableViewCell = tableView.cellForRow(at: indexPath)!
        //deselectedRow.contentView.backgroundColor = tableView.backgroundColor
   //r }
    
    func getQuote(quoteName: String){
        var array = [[String:Any]]()
        var qId: String?
        var qSymbol: String?
        var qPrice: String?
        var qPrecent: String?
        var qColor: UIColor?
        let qUp = UIColor.init(rgb: 0x598C61)//UIColor(red: 112, green: 175, blue: 123, alpha: 100)
        let qDown = UIColor.init(rgb: 0xE95748)//UIColor(red: 211, green: 80, blue: 77, alpha: 100)
        let wUrl = "https://www.google.com/finance/info?q=" + quoteName
        let Url = NSURL(string: wUrl)
        let request = NSMutableURLRequest(url: Url! as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
            guard error == nil && data != nil else
            {
                print("Error:", error ?? "some error")
                return
            }
            print("REQUEST:\(request)")
            let httpStatus = response as? HTTPURLResponse
         
            if httpStatus!.statusCode == 200 {
                if ((data?.count)! != 0) && ((data?.count)! < 500) {
                    let text: String = String(data: data!, encoding: String.Encoding(rawValue: 4))!
                    let result = text.substring(from: text.characters.index(text.startIndex, offsetBy: 3))
                    let trimmedData = result.data(using: String.Encoding(rawValue: 4), allowLossyConversion: false)
                    print(text)
                    do {
                        array = try JSONSerialization.jsonObject(with: trimmedData!, options: []) as! [[String: Any]]
                        
                        for dic in array{
                            if let id = dic["id"] as? String{
                                qId = (id as AnyObject) as? String
                            }
                            if let name = dic["t"] as? String{
                                qSymbol = (name as AnyObject) as? String
                            }
                            if let price = dic["l"] as? String{
                                qPrice = (price as AnyObject) as? String
                            }
                            if let updown = dic["cp"] as? String
                            {
                                qPrecent = (updown as AnyObject) as? String
                            }
                            if (qPrecent?.contains("-"))! {
                                qColor = qDown
                            }
                            else
                            {
                                qColor =  qUp                           }
                            if Stocks.contains(where: { $0.stkSymbol == qSymbol})
                            {
                                if let index = Stocks.index(where: { $0.stkSymbol == qSymbol}){
                                    Stocks[index] = Stock(stkId: qId! , stkSymbol: qSymbol!, stkLastPrice: qPrice!, stkChangePrecent: qPrecent! + "%", stkColor: qColor!)
                                }
                                
                            }
                            else{
                                Stocks.append(Stock(stkId: qId! , stkSymbol: qSymbol!, stkLastPrice: qPrice!, stkChangePrecent: qPrecent! + "%", stkColor: qColor!))}
                            Stocks = Stocks.sorted(by: { $0.stkId > $1.stkId })
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                    } catch {
                        print(data ?? "default")
                        
                    }
                }
                else
                {
                    print("Data is emty")
                }
            }
            else {
                print("error httpStatus code: ", httpStatus?.statusCode ?? "")
            }
        };task.resume()
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
