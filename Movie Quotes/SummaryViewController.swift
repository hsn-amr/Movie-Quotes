//
//  SummaryViewController.swift
//  Movie Quotes
//
//  Created by administrator on 23/12/2021.
//

import UIKit

class SummaryViewController: UIViewController {

    @IBOutlet weak var summaryLabel: UILabel!
    var summary = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let html = summary
        summaryLabel.text = fromHtmlToString(html: html)
        
    }
    
    func fromHtmlToString(html: String) -> String{
        var text = ""
        if let htmlData = html.data(using: String.Encoding.unicode){
            do{
                text = try NSAttributedString(data: htmlData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil).string
            }catch {
                print("HTML Error \(error.localizedDescription)")
            }
        }
        return text
    }

    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
