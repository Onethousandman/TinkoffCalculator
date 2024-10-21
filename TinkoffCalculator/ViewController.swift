//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Никита Тыщенко on 09.10.2024.
//

import UIKit

enum CalculationError: Error {
    case divisionByZero
}

enum Operation: String {
    case add = "+"
    case substract = "-"
    case multiply = "x"
    case divide = "/"
    
    func calculate(_ number1: Double, _ number2: Double) throws -> Double {
        switch self {
        case .add: return number1 + number2
        case .substract: return number1 - number2
        case .multiply: return number1 * number2
        case .divide:
            if number2 == 0 {
                throw CalculationError.divisionByZero
            }
            return number1 / number2
        }
    }
}

enum CalculationHistoryItem {
    case number(Double)
    case operation(Operation)
}

final class ViewController: UIViewController {
    
    @IBOutlet var resultLabel: UILabel!
    
    lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "ru_RU")
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
    
    var calculationHistory: [CalculationHistoryItem] = []
    
    @IBAction func ButtonPressed(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle else { return }
        
        if buttonText == "," && resultLabel.text?.contains(",") == true { return }
        
        if resultLabel.text == "0" {
            resultLabel.text = buttonText
        } else {
            resultLabel.text?.append(buttonText)
        }
    }
    
    @IBAction func operationButtonPressed(_ sender: UIButton) {
        guard
            let buttonText = sender.currentTitle,
            let buttonOparation = Operation(rawValue: buttonText)
            else { return }
        
        guard
            let resultLabel = resultLabel.text,
            let resultLabelNumber = numberFormatter.number(from: resultLabel)?.doubleValue
            else { return }
        
        calculationHistory.append(.number(resultLabelNumber))
        calculationHistory.append(.operation(buttonOparation))
        
        resetResultLabelText()
    }
    
    @IBAction func clearButtonPressed() {
        calculationHistory.removeAll()
        resetResultLabelText()
    }
    
    @IBAction func calculateButtonPressed() {
        guard
            let resultLabelText = resultLabel.text,
            let resultLabelNumber = numberFormatter.number(from: resultLabelText)?.doubleValue
        else { return }
        
        calculationHistory.append(.number(resultLabelNumber))
        
        do {
            let result = try calculate()
            resultLabel.text = numberFormatter.string(from: NSNumber(value: result))
        } catch {
            resultLabel.text = "Ошибка"
        }
        
        calculationHistory.removeAll()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        resetResultLabelText()
    }
    
    func calculate() throws -> Double {
        guard case .number(let firstNumber) = calculationHistory[0] else { return 0 }
        
        var currentResult = firstNumber
        
        for index in stride(from: 1, to: calculationHistory.count - 1, by: 2) {
            guard
                case .operation(let operation) = calculationHistory[index],
                case .number(let number) = calculationHistory[index + 1]
            else { break }
            
            currentResult = try operation.calculate(currentResult, number)
        }
        
        return currentResult
    }
    
    func resetResultLabelText() {
        resultLabel.text = "0"
    }
}

