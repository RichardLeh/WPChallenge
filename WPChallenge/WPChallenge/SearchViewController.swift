//
//  SearchViewController.swift
//  WPChallenge
//
//  Created by Richard on 27/12/16.
//  Copyright © 2016 Richard Leh. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AppSegues.showResult.rawValue  {
            if let viewController = segue.destination as? ViewController {
                if let query = sender as? String{
                    viewController.query = query
                }
            }
        }
    }
}


extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.performSegue(withIdentifier: AppSegues.showResult.rawValue, sender: textField.text)
        return true
    }
    
}
