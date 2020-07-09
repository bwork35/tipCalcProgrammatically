//
//  TipCalcViewController.swift
//  TipCalcProg
//
//  Created by Bryan Workman on 7/7/20.
//  Copyright © 2020 Bryan Workman. All rights reserved.
//

import UIKit

class TipCalcViewController: UIViewController {
    
    //MARK: - Properties
    var tipPercent = 0
    var finalTip: Double = 0.00
    var finalTotal: Double = 0.00
    
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    
    let tipCalcTableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    var buttons: [UIButton] {
        return [tenPercentButton, fifteenPercentButton, eighteenPercentButton, twentyPercentButton, calculateButton, roundUpButton, roundDownButton]
    }
    
    //MARK: - Lifecycles
    override func loadView() {
        super.loadView()
        addAllSubviews()
        setupTopLabelStackView()
        setupBillTotalStackView()
        setupPercentButtonsStackView()
        setupCustomTipStackView()
        setupTotalStackView()
        setUpTipTotalStackView()
        setupRoundStackView()
        setupBottomStackView()
        hideViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 1, green: 0.9425795151, blue: 0.8221904506, alpha: 1)
        activateButtons()
    }
    
    //MARK: - Methods
    @objc func selectButton(sender: UIButton) {
        switch sender {
        case tenPercentButton:
            tipPercent = 10
            percentTipChosen()
            calculateTip()
        case fifteenPercentButton:
            tipPercent = 15
            percentTipChosen()
            calculateTip()
        case eighteenPercentButton:
            tipPercent = 18
            percentTipChosen()
            calculateTip()
        case twentyPercentButton:
            tipPercent = 20
            percentTipChosen()
            calculateTip()
        case calculateButton:
            calculateTip()
        case roundUpButton:
            roundUpButton.isHidden = true
            roundDownButton.isHidden = true
            roundUp()
        case roundDownButton:
            roundUpButton.isHidden = true
            roundDownButton.isHidden = true
            roundDown()
        default:
            print("")
        }
    }
    
    func activateButtons() {
        buttons.forEach { $0.addTarget(self, action: #selector(selectButton(sender:)), for: .touchUpInside) }
    }
    
    func calculateTip() {
        guard let billTotalAmount = billTotalTextField.text, !billTotalAmount.isEmpty else {return}
        let billDouble = Double(billTotalAmount)
        let billAmount = billDouble ?? 0.00
        
        if customTipTextField.text != nil && customTipTextField.text != "" {
            guard let customTip = customTipTextField.text else {return}
            tipPercent = Int(customTip) ?? 0
            percentTipChosen()
        }
        
        let doubleTip = Double(tipPercent)/100
        let tip = billAmount * doubleTip
        let total = billAmount + tip
        
        tipTotalAmountLabel.text = "$" + String(format: "%.2f", tip)
        totalAmountLabel.text = "$" + String(format: "%.2f", total)
        
        finalTip = tip
        finalTotal = total
        
        showViews()
    }
    
    func percentTipChosen(){
        switch tipPercent {
        case 10:
            tenPercentButton.backgroundColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
            fifteenPercentButton.backgroundColor = .systemTeal
            eighteenPercentButton.backgroundColor = .systemTeal
            twentyPercentButton.backgroundColor = .systemTeal
            customTipTextField.text = ""
            tenPercentButton.setTitleColor(.white, for: .normal)
            fifteenPercentButton.setTitleColor(.red, for: .normal)
            eighteenPercentButton.setTitleColor(.red, for: .normal)
            twentyPercentButton.setTitleColor(.red, for: .normal)
            
        case 15:
            tenPercentButton.backgroundColor = .systemTeal
            fifteenPercentButton.backgroundColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
            eighteenPercentButton.backgroundColor = .systemTeal
            twentyPercentButton.backgroundColor = .systemTeal
            customTipTextField.text = ""
            tenPercentButton.setTitleColor(.red, for: .normal)
            fifteenPercentButton.setTitleColor(.white, for: .normal)
            eighteenPercentButton.setTitleColor(.red, for: .normal)
            twentyPercentButton.setTitleColor(.red, for: .normal)
            
        case 18:
            tenPercentButton.backgroundColor = .systemTeal
            fifteenPercentButton.backgroundColor = .systemTeal
            eighteenPercentButton.backgroundColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
            twentyPercentButton.backgroundColor = .systemTeal
            customTipTextField.text = ""
            tenPercentButton.setTitleColor(.red, for: .normal)
            fifteenPercentButton.setTitleColor(.red, for: .normal)
            eighteenPercentButton.setTitleColor(.white, for: .normal)
            twentyPercentButton.setTitleColor(.red, for: .normal)
            
        case 20:
            tenPercentButton.backgroundColor = .systemTeal
            fifteenPercentButton.backgroundColor = .systemTeal
            eighteenPercentButton.backgroundColor = .systemTeal
            twentyPercentButton.backgroundColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
            customTipTextField.text = ""
            tenPercentButton.setTitleColor(.red, for: .normal)
            fifteenPercentButton.setTitleColor(.red, for: .normal)
            eighteenPercentButton.setTitleColor(.red, for: .normal)
            twentyPercentButton.setTitleColor(.white, for: .normal)
            
        default:
            tenPercentButton.backgroundColor = .systemTeal
            fifteenPercentButton.backgroundColor = .systemTeal
            eighteenPercentButton.backgroundColor = .systemTeal
            twentyPercentButton.backgroundColor = .systemTeal
            tenPercentButton.setTitleColor(.red, for: .normal)
            fifteenPercentButton.setTitleColor(.red, for: .normal)
            eighteenPercentButton.setTitleColor(.red, for: .normal)
            twentyPercentButton.setTitleColor(.red, for: .normal)
        }
    }
    
    func roundUp() {
        let currentTotal = finalTotal.rounded(.up)
        let difference = currentTotal - finalTotal
        let currentTip = finalTip + difference
        
        tipTotalAmountLabel.text = "$" + String(format: "%.2f", currentTip)
        totalAmountLabel.text = "$" + String(format: "%.2f", currentTotal)
    }
     
    func roundDown() {
        let currentTotal = finalTotal.rounded(.down)
        let difference = finalTotal - currentTotal
        let currentTip = finalTip - difference
        
        tipTotalAmountLabel.text = "$" + String(format: "%.2f", currentTip)
        totalAmountLabel.text = "$" + String(format: "%.2f", currentTotal)
    }
    
    func hideViews() {
        self.tipTotalLabelLabel.isHidden = true
        self.tipTotalAmountLabel.isHidden = true
        self.totalAmountLabel.isHidden = true
        self.totalLabelLabel.isHidden = true
        self.roundUpButton.isHidden = true
        self.roundDownButton.isHidden = true
    }
    
    func showViews() {
        self.tipTotalLabelLabel.isHidden = false
        self.tipTotalAmountLabel.isHidden = false
        self.totalAmountLabel.isHidden = false
        self.totalLabelLabel.isHidden = false
        self.roundUpButton.isHidden = false
        self.roundDownButton.isHidden = false
    }
    
    func addAllSubviews() {
        self.view.addSubview(topLabelStackView)
        self.view.addSubview(tipCalcLabel)
        self.view.addSubview(billTotalStackView)
        self.view.addSubview(billTotalLabel)
        self.view.addSubview(billTotalTextField)
        self.view.addSubview(percentButtonsStackView)
        self.view.addSubview(tenPercentButton)
        self.view.addSubview(fifteenPercentButton)
        self.view.addSubview(eighteenPercentButton)
        self.view.addSubview(twentyPercentButton)
        self.view.addSubview(customTipStackView)
        self.view.addSubview(customTipLabel)
        self.view.addSubview(customTipTextField)
        self.view.addSubview(calculateButton)
        self.view.addSubview(totalStackView)
        self.view.addSubview(totalLabelLabel)
        self.view.addSubview(totalAmountLabel)
        self.view.addSubview(tipTotalStackView)
        self.view.addSubview(tipTotalLabelLabel)
        self.view.addSubview(tipTotalAmountLabel)
        self.view.addSubview(roundStackView)
        self.view.addSubview(roundUpButton)
        self.view.addSubview(roundDownButton)
        self.view.addSubview(bottomStackView)
    }
    
    func setupTopLabelStackView() {
        topLabelStackView.addArrangedSubview(tipCalcLabel)
        
        topLabelStackView.topAnchor.constraint(equalTo: self.safeArea.topAnchor, constant: 40).isActive = true
        topLabelStackView.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor, constant: 8).isActive = true
        topLabelStackView.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor, constant: -8).isActive = true
    }
    
    func setupBillTotalStackView() {
        billTotalStackView.addArrangedSubview(billTotalLabel)
        billTotalStackView.addArrangedSubview(billTotalTextField)
        
        billTotalStackView.topAnchor.constraint(equalTo: topLabelStackView.bottomAnchor, constant: 60).isActive = true
        billTotalStackView.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor, constant: 30).isActive = true
        billTotalStackView.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor, constant: -70).isActive = true
    }
    
    func setupPercentButtonsStackView() {
        percentButtonsStackView.addArrangedSubview(tenPercentButton)
        percentButtonsStackView.addArrangedSubview(fifteenPercentButton)
        percentButtonsStackView.addArrangedSubview(eighteenPercentButton)
        percentButtonsStackView.addArrangedSubview(twentyPercentButton)
        
        percentButtonsStackView.topAnchor.constraint(equalTo: billTotalStackView.bottomAnchor, constant: 40).isActive = true
        percentButtonsStackView.leadingAnchor.constraint(equalTo: self.safeArea.leadingAnchor, constant: 50).isActive = true
        percentButtonsStackView.trailingAnchor.constraint(equalTo: self.safeArea.trailingAnchor, constant: -50).isActive = true
    }
    
    func setupCustomTipStackView() {
        customTipStackView.addArrangedSubview(customTipLabel)
        customTipStackView.addArrangedSubview(customTipTextField)
        customTipStackView.addArrangedSubview(calculateButton)
        
        customTipStackView.topAnchor.constraint(equalTo: percentButtonsStackView.bottomAnchor, constant: 30).isActive = true
        customTipStackView.leadingAnchor.constraint(equalTo: percentButtonsStackView.leadingAnchor, constant: 30).isActive = true
        customTipStackView.trailingAnchor.constraint(equalTo: percentButtonsStackView.trailingAnchor, constant: -30).isActive = true
    }
    
    func setUpTipTotalStackView() {
        tipTotalStackView.addArrangedSubview(tipTotalLabelLabel)
        tipTotalStackView.addArrangedSubview(tipTotalAmountLabel)
        
        tipTotalStackView.topAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: 0).isActive = true
        tipTotalStackView.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor, constant: 0).isActive = true
        tipTotalStackView.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor, constant: 0).isActive = true
    }
    
    func setupTotalStackView() {
        totalStackView.addArrangedSubview(totalLabelLabel)
        totalStackView.addArrangedSubview(totalAmountLabel)
        
        totalStackView.topAnchor.constraint(equalTo: tipTotalStackView.bottomAnchor, constant: 10).isActive = true
        totalStackView.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor, constant: 0).isActive = true
        totalStackView.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor, constant: 0).isActive = true
    }
    
    func setupRoundStackView() {
        roundStackView.addArrangedSubview(roundUpButton)
        roundStackView.addArrangedSubview(roundDownButton)
        
        roundStackView.topAnchor.constraint(equalTo: totalStackView.bottomAnchor, constant: 50).isActive = true
        roundStackView.leadingAnchor.constraint(equalTo: bottomStackView.leadingAnchor, constant: 45).isActive = true
        roundStackView.trailingAnchor.constraint(equalTo: bottomStackView.trailingAnchor, constant: -45).isActive = true
    }
    
    func setupBottomStackView() {
        bottomStackView.addArrangedSubview(tipTotalStackView)
        bottomStackView.addArrangedSubview(totalStackView)
        bottomStackView.addArrangedSubview(roundStackView)
        
        bottomStackView.topAnchor.constraint(equalTo: customTipStackView.bottomAnchor, constant: 150).isActive = true
        bottomStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0).isActive = true
        bottomStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0).isActive = true
    }
    
    
    //MARK: - Views
    
    let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let roundUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Round Up", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.contentHorizontalAlignment = .center
        button.backgroundColor = .systemTeal
        button.addCornerRadius()
        
        return button
    }()
    
    let roundDownButton: UIButton = {
        let button = UIButton()
        button.setTitle("Round Down", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.contentHorizontalAlignment = .center
        button.backgroundColor = .systemTeal
        button.addCornerRadius()
        
        return button
    }()
    
    let roundStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 45
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let totalAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "$43.55"
        label.textColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 25)
        
        return label
    }()
    
    let totalLabelLabel: UILabel = {
        let label = UILabel()
        label.text = "Total: "
        label.textColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 25)
        
        return label
    }()
    
    let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let tipTotalAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "$8.90"
        label.textColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 25)
        
        return label
    }()
    
    let tipTotalLabelLabel: UILabel = {
        let label = UILabel()
        label.text = "Tip: "
        label.textColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 25)
        
        return label
    }()
    
    let tipTotalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let calculateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Calculate", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.contentHorizontalAlignment = .center
        button.backgroundColor = .systemTeal
        button.addCornerRadius()
        
        return button
    }()
    
    let customTipTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0%"
        textField.textAlignment = .right
        textField.backgroundColor = .white
        
        return textField
    }()
    
    let customTipLabel: UILabel = {
        let label = UILabel()
        label.text = "Custom Tip: "
        label.textColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 25)
        
        return label
    }()
    
    let customTipStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let tenPercentButton: UIButton = {
        let button = UIButton()
        button.setTitle("  10%  ", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.contentHorizontalAlignment = .center
        button.backgroundColor = .systemTeal
        button.addCornerRadius()
        
        return button
    }()
    
    let fifteenPercentButton: UIButton = {
        let button = UIButton()
        button.setTitle("  15%  ", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.contentHorizontalAlignment = .center
        button.backgroundColor = .systemTeal
        button.addCornerRadius()
        
        return button
    }()
    
    let eighteenPercentButton: UIButton = {
        let button = UIButton()
        button.setTitle("  18%  ", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.contentHorizontalAlignment = .center
        button.backgroundColor = .systemTeal
        button.addCornerRadius()
        
        return button
    }()
    
    let twentyPercentButton: UIButton = {
        let button = UIButton()
        button.setTitle("  20%  ", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.contentHorizontalAlignment = .center
        button.backgroundColor = .systemTeal
        button.addCornerRadius()
        
        return button
    }()
    
    let percentButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let billTotalTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "$0.00"
        textField.backgroundColor = .white
        textField.textAlignment = .right
        
        return textField
    }()
    
    
    let billTotalLabel: UILabel = {
        let label = UILabel()
        label.text = "Bill Total: "
        label.textColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 25)
        
        return label
    }()
    
    let billTotalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let tipCalcLabel: UILabel = {
        let label = UILabel()
        label.text = "Tip Calculator"
        label.textColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let topLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    
}//End of class
