//
//  ViewController.swift
//  Project 9 Challenge2
//
//  Created by Harsh Verma on 12/08/21.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK:- Variables
    var clueLabel: UILabel!
    var answerLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButton = [UIButton]()
    var active = [UIButton]()
    var solution = [String]()
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    var maxLevel = 2
    //MARK:- ViewController methods
    
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .green
        
        // Score Label
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        // Clue label
        clueLabel = UILabel()
        clueLabel.translatesAutoresizingMaskIntoConstraints = false
        clueLabel.font = UIFont.systemFont(ofSize: 28)
        clueLabel.text = "Clues"
        clueLabel.numberOfLines = 0
        clueLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(clueLabel)
        
        //Answer Label
        answerLabel = UILabel()
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.font = UIFont.systemFont(ofSize: 28)
        answerLabel.text = "ANSWERS"
        answerLabel.textAlignment = .right
        answerLabel.numberOfLines = 0
        answerLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answerLabel)
        
        // Current Answer
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap To Guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        // Clear Button
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("Submit", for: .normal)
        submit.addTarget(self, action: #selector(didPressSubmit), for: .touchUpInside)
        view.addSubview(submit)
        
    
        
        // Submit Button
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("Clear", for: .normal)
        clear.addTarget(self, action: #selector(didPressClear), for: .touchUpInside)
        view.addSubview(clear)
        
        
        // Adding Layer around Buttons
        
        let bView = UIView()
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.layer.borderWidth = 0.5
        bView.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(bView)
        
        // Constraints Setup Here
        NSLayoutConstraint.activate([
                                        scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
                                        scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
                                     
                                     clueLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
                                     clueLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
                                     clueLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
                                     
                                     answerLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
                                     answerLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
                                     answerLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
                                     answerLabel.heightAnchor.constraint(equalTo: clueLabel.heightAnchor),
                                     
                                     currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
                                     currentAnswer.topAnchor.constraint(equalTo: clueLabel.bottomAnchor, constant: 20),
                                     
                                     submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
                                     submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
                                     submit.heightAnchor.constraint(equalToConstant: 44),
                                     
                                     clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
                                     clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
                                     clear.heightAnchor.constraint(equalToConstant: 44),
                                     
                                     bView.widthAnchor.constraint(equalToConstant: 750),
                                     bView.heightAnchor.constraint(equalToConstant: 320),
                                     bView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     bView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
                                     bView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)])
        
        let width = 150
        let height = 50
        
        
        for rows in 0..<4 {
            for columns in 0..<5 {
                let letterB = UIButton(type: .system)
                letterB.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterB.setTitle("www", for: .normal)
                letterB.addTarget(self, action: #selector(didPressLeterTapped), for: .touchUpInside)
                
                let frame = CGRect(x: columns * width, y: rows*height, width: width, height: height)
                letterB.frame = frame
                bView.addSubview(letterB)
                letterButton.append(letterB)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.loadLevels()
        }
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- Objc Functions Here
    
    @objc func didPressClear(_ sender: UIButton) {
        currentAnswer.text = ""
        for buttons in letterButton {
            buttons.isHidden = false
        }
        active.removeAll()
    }
    
    @objc func didPressSubmit(_ sender: UIButton) {
        guard let aText = currentAnswer.text else {
            return
        }
        if aText.isEmpty {
            return
        }
        if let position = solution.firstIndex(of: aText) {
            active.removeAll()
            
            var splitted = answerLabel.text?.components(separatedBy: "\n")
            splitted?[position] = aText
            answerLabel.text = splitted?.joined(separator: "\n")
            currentAnswer.text = ""
            score += 1
            
            if isAllButton() {
                let alert = UIAlertController(title: "Well Done!", message: "Proceed to Next Level?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dive in!!!", style: .default, handler: jumpLevel))
                present(alert, animated: true, completion: nil)
                
            }
        }else {
            let alert = UIAlertController(title: "Woops!", message: "\"\(aText)\"does notmatch one of the Answer", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            score -= 1
        }
    }
    
    @objc func didPressLeterTapped(_ sender: UIButton) {
        guard let bTitle = sender.titleLabel?.text else {
            return
        }
        currentAnswer.text = currentAnswer.text?.appending(bTitle)
        active.append(sender)
        sender.isHidden = true
    }
    
    
    @objc func loadLevels() {
        var clueString = ""
        var solutionStr = ""
        var bits = [String]()
        
        
        if let filePath = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let contents = try? String(contentsOf: filePath) {
                var line = contents.components(separatedBy: "\n")
                line.shuffle()
                
                
                for(index, line) in line.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWd = answer.replacingOccurrences(of: "|", with: "")
                    solutionStr += "\(solutionWd.count) letters\n"
                    solution.append(solutionWd)
                    
                    let bitss = answer.components(separatedBy: "|")
                    bits += bitss
                    
                }
            }
        }
        letterButton.shuffle()
        
        // Challenge
        
        DispatchQueue.main.async { [weak self] in
            self?.clueLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
            self?.answerLabel.text = solutionStr.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if let buttons = self?.letterButton {
                if buttons.count == bits.count {
                    for i in 0..<buttons.count {
                        buttons[i].setTitle(bits[i], for: .normal)
                    }
                }
            }
        }
        
    }
    
    
    //MARK:- User Functions
    
    func isAllButton() -> Bool {
        for buttons in letterButton {
            if buttons.isHidden == false {
                return false
            }
        }
        return true
    }
    
    func jumpLevel(title: UIAlertAction) {
        if level >= maxLevel {
            level = 1
        }else {
            level += 1
        }
        solution.removeAll(keepingCapacity: true)
        
        //Challenge
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.loadLevels()
        }
        
        for activated in active {
            activated.isHidden = false
        }
    }
    
}

