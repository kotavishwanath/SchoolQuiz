//
//  ViewController.swift
//  SchoolQuiz
//
//  Created by Vishwanath Kota on 22/07/2020.
//  Copyright © 2020 VBCLimited. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var answerButtons: [UIButton]!
    var questions = [Question]()
    var quesNumber = 0
    var answers = [Int]()
    var mutiAnsSelection = [Int]()
    let sleepTime = 0.5
    
    var correctAnswers = 0
    
    var hours = 0 {
        didSet {
            hoursLbl.text = String(format: "%02d", hours)
        }
    }
    var minutes = 0 {
        didSet {
            minsLbl.text = String(format: "%02d", minutes)
        }
    }
    var seconds = 0 {
        didSet {
            secsLbl.text = String(format: "%02d", seconds)
        }
    }
    
    var timerIsPaused: Bool = true
    var timer: Timer? = nil
    
    var results = ResultsPopUp()
    var initialQuestionsCount = 0
    
    @IBOutlet weak var hoursLbl: UILabel!
    @IBOutlet weak var minsLbl: UILabel!
    @IBOutlet weak var secsLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        updateOptionsUI()
        startTimer()
        
        questions.append(Question(ques: "Question 1", options: ["results.subTitleLabel.text = correctAnswers initialQuestionsCount results.subTitleLabel.text = correctAnswers) out of initialQuestionsCount results.subTitleLabel.text = correctAnswers results.subTitleLabel.text = correctAnswers results.subTitleLabel.text = correctAnswers", "2", "3", "4"], answers: [0,1]))
        questions.append(Question(ques: "Question 2", options: ["5", "6", "7", "8"], answers: [2,3]))
        questions.append(Question(ques: "Question 3", options: ["9", "10", "11", "12"], answers: [1,2]))
        questions.append(Question(ques: "Question 4", options: ["13", "14", "15", "16"], answers: [0,3]))
        
        initialQuestionsCount = questions.count
        pickQuestion()
    }
    
    func updateOptionsUI() {
        for i in 0..<answerButtons.count {
            answerButtons[i].titleLabel?.numberOfLines = 0
            answerButtons[i].titleLabel?.adjustsFontSizeToFitWidth = true
            answerButtons[i].titleLabel?.lineBreakMode = .byCharWrapping
            answerButtons[i].layer.borderColor = UIColor.black.cgColor
            answerButtons[i].layer.borderWidth = 1.0
            answerButtons[i].layer.cornerRadius = 4.0
            answerButtons[i].layer.backgroundColor = UIColor.white.cgColor
        }
    }
    
    func pickQuestion() {
        mutiAnsSelection = [Int]()
        if questions.count > 0 {
            quesNumber = 0
            questionLabel.text = questions[quesNumber].ques
            answers = questions[quesNumber].answers
            for i in 0..<answerButtons.count {
                answerButtons[i].setTitle(questions[quesNumber].options[i], for: .normal)
            }
            questions.remove(at: quesNumber)
        } else {
            NSLog("Done!")
            stopTimer()
            
            results.titleLabel.text = "Results"
            results.subTitleLabel.text = "\(correctAnswers) out of \(initialQuestionsCount)"
            let actualSeconds = seconds - (initialQuestionsCount/2)
            results.timeLabel.text = "Completed in: \(hours)hrs : \(minutes)mins : \(actualSeconds)secs"
            results.quizButton.addTarget(self, action: #selector(newQuiz), for: .touchUpInside)
            self.view.addSubview(results)
        }
        updateOptionsUI()
    }
    
    @objc func newQuiz() {
        results.removeFromSuperview()
        NSLog("Launch new quiz")
        correctAnswers = 0
        updateOptionsUI()
        startTimer()
        
        questions.append(Question(ques: "Question 5", options: ["1", "2", "3", "4"], answers: [1]))
        questions.append(Question(ques: "Question 6", options: ["5", "6", "7", "8"], answers: [0]))
        questions.append(Question(ques: "Question 7", options: ["9", "10", "11", "12"], answers: [3]))
        questions.append(Question(ques: "Question 8", options: ["13", "14", "15", "16"], answers: [2]))
        
        initialQuestionsCount = questions.count
        pickQuestion()
    }
    
    func highlightCorrectAnswers(ans: [Int]) {
        if(ans.count > 1){
            let result = ans.containsSameElements(as: mutiAnsSelection)
            print("Multi selection answers: \(result))")
            if result {
                correctAnswers += 1
            }
        }
        for i in ans {
            answerButtons[i].layer.borderColor = UIColor.green.cgColor
            answerButtons[i].layer.borderWidth = 2.0
            answerButtons[i].layer.cornerRadius = 4.0
            answerButtons[i].layer.backgroundColor = UIColor.green.cgColor
        }
    }
    
    func highlightSelectedAnswers(option: Int) {
        answerButtons[option].layer.borderColor = UIColor.darkGray.cgColor
        answerButtons[option].layer.borderWidth = 2.0
        answerButtons[option].layer.cornerRadius = 4.0
        answerButtons[option].layer.backgroundColor = UIColor.darkGray.cgColor
    }
    
    @IBAction func option1(_ sender: Any) {
        highlightSelectedAnswers(option: 0)
        if (answers.count > 1) {
            mutiAnsSelection.append(0)
            if (answers.count > 1 && answers.contains(0)) {
                //Multiple answers
                if mutiAnsSelection.count == answers.count {
                    highlightCorrectAnswers(ans: answers)
                     DispatchQueue.main.asyncAfter(deadline: .now() + sleepTime) {
                        self.pickQuestion()
                     }
                }
            } else if (mutiAnsSelection.count >= answers.count) {
                highlightCorrectAnswers(ans: answers)
                DispatchQueue.main.asyncAfter(deadline: .now() + sleepTime) {
                   self.pickQuestion()
                }
            }
        } else {
            if answers[0] == 0 {
                correctAnswers += 1
                highlightCorrectAnswers(ans: answers)
                DispatchQueue.main.asyncAfter(deadline: .now() + sleepTime) {
                    //                self.updateOptionsUI()
                    self.pickQuestion()
                }
            } else {
                NSLog("Wrong Answer")
                answerButtons[0].layer.borderColor = UIColor.red.cgColor
                answerButtons[0].layer.borderWidth = 2.0
                answerButtons[0].layer.cornerRadius = 4.0
                answerButtons[0].layer.backgroundColor = UIColor.red.cgColor
                highlightCorrectAnswers(ans: self.answers)
                DispatchQueue.main.asyncAfter(deadline: .now() + sleepTime) {
                    self.pickQuestion()
                }
            }
        }
    }
    
    @IBAction func option2(_ sender: Any) {
        highlightSelectedAnswers(option: 1)
        if (answers.count > 1) {
            mutiAnsSelection.append(1)
            if (answers.count > 1 && answers.contains(1)) {
                //Multiple answers
                if mutiAnsSelection.count == answers.count {
                    highlightCorrectAnswers(ans: answers)
                     DispatchQueue.main.asyncAfter(deadline: .now() + sleepTime) {
                        self.pickQuestion()
                     }
                }
            } else if (mutiAnsSelection.count >= answers.count) {
                highlightCorrectAnswers(ans: answers)
                DispatchQueue.main.asyncAfter(deadline: .now() + sleepTime) {
                   self.pickQuestion()
                }
            }
        } else {
            if answers[0] == 1 {
                correctAnswers += 1
                highlightCorrectAnswers(ans: answers)
                DispatchQueue.main.asyncAfter(deadline: .now() + sleepTime) {
                    self.pickQuestion()
                }
            } else {
                NSLog("Wrong Answer")
                answerButtons[1].layer.borderColor = UIColor.red.cgColor
                answerButtons[1].layer.borderWidth = 2.0
                answerButtons[1].layer.cornerRadius = 4.0
                answerButtons[1].layer.backgroundColor = UIColor.red.cgColor
                highlightCorrectAnswers(ans: self.answers)
                DispatchQueue.main.asyncAfter(deadline: .now() + sleepTime) {
                    self.pickQuestion()
                }
            }
        }
    }
    
    @IBAction func option3(_ sender: Any) {
        highlightSelectedAnswers(option: 2)
        if (answers.count > 1) {
            mutiAnsSelection.append(2)
            if (answers.count > 1 && answers.contains(2)) {
                //Multiple answers
                if mutiAnsSelection.count == answers.count {
                    highlightCorrectAnswers(ans: answers)
                     DispatchQueue.main.asyncAfter(deadline: .now() + sleepTime) {
                        self.pickQuestion()
                     }
                }
            } else if (mutiAnsSelection.count >= answers.count) {
                highlightCorrectAnswers(ans: answers)
                DispatchQueue.main.asyncAfter(deadline: .now() + sleepTime) {
                   self.pickQuestion()
                }
            }
        } else {
            if answers[0] == 2 {
                correctAnswers += 1
                highlightCorrectAnswers(ans: answers)
                DispatchQueue.main.asyncAfter(deadline: .now() + sleepTime) {
                    self.pickQuestion()
                }
            } else {
                NSLog("Wrong Answer")
                answerButtons[2].layer.borderColor = UIColor.red.cgColor
                answerButtons[2].layer.borderWidth = 2.0
                answerButtons[2].layer.cornerRadius = 4.0
                answerButtons[2].layer.backgroundColor = UIColor.red.cgColor
                highlightCorrectAnswers(ans: self.answers)
                DispatchQueue.main.asyncAfter(deadline: .now() + sleepTime) {
                    self.pickQuestion()
                }
            }
        }
        
    }
    
    @IBAction func option4(_ sender: Any) {
        highlightSelectedAnswers(option: 3)
        if (answers.count > 1) {
            mutiAnsSelection.append(3)
            if (answers.count > 1 && answers.contains(2)) {
                //Multiple answers
                if mutiAnsSelection.count == answers.count {
                    highlightCorrectAnswers(ans: answers)
                     DispatchQueue.main.asyncAfter(deadline: .now() + sleepTime) {
                        self.pickQuestion()
                     }
                }
            } else if (mutiAnsSelection.count >= answers.count) {
                highlightCorrectAnswers(ans: answers)
                DispatchQueue.main.asyncAfter(deadline: .now() + sleepTime) {
                   self.pickQuestion()
                }
            }
        } else {
            if answers[0] == 3 {
                correctAnswers += 1
                highlightCorrectAnswers(ans: answers)
                DispatchQueue.main.asyncAfter(deadline: .now() + sleepTime) {
                    self.pickQuestion()
                }
            } else {
                NSLog("Wrong Answer")
                answerButtons[3].layer.borderColor = UIColor.red.cgColor
                answerButtons[3].layer.borderWidth = 2.0
                answerButtons[3].layer.cornerRadius = 4.0
                answerButtons[3].layer.backgroundColor = UIColor.red.cgColor
                highlightCorrectAnswers(ans: self.answers)
                DispatchQueue.main.asyncAfter(deadline: .now() + sleepTime) {
                    self.pickQuestion()
                }
            }
        }
        
    }
    
    func startTimer(){
        timerIsPaused = false
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ tempTimer in
            if self.seconds == 59 {
                self.seconds = 00
                if self.minutes == 59 {
                    self.minutes = 00
                    self.hours = self.hours + 01
                } else {
                    self.minutes = self.minutes + 01
                }
            } else {
                self.seconds = self.seconds + 01
            }
        }
    }
    
    func stopTimer(){
        timerIsPaused = true
        timer?.invalidate()
        timer = nil
    }
    
}


extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}


