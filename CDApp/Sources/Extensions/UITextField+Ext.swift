//
//  UITextField+Ext.swift
//  CDApp
//
//  Created by Виталик Молоков on 05.05.2023.
//

import UIKit

extension UITextField {

    func setting(systemImage: String, text: String) {
        self.isUserInteractionEnabled = false
        self.leftViewMode = .always
        let image = UIImage(systemName: systemImage)
        let imageView = UIImageView(frame: CGRect(x: 5, y: 5,
                                                  width: 30,
                                                  height: 30))
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0,
                                                             width: imageView.frame.width + 20,
                                                             height: imageView.frame.height + 10))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .lightGray
        imageView.image = image
        iconContainerView.addSubview(imageView)
        self.leftView = iconContainerView
        self.text = text
    }

    func datePicker<T>(target: T,
                       currentDate: Date,
                       doneAction: Selector,
                       cancelAction: Selector,
                       datePickerMode: UIDatePicker.Mode = .date,
                       datePickerStyle: UIDatePickerStyle = .wheels) {

        let screenWidth = UIScreen.main.bounds.width

        func buttonItem(withSystemItemStyle style: UIBarButtonItem.SystemItem) -> UIBarButtonItem {
            let buttonTarget = style == .flexibleSpace ? nil : target
            let action: Selector? = {
                switch style {
                case .cancel:
                    return cancelAction
                case .done:
                    return doneAction
                default:
                    return nil
                }
            }()

            let barButtonItem = UIBarButtonItem(barButtonSystemItem: style,
                                                target: buttonTarget,
                                                action: action)
            return barButtonItem
        }

//     set datePicker
        let datePicker = UIDatePicker(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: screenWidth,
                                                    height: 216))
        datePicker.datePickerMode = datePickerMode
        datePicker.preferredDatePickerStyle = datePickerStyle
        datePicker.date = currentDate
        self.inputView = datePicker

//     set toolbar
        let toolBar = UIToolbar(frame: CGRect(x: 0,
                                              y: 0,
                                              width: screenWidth,
                                              height: 30))
        toolBar.setItems([buttonItem(withSystemItemStyle: .cancel),
                          buttonItem(withSystemItemStyle: .flexibleSpace),
                          buttonItem(withSystemItemStyle: .done)],
                         animated: true)
        self.inputAccessoryView = toolBar
    }
}
