
import UIKit
import FirebaseAuth
import FirebaseFirestore

class PostViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var journalTextView: UITextView! // Changed to UITextView
    @IBOutlet weak var goalTextView: UITextView!
    
    @IBOutlet weak var deleteButton: UIButton!
    var username: String?
    var journal: String?
    var goal: String?
    var documentID: String?
    var uid: String?
    var onDeleteSuccess: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the labels with the passed data
        usernameLabel.text = username
        journalTextView.text = journal
        journalTextView.isEditable = false
        journalTextView.isScrollEnabled = true
        goalTextView.text = goal
        goalTextView.isEditable = false
        goalTextView.isScrollEnabled = true
        
        // Hide the delete button if the current user's UID doesn't match the post's UID
        if let currentUserUID = Auth.auth().currentUser?.uid {
            deleteButton.isHidden = currentUserUID != uid
        } else {
            // Hide the button if there's no logged-in user
            deleteButton.isHidden = true
        }
    }
    @IBAction func deletePressed(_ sender: Any) {
        // Create an alert
        let alert = UIAlertController(title: "Delete Post", message: "Are you sure you want to delete this post?", preferredStyle: .alert)
        
        // Add a "Yes" action
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] _ in
            guard let strongSelf = self, let documentID = strongSelf.documentID else { return }
            
            let firestore = Firestore.firestore()
            firestore.collection("check-ins").document(documentID).delete { error in
                if let error = error {
                    // Handle the error, e.g., show an error message
                    print("Error deleting document: \(error)")
                } else {
                    // Call the callback function before dismissing, if it exists
                    strongSelf.onDeleteSuccess?()
                    
                    // On successful deletion, dismiss the view controller
                    DispatchQueue.main.async {
                        strongSelf.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }))
        
        // Add a "Cancel" action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
}


