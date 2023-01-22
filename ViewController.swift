//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Muhammed Ali SOYLU on 15.12.2022.
//

import UIKit
import Foundation


class ViewController: UIViewController {

    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var cadLabel: UILabel!
    @IBOutlet weak var tryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func getRatesClicked(_ sender: Any) {
        
        getRequest()
        getAPI()
        
    }
    
    
    func getAPI(){
        
        let semaphore = DispatchSemaphore (value: 0)
        let url = "https://api.apilayer.com/fixer/convert?to=GBP&from=EUR&amount=5"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue("F7bEpLGz9IIlHj3zodHvvjxwvivNIw6M", forHTTPHeaderField: "apikey")

        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
              }
            print(String(data: data, encoding: .utf8)!)
            semaphore.signal()
        }

        task.resume()
        semaphore.wait()
        
        
    }
    
    
    
    
    
    
    func getRequest(){
        
        //1. Request - Session
        let url = URL(string: "https://raw.githubusercontent.com/atilsamancioglu/CurrencyData/main/currency.json")
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { (data, response, error) in
            if error != nil{
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                //hata yok işlemi yapabilirsin
                //2. Response Data
                if data != nil {
                    do{
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                        
                        //ASYNC
                        DispatchQueue.main.async {
                            //print(jsonResponse)
                            //print(jsonResponse["success")
                            //print(jsonResponse["rates")
                            
                            if let rates = jsonResponse["rates"] as? [String : Any] {
                                
                                if let cad = rates["CAD"] as? Double {
                                    print(cad)
                                    self.cadLabel.text = "CAD \(cad)"
                                    
                                }
                                
                            }

                        }
                        
                        
                        
                        
                        
                    }
                    catch{
                        print("error")
                    }
                }
                
            }
        }
        task.resume()
        
    
        
            
        
        
        
        
        //3. Parsing & JSON Serialization
        
        
        
        
        
    }
    
    
}

