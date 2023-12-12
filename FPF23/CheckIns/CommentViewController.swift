import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var commentTable: UITableView!
    @IBOutlet weak var controlButton: UIButton!


    // Array of [username, comment] pairs
    var comments: [[String: String]] = []

    // Custom initializer
    init(documentId: String) {
        self.documentId = documentId
        super.init(nibName: nil, bundle: nil)
    }

    // Make documentId an optional
    var documentId: String?

    // Other outlets and properties...

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // No need to initialize documentId here, as it's optional
    }
 let currentUserUID = Auth.auth().currentUser?.uid;

    override func viewDidLoad() {
        super.viewDidLoad()

        commentTable.dataSource = self
        commentTable.delegate = self
        
        commentTable.register(UITableViewCell.self, forCellReuseIdentifier: "CommentCell")

        fetchComments()
    }

    func fetchComments() {
        let db = Firestore.firestore()
        db.collection("check-ins").document(documentId ?? "null").getDocument { [weak self] (document, error) in
            guard let self = self, let document = document, document.exists, let data = document.data(), let commentData = data["comments"] as? [[String:String]] else {
                print("Error fetching comments: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            self.comments = commentData
            self.comments.reverse() // if you want the latest comments first
            self.commentTable.reloadData()
        }
    }

    // UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CommentCell")
        let commentDict = comments[indexPath.row]

        cell.textLabel?.text = commentDict["username"]
        cell.detailTextLabel?.text = commentDict["commentText"]

        return cell
    }

    @IBAction func commentButtonPressed(_ sender: Any) {
        let modalViewController = CommentModalViewController()
        modalViewController.modalPresentationStyle = .overFullScreen

        modalViewController.onCommentSubmit = { [weak self] newComment in
            self?.submitComment(newComment)
        }

        present(modalViewController, animated: true, completion: nil)
    }

    func submitComment(_ commentText: String) {
        guard let documentId = documentId, let currentUserUID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()

        db.collection("users").document(currentUserUID).getDocument { [weak self] documentSnapshot, error in
            guard let self = self, let documentSnapshot = documentSnapshot, documentSnapshot.exists else {
                print("Error fetching user data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            let username = documentSnapshot.data()?["username"] as? String ?? "Unknown User"

            // Create new comment
            let newComment = ["username": username, "commentText": commentText]

            // Insert the new comment at the beginning of the array
            self.comments.insert(newComment, at: 0)

            // Update the Firestore document
            let documentRef = db.collection("check-ins").document(documentId)
            documentRef.updateData([
                "comments": FieldValue.arrayUnion([newComment])
            ]) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Document successfully updated")
                    self.commentTable.reloadData()
                }
            }
        }
    }



    // UITableViewDelegate methods can be added here if needed

    // Add actions for your buttons (pagination & comment posting) here
    // ...
}
