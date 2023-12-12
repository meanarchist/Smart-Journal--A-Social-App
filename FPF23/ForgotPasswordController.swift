//
//  ForgotPasswordController.swift
//  FPF23
//
//  Created by Tharun Kumar on 11/12/23.
//

import UIKit

class ForgotPasswordController: UIViewController {
    
       // MARK: - UI Components
       private let headerView = AuthHeaderView(title: "Forgot Password", subTitle: "Reset your password")
       
       private let emailField = CustomTextField(fieldType: .email)
       
       private let resetPasswordButton = CustomButton(title: "Send Reset Email", hasBackground: true, fontSize: .big)
       
       // MARK: - LifeCycle
       override func viewDidLoad() {
           super.viewDidLoad()
           self.setupUI()
           
           self.resetPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
       }
       
       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           self.navigationController?.navigationBar.isHidden = false
       }
       
       // MARK: - UI Setup
    private func setupUI() {
        // Set the background color to the specified RGB values
        self.view.backgroundColor = UIColor(red: 255/255, green: 246/255, blue: 197/255, alpha: 1.0)
        
        // Set the background color for text input fields
        let textInputBackgroundColor = UIColor(red: 255/255, green: 249/255, blue: 221/255, alpha: 1.0)
        
        // Create a UIFont with Helvetica-Bold and specify the text color
        let helveticaBoldBig = UIFont(name: "Helvetica-Bold", size: 28)!
        let helveticaBold = UIFont(name: "Helvetica-Bold", size: 17)!
        let textColor = UIColor(red: 82/255, green: 54/255, blue: 23/255, alpha: 1.0)

        // Apply the font and text color to the header view
        headerView.titleLabel.font = helveticaBoldBig
        headerView.titleLabel.textColor = textColor
        headerView.subTitleLabel.font = helveticaBold
        headerView.subTitleLabel.textColor = textColor
        
        // Apply the font and text color to the email field
        emailField.font = helveticaBold
        emailField.textColor = textColor
        emailField.backgroundColor = textInputBackgroundColor
        
        // Apply the font and background color to the reset password button
        resetPasswordButton.titleLabel?.font = helveticaBold
        resetPasswordButton.backgroundColor = textColor
        resetPasswordButton.setTitleColor(.white, for: .normal)
        
        // Add subviews and set constraints
        self.view.addSubview(headerView)
        self.view.addSubview(emailField)
        self.view.addSubview(resetPasswordButton)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        resetPasswordButton.translatesAutoresizingMaskIntoConstraints = false

           
           self.view.addSubview(headerView)
           self.view.addSubview(emailField)
           self.view.addSubview(resetPasswordButton)
           
           headerView.translatesAutoresizingMaskIntoConstraints = false
           emailField.translatesAutoresizingMaskIntoConstraints = false
           resetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
           
           NSLayoutConstraint.activate([
               self.headerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30),
               self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
               self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
               self.headerView.heightAnchor.constraint(equalToConstant: 230),
               
               self.emailField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 11),
               self.emailField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
               self.emailField.heightAnchor.constraint(equalToConstant: 55),
               self.emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
               
               
               self.resetPasswordButton.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 22),
               self.resetPasswordButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
               self.resetPasswordButton.heightAnchor.constraint(equalToConstant: 55),
               self.resetPasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
           ])
       }
       
       // MARK: - Selectors
       @objc private func didTapForgotPassword() {
           let email = self.emailField.text ?? ""
           
           if !Validator.isValidEmail(for: email) {
               AlertManager.showInvalidEmailAlert(on: self)
               return
           }
           
           AuthService.shared.forgotPassword(with: email) { [weak self] error in
               guard let self = self else { return }
               if let error = error {
                   AlertManager.showErrorSendingPasswordReset(on: self, with: error)
                   return
               }
               
               AlertManager.showPasswordResetSent(on: self)
           }
       }
   }

