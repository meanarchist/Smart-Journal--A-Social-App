//
//  LoginViewController.swift
//  LoginSignupApp
//
//  Created by Tharun Kumar on 11/8/23.
//

import UIKit

class LoginController: UIViewController {
    @IBOutlet var signInButton: CustomButton!
    
    @IBOutlet var emailField: CustomTextField!
    @IBOutlet var passwordField: CustomTextField!
    @IBOutlet var newUserButton: CustomButton!
    @IBOutlet var forgotPasswordButton: CustomButton!
    @IBOutlet var headerView: AuthHeaderView!
    // MARK: - UI Components
   // private let headerView = AuthHeaderView(title: "Sign In", subTitle: "Sign in to your account")
    
    //private let emailField = CustomTextField(fieldType: .email)
    //private let passwordField = CustomTextField(fieldType: .password)
    
    
    //private let newUserButton = CustomButton(title: "New User? Create Account.", fontSize: .med)
    //private let forgotPasswordButton = CustomButton(title: "Forgot Password?", fontSize: .small)
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView = AuthHeaderView(title: "smart journal", subTitle: "Set goals and grow!")
        signInButton = CustomButton(title: "Sign In", hasBackground: true, fontSize: .big)
        emailField = CustomTextField(fieldType: .email)
        passwordField = CustomTextField(fieldType: .password)
        newUserButton = CustomButton(title: "New User? Create Account.", fontSize: .med)
        forgotPasswordButton = CustomButton(title: "Forgot Password?", fontSize: .small)
        
        self.setupUI()
        
        self.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        self.newUserButton.addTarget(self, action: #selector(didTapNewUser), for: .touchUpInside)
        self.forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Set the background color to the specified RGB values
         self.view.backgroundColor = UIColor(red: 255/255, green: 246/255, blue: 197/255, alpha: 1.0)
         
        // Set the background color to the specified RGB values
        self.view.backgroundColor = UIColor(red: 255/255, green: 246/255, blue: 197/255, alpha: 1.0)
        
        // Set the background color for text input fields
        let textInputBackgroundColor = UIColor(red: 255/255, green: 249/255, blue: 221/255, alpha: 1.0)
        
        // Create a UIFont with Helvetica-Bold and specify the text color
        let helveticaBoldBig = UIFont(name: "Helvetica-Bold", size: 28)!

        let helveticaBold = UIFont(name: "Helvetica-Bold", size: 17)!
        let helvetica = UIFont(name: "Helvetica", size: 17)!

        let textColor = UIColor(red: 82/255, green: 54/255, blue: 23/255, alpha: 1.0)
        let buttonBackgroundColor = textColor // Background color same as text color for the sign-in button
        
        // Apply the font and text color to all UI elements
        headerView.titleLabel.font = helveticaBoldBig
        headerView.titleLabel.textColor = textColor
        headerView.subTitleLabel.font = helvetica
        headerView.subTitleLabel.textColor = textColor
        
        emailField.font = helveticaBold
        emailField.textColor = textColor
        emailField.backgroundColor = textInputBackgroundColor // Set background color
        
        passwordField.font = helveticaBold
        passwordField.textColor = textColor
        passwordField.backgroundColor = textInputBackgroundColor // Set background color
        
        signInButton.titleLabel?.font = helveticaBold
        signInButton.backgroundColor = buttonBackgroundColor // Set background color
        signInButton.setTitleColor(.white, for: .normal) // Text color set to white
        
        newUserButton.titleLabel?.font = helvetica
        newUserButton.setTitleColor(textColor, for: .normal)
        
        forgotPasswordButton.titleLabel?.font = helvetica
        forgotPasswordButton.setTitleColor(textColor, for: .normal)
        self.view.addSubview(headerView)
        self.view.addSubview(emailField)
        self.view.addSubview(passwordField)
        self.view.addSubview(signInButton)
        self.view.addSubview(newUserButton)
        self.view.addSubview(forgotPasswordButton)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        newUserButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 222),
            
            self.emailField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            self.emailField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.emailField.heightAnchor.constraint(equalToConstant: 55),
            self.emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 22),
            self.passwordField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.passwordField.heightAnchor.constraint(equalToConstant: 55),
            self.passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.signInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 22),
            self.signInButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.signInButton.heightAnchor.constraint(equalToConstant: 55),
            self.signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.newUserButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 11),
            self.newUserButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.newUserButton.heightAnchor.constraint(equalToConstant: 44),
            self.newUserButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.forgotPasswordButton.topAnchor.constraint(equalTo: newUserButton.bottomAnchor, constant: 6),
            self.forgotPasswordButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.forgotPasswordButton.heightAnchor.constraint(equalToConstant: 44),
            self.forgotPasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
        ])
    }
    
    // MARK: - Selectors
    @objc private func didTapSignIn() {
        let loginRequest = LoginUserRequest(
            email: self.emailField.text ?? "",
            password: self.passwordField.text ?? ""
        )
        
        // Email check
        if !Validator.isValidEmail(for: loginRequest.email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        // Password check
        if !Validator.isPasswordValid(for: loginRequest.password) {
            AlertManager.showInvalidPasswordAlert(on: self)
            return
        }
        
        AuthService.shared.signIn(with: loginRequest) { error in
            if let error = error {
                AlertManager.showSignInErrorAlert(on: self, with: error)
                return
            }
            

            // Use the NavigationHelpers function
            DispatchQueue.main.async {
                NavigationHelpers.navigateToCheckIn(from: self)
                print("NAVIGATION!")
            }
        }
    }
    
    @objc private func didTapNewUser() {
        let vc = RegisterController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapForgotPassword() {
        let vc = ForgotPasswordController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
