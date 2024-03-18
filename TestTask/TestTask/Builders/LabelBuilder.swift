//
//  LabelBuilder.swift
//  TestTask
//
//  Created by User on 18.03.2024.
//

import UIKit

final class LabelBuilder {
    private var text: String = ""
    private var textColor: UIColor = .white
    private var font: UIFont?
    private var textAligtment: NSTextAlignment = .left
    private var numbersOfLine: Int = 1
    
    
    func setText(_ text: String) -> LabelBuilder {
        self.text = text
        return self
    }
    
    func setTextColor(_ textColor: UIColor) -> LabelBuilder {
        self.textColor = textColor
        return self
    }

    func setTextAligtment(_ textAligtment: NSTextAlignment) -> LabelBuilder {
        self.textAligtment = textAligtment
        return self
    }
    
    func setNumbersLines(_ numbersOfLine: Int) -> LabelBuilder {
        self.numbersOfLine = numbersOfLine
        return self
    }
    
    func build() -> UILabel{
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.textAlignment = textAligtment
        label.font = font
        label.numberOfLines = numbersOfLine
        return label
    }
}
