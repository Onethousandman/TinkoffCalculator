//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Никита Тыщенко on 09.10.2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func ButtonPressed(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle else { return }
        print(buttonText)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

