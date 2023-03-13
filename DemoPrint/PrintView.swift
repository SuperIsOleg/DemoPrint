//
//  PrintView.swift
//  DemoPrint
//
//  Created by Oleg Kalistratov on 2.03.23.
//

import UIKit
import SnapKit

class PrintView: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "QRcode")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private(set) var textField: UITextField = {
       let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.textAlignment = .center
        return textField
    }()
    
    private(set) var printButton: UIButton = {
        let button = UIButton()
        button.setTitle("Print", for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.backgroundColor = .white
        
        self.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(100)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        self.addSubview(textField)
        textField.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }
        
        self.addSubview(printButton)
        printButton.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }
    }
    
    internal func getImage() -> UIImage {
        guard let image = imageView.image else { return UIImage() }
        return image
    }
}
