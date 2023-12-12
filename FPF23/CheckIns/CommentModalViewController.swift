import UIKit

class CommentModalViewController: UIViewController {
    
    let commentTextView = UITextView()
    let cancelButton = UIButton(type: .system)
    let commentButton = UIButton(type: .system)
    var onCommentSubmit: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        // Background color of the view
        view.backgroundColor = UIColor(red: 255/255, green: 246/255, blue: 197/255, alpha: 1.0)

        // Text input background color
        let textInputBackgroundColor = UIColor(red: 255/255, green: 249/255, blue: 221/255, alpha: 1.0)

        // Fonts and text color
        let helveticaBold = UIFont(name: "Helvetica-Bold", size: 17)!
        let textColor = UIColor(red: 82/255, green: 54/255, blue: 23/255, alpha: 1.0)

        // Calculate central position
        let screenWidth = UIScreen.main.bounds.width
        let textViewWidth: CGFloat = screenWidth * 0.8 // 80% of screen width
        let textViewHeight: CGFloat = 150 // Increased height
        let buttonWidth: CGFloat = 100
        let buttonHeight: CGFloat = 40
        let horizontalPadding: CGFloat = (screenWidth - textViewWidth) / 2
        let verticalPadding: CGFloat = 20

        // Setup comment text view
        commentTextView.frame = CGRect(x: horizontalPadding, y: 50, width: textViewWidth, height: textViewHeight)
        commentTextView.layer.borderColor = UIColor.gray.cgColor
        commentTextView.layer.borderWidth = 1.0
        commentTextView.layer.cornerRadius = 5.0
        commentTextView.font = helveticaBold
        commentTextView.textColor = textColor
        commentTextView.backgroundColor = textInputBackgroundColor
        view.addSubview(commentTextView)

        // Setup cancel button
        let cancelButtonFrame = CGRect(x: horizontalPadding, y: commentTextView.frame.maxY + verticalPadding, width: buttonWidth, height: buttonHeight)
        setupButton(cancelButton, title: "Cancel", frame: cancelButtonFrame)
        view.addSubview(cancelButton)

        // Setup comment button
        let commentButtonFrame = CGRect(x: screenWidth - horizontalPadding - buttonWidth, y: commentTextView.frame.maxY + verticalPadding, width: buttonWidth, height: buttonHeight)
        setupButton(commentButton, title: "Comment", frame: commentButtonFrame)
        view.addSubview(commentButton)
    }

    private func setupButton(_ button: UIButton, title: String, frame: CGRect) {
        button.setTitle(title, for: .normal)
        button.frame = frame
        button.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 17)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 82/255, green: 54/255, blue: 23/255, alpha: 1.0)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: title == "Cancel" ? #selector(cancelButtonTapped) : #selector(commentButtonTapped), for: .touchUpInside)
    }


    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }



    @objc private func commentButtonTapped() {
        if let commentText = commentTextView.text, !commentText.isEmpty {
            onCommentSubmit?(commentText)
        }
        dismiss(animated: true, completion: nil)
    }

}
