//
//  PropertiesViewController.swift
//  CDApp
//
//  Created by Виталик Молоков on 12.04.2023.
//

import UIKit

class DetailViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: - Properties

    private var isEdit = Bool()
    private var image: Data? = nil
    private let genders = ["Choose gender:",
                           "Male",
                           "Female",
                           "Not human"]

    var presenter: DetailPresenterType?

    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1.5
        button.layer.masksToBounds = true
        var config = UIButton.Configuration.borderedTinted()
        config.titleAlignment = .center
        button.configuration = config
        button.addTarget(self, action: #selector(editButtonPressed),
                         for: .allEvents)
        return button
    }()

    private lazy var avatarImageButton: UIButton = {
        let button = UIButton()
        if let avatarData = presenter?.person?.image {
            button.setImage(UIImage(data: avatarData), for: .normal)
        } else {
            button.setImage(UIImage(named: "face"), for: .normal)
        }
        button.imageView?.layer.masksToBounds = true
        button.imageView?.layer.cornerRadius = 100
        button.imageView?.contentMode = .scaleAspectFill
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(avatarButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .savedPhotosAlbum
        picker.allowsEditing = false
        picker.delegate = self
        return picker
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        let name = presenter?.person?.name
        textField.setting(systemImage: "person",
                          text: name ?? "")
        textField.delegate = self
        return textField
    }()

    private lazy var dateOfBirthTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Input your date of birdth"
        let date = presenter?.person?.dateOfBirth
        textField.setting(systemImage: "calendar",
                          text: date?.convertToString() ?? "")
        textField.datePicker(target: self,
                             currentDate: date ?? Date(),
                             doneAction: #selector(dataPickerDoneAction),
                             cancelAction: #selector(dataPickerCancelAction))
        return textField
    }()

    private lazy var genderPickerToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0,
                                              y: 0,
                                              width: view.frame.width,
                                              height: 30))
//        toolbar.sizeToFit()
        let space = UIBarButtonItem.flexibleSpace()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: nil,
                                         action: #selector(genderDoneButtonPressed))
        toolbar.setItems([space, doneButton], animated: true)
        return toolbar
    }()

    private lazy var genderTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Choose your gender"
        let gender = presenter?.person?.gender ?? ""
        textField.setting(systemImage: "person.2.circle",
                          text: gender)
        textField.inputView = genderPikerView
        textField.inputAccessoryView = genderPickerToolbar
        return textField
    }()

    private lazy var genderPikerView: UIPickerView = {
        let picker = UIPickerView(frame: CGRect(x: 0, y: 0,
                                                width: view.bounds.width,
                                                height: 130))
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()

    private lazy var lineUnderNameTextField: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()

    private lazy var lineUnderDateOfBirthTextField: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()

    private lazy var lineUnderGenderTextField: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()

    private lazy var dataStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillEqually
        stack.alignment = .fill
        [nameTextField,
         dateOfBirthTextField,
         genderTextField].forEach { stack.addArrangedSubview($0) }
        return stack
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupHierarchy()
        setupLayout()
        self.dismissKeyboard()
    }

    // MARK: - Setup functions

    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editButton)
        setupEditButton(title: "Edit",
                        borderColor: .lightGray)
    }

    private func setupHierarchy() {
        view.addSubview(avatarImageButton)
        view.addSubview(dataStackView)
        view.addSubview(lineUnderNameTextField)
        view.addSubview(lineUnderDateOfBirthTextField)
        view.addSubview(lineUnderGenderTextField)
    }

    private func setupLayout() {
        func setUnderlineView(_ lineView: UIView, under: UIView) {
            lineView.snp.makeConstraints { make in
                make.leading.trailing.equalTo(dataStackView)
                make.top.equalTo(under.snp.bottom)
                make.height.equalTo(2)
            }
        }

        editButton.snp.makeConstraints { make in
            make.width.equalTo(70)
        }

        avatarImageButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.height.width.equalTo(200)
        }

        dataStackView.snp.makeConstraints { make in
            make.top.equalTo(avatarImageButton.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }

        setUnderlineView(lineUnderNameTextField,
                         under: nameTextField)
        setUnderlineView(lineUnderDateOfBirthTextField,
                         under: dateOfBirthTextField)
        setUnderlineView(lineUnderGenderTextField,
                         under: genderTextField)
    }

    private func setupEditButton(title: String, borderColor: UIColor) {
        editButton.setTitle(title, for: .normal)
        editButton.layer.borderColor = borderColor.cgColor
    }

    // MARK: - Action Functions
    
    private func saveData() {
        presenter?.updatePerson(image: image,
                                name: nameTextField.text,
                                dateOfBirth: dateOfBirthTextField.text,
                                gender: genderTextField.text)
    }

    // MARK: - OBJC Functions

    @objc
    private func editButtonPressed() {

        isEdit.toggle()
        if isEdit {
            setupEditButton(title: "Save", borderColor: .red)
            avatarImageButton.isUserInteractionEnabled = true
            nameTextField.isUserInteractionEnabled = true
            dateOfBirthTextField.isUserInteractionEnabled = true
            genderTextField.isUserInteractionEnabled = true
        } else {
            setupEditButton(title: "Edit", borderColor: .lightGray)
            avatarImageButton.isUserInteractionEnabled = false
            nameTextField.isUserInteractionEnabled = false
            dateOfBirthTextField.isUserInteractionEnabled = false
            genderTextField.isUserInteractionEnabled = false
            dataPickerDoneAction()
            guard let personName = nameTextField.text,
                  !personName.trimmingCharacters(in: .whitespaces).isEmpty else {
                showAlert(title: "Sorry", message: "Enter name")
                return
            }
            saveData()
        }
    }

    @objc
    private func genderDoneButtonPressed() {
        self.view.endEditing(true)
    }

    @objc
    private func avatarButtonTapped() {
        present(imagePicker, animated: true, completion: nil)
    }

    @objc
    private func dataPickerCancelAction() {
        self.dateOfBirthTextField.resignFirstResponder()
    }

    @objc
    private func dataPickerDoneAction() {

        if let datePickerView = self.dateOfBirthTextField.inputView as? UIDatePicker {
            self.dateOfBirthTextField.text = datePickerView.date.convertToString()
            self.dateOfBirthTextField.resignFirstResponder()
        }
    }
}

// MARK: - UITextFieldDelegate

extension DetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        editButtonPressed()
        return true
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension DetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }

    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return genders[row]
    }

    func pickerView(_ pickerView: UIPickerView,
                    rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }

    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
        guard row != 0 else { return }
        genderTextField.text = genders[row]
    }
}

// MARK: - UIImagePickerControllerDelegate

extension DetailViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        imagePicker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            showAlert(title: "Error", message: "\(info)")
            return
        }

        DispatchQueue.main.async {
            let scaledImage = image.scaleTo(targetSize: CGSize(width: 100, height: 100))
            self.image = scaledImage.pngData()

            if let avatar = self.image {
                self.avatarImageButton.setImage(UIImage(data: avatar), for: .normal)
            }
        }
    }
}
