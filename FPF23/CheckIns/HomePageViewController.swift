import UIKit
import Firebase
import FirebaseFirestore

class HomePageViewController: UIViewController {
    
    // UI Elements
    var lastDocumentSnapshot: DocumentSnapshot?

    @IBOutlet weak var postSlot1: UIButton!
    
    @IBOutlet weak var postSlot2: UIButton!
    @IBOutlet weak var postSlot3: UIButton!
    @IBOutlet weak var likeButton1: UIButton!
    // Add UILabels for username, date-time, and journal content as needed
    @IBOutlet weak var likeButton2: UIButton!
    @IBOutlet weak var likeButton3: UIButton!
    @IBOutlet weak var commentButton1: UIButton!
    @IBOutlet weak var commentButton2: UIButton!
    @IBOutlet weak var commentButton3: UIButton!
    @IBOutlet weak var usernameLabel1: UILabel!
    
    @IBOutlet weak var usernameLabel2: UILabel!
    @IBOutlet weak var usernameLabel3: UILabel!
    let db = Firestore.firestore()
    @IBOutlet weak var dateTimeLabel1: UILabel!
    
    @IBOutlet weak var dateTimeLabel3: UILabel!
    @IBOutlet weak var dateTimeLabel2: UILabel!
    @IBOutlet weak var journalContentLabel1: UILabel!
    @IBOutlet weak var journalContentLabel2: UILabel!
    @IBOutlet weak var journalContentLabel3: UILabel!
    
    @IBOutlet weak var visibilityChip: UISegmentedControl!
    var earliestPostDate: Date?
    var latestPostDate: Date?
    var documentSnapshotsStack: [DocumentSnapshot] = []

    @IBOutlet weak var emotion3: UIImageView!
    @IBOutlet weak var emotion1: UIImageView!
    @IBOutlet weak var emotion2: UIImageView!
    
    @IBOutlet weak var likeLabel1: UILabel!
    
    @IBOutlet weak var likeLabel2: UILabel!
    
    @IBOutlet weak var likeLabel3: UILabel!
    var posts = [Post]()
    var lastFetchPostCount = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVisibilityChip()
        fetchPosts(visibility: "public")
    }

    func setupVisibilityChip() {
        visibilityChip.removeAllSegments()
        visibilityChip.insertSegment(withTitle: "Public", at: 0, animated: false)

        visibilityChip.insertSegment(withTitle: "Private", at: 1, animated: false)
        visibilityChip.selectedSegmentIndex = 0 // Default to "Public"
        visibilityChip.addTarget(self, action: #selector(visibilityChanged), for: .valueChanged)

    }
    
    func refreshPosts() {
        // Clear current posts
        posts.removeAll()

        // Fetch the latest posts and update UI
        let visibilityOption = visibilityChip.selectedSegmentIndex == 0 ? "public" : "private"
        fetchPosts(visibility: visibilityOption)
    }

    
    
    @IBAction func visibilityChanged(_ sender: UISegmentedControl) {
        let visibilityOption = sender.selectedSegmentIndex == 0 ? "public" : "private"
        print("Changing visibility to: " + visibilityOption)

        // Clear the stack whenever the visibility changes
        documentSnapshotsStack.removeAll()

        // Reset the last document snapshot
        lastDocumentSnapshot = nil

        // Fetch posts with the new visibility setting
        fetchPosts(visibility: visibilityOption)
    }
    func fetchPosts(visibility: String, startAfterDocument: DocumentSnapshot? = nil) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        var query: Query = db.collection("check-ins")
            .whereField("visibility", isEqualTo: visibility)
            .order(by: "dateTime", descending: true)
            .limit(to: 3)

        // Additional filter for private visibility
        if visibility == "private" {
            query = query.whereField("uid", isEqualTo: currentUserUID)
        }

        if let lastDoc = startAfterDocument {
            query = query.start(afterDocument: lastDoc)
        }

        query.getDocuments { [weak self] (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self?.posts = []
                self?.lastFetchPostCount = snapshot?.documents.count ?? 0

                for document in snapshot!.documents {
                    let post = Post(dictionary: document.data(), documentId: document.documentID)
                    self?.posts.append(post)
                }

                // Store the date range and last document snapshot for pagination
                self?.earliestPostDate = self?.posts.last?.dateTime
                self?.latestPostDate = self?.posts.first?.dateTime
                self?.lastDocumentSnapshot = snapshot?.documents.last

                // Update the UI with the fetched posts
                self?.fetchUsernamesAndUpdateUI(posts: self!.posts)
            }
        }
    }


    func fetchUsernamesAndUpdateUI(posts: [Post]) {
        let group = DispatchGroup()
        var tempPosts = [Int: (username: String, post: Post)]()

        for (index, post) in posts.enumerated() {
            group.enter()
            db.collection("users").document(post.uid).getDocument { (document, error) in
                if let document = document, document.exists {
                    let username = document.data()?["username"] as? String ?? ""
                    tempPosts[index] = (username, post)
                } else {
                    print("Document does not exist")
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            let sortedKeys = tempPosts.keys.sorted()
            let updatedPosts = sortedKeys.compactMap { tempPosts[$0] }
            self.updateUIWithPosts(updatedPosts)
        }
    }

    
    
    
    func updateUIWithPosts(_ posts: [(username: String, post: Post)]) {
        // Hide all the UI components first
        clearUI()
        
        // Arrays of UI elements
        let postSlots = [postSlot1, postSlot2, postSlot3]
        let likeButtons = [likeButton1, likeButton2, likeButton3]
        let commentButtons = [commentButton1, commentButton2, commentButton3]
        let usernameLabels = [usernameLabel1, usernameLabel2, usernameLabel3]
        let dateTimeLabels = [dateTimeLabel1, dateTimeLabel2, dateTimeLabel3]
        let journalContentLabels = [journalContentLabel1, journalContentLabel2, journalContentLabel3]
        let emotionImageViews = [emotion1, emotion2, emotion3]
        let likeLabels = [likeLabel1, likeLabel2, likeLabel3]

        // Update UI elements with post data
        for (index, postData) in posts.enumerated() {
            if index < postSlots.count {
                // Unhide the UI components for the current post
                postSlots[index]?.isHidden = false
                likeButtons[index]?.isHidden = false
                commentButtons[index]?.isHidden = false
                usernameLabels[index]?.isHidden = false
                dateTimeLabels[index]?.isHidden = false
                journalContentLabels[index]?.isHidden = false
                emotionImageViews[index]?.isHidden = false
                likeLabels[index]?.isHidden = false
                
                // Update the UI components with the post data
                updatePostUI(postData: (postData.username, postData.post),
                             usernameLabel: usernameLabels[index]!,
                             dateTimeLabel: dateTimeLabels[index]!,
                             journalContentLabel: journalContentLabels[index]!,
                             emotionImageView: emotionImageViews[index]!,
                             likeLabel: likeLabels[index]!)
                
                // Set the tag property for buttons
                likeButtons[index]?.tag = index
                commentButtons[index]?.tag = index
            }
        }
    }




    func updatePostUI(postData: (username: String?, post: Post?), usernameLabel: UILabel, dateTimeLabel: UILabel, journalContentLabel: UILabel, emotionImageView: UIImageView, likeLabel: UILabel) {
        usernameLabel.text = postData.username ?? ""
        dateTimeLabel.text = postData.post != nil ? formatDate(postData.post!.dateTime) : ""
        journalContentLabel.text = postData.post?.journal ?? ""

        // Set the emotion image
        let emotion = postData.post?.emotion ?? "okay" // Default to "okay"
        emotionImageView.image = UIImage(named: emotion)
        
        // Update the like label with the count of likes
        let likeCount = postData.post?.likes.count ?? 0
        print(likeCount)
        likeLabel.text = "\(likeCount)"
        // Check if the current user's UID is in the likes array
        if let currentUserUID = Auth.auth().currentUser?.uid, postData.post?.likes.contains(currentUserUID) == true {
            likeLabel.textColor = UIColor.yellow // Change color to yellow
        } else {
            likeLabel.textColor = UIColor.white // Default color (change as needed)
        }
    }


    
    func clearUI() {
        // Hide all the UI components related to the posts
        [postSlot1, postSlot2, postSlot3].forEach { $0.isHidden = true }
        [likeButton1, likeButton2, likeButton3].forEach { $0.isHidden = true }
        [commentButton1, commentButton2, commentButton3].forEach { $0.isHidden = true }
        [usernameLabel1, usernameLabel2, usernameLabel3].forEach { $0.isHidden = true }
        [dateTimeLabel1, dateTimeLabel2, dateTimeLabel3].forEach { $0.isHidden = true }
        [journalContentLabel1, journalContentLabel2, journalContentLabel3].forEach { $0.isHidden = true }
        [emotion1, emotion2, emotion3].forEach { $0.isHidden = true }
        [likeLabel1, likeLabel2, likeLabel3].forEach { $0.isHidden = true }
    }
    
    
    func navigateToReply1() {
        guard let post = self.posts.first else { return }

        if let commentVC = storyboard?.instantiateViewController(withIdentifier: "commentViewController") as? CommentViewController {
            commentVC.documentId = post.documentId
            // Embedding CommentViewController in UINavigationController
            let navController = UINavigationController(rootViewController: commentVC)
            self.present(navController, animated: true, completion: nil)
        }
    }
    func navigateToReply2() {
        // Ensure there are at least two posts to avoid out-of-range errors
        guard self.posts.count > 1 else {
            print("Not enough posts")
            return
        }

        let post = self.posts[1] // Get the second post
 
        if let commentVC = storyboard?.instantiateViewController(withIdentifier: "commentViewController") as? CommentViewController {
            commentVC.documentId = post.documentId

            // Embedding CommentViewController in UINavigationController
            let navController = UINavigationController(rootViewController: commentVC)
            self.present(navController, animated: true, completion: nil)
        }
    }

    @IBAction func showGoalsTapped(_ sender: UIButton) {
        // Perform the segue with the identifier set in your storyboard
        performSegue(withIdentifier: "showGoals", sender: self)
    }
   func navigateToReply3() {
        // Ensure there are at least two posts to avoid out-of-range errors
        guard self.posts.count > 2 else {
            print("Not enough posts")
            return
        }

        let post = self.posts[2] // Get the third post

        if let commentVC = storyboard?.instantiateViewController(withIdentifier: "commentViewController") as? CommentViewController {
            commentVC.documentId = post.documentId

            // Embedding CommentViewController in UINavigationController
            let navController = UINavigationController(rootViewController: commentVC)
            self.present(navController, animated: true, completion: nil)
        }
    }
    @IBAction func replyButton1(_ sender: Any) {
        navigateToReply1();
    }
    @IBAction func replyButton2(_ sender: Any) {
        navigateToReply2();
    }
    @IBAction func replyButton3(_ sender: Any) {
        navigateToReply3();
    }
    // Helper function to format Date object into a readable string
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    @IBAction func clickMore(_ sender: Any) {
        guard lastFetchPostCount == 3 else {
            // Display an alert when there are no more posts to load
            let alert = UIAlertController(title: "No More Posts", message: "No more posts to load.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }

        guard let lastDoc = lastDocumentSnapshot else {
            print("No more posts to load")
            return
        }

        // Push the current last document onto the stack
        documentSnapshotsStack.append(lastDoc)

        let visibilityOption = visibilityChip.selectedSegmentIndex == 0 ? "public" : "private"
        fetchPosts(visibility: visibilityOption, startAfterDocument: lastDoc)
    }

    @IBAction func clickBack(_ sender: Any) {
        guard !documentSnapshotsStack.isEmpty else {
            // Display an alert when there are no previous posts to load
            let alert = UIAlertController(title: "No Previous Posts", message: "You're at the first page of posts.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        // Pop the last document from the stack
        _ = documentSnapshotsStack.removeLast()

        // If stack is empty, load the first page
        if documentSnapshotsStack.isEmpty {
            fetchPosts(visibility: "public")
        } else {
            let previousDoc = documentSnapshotsStack.last
            let visibilityOption = visibilityChip.selectedSegmentIndex == 0 ? "public" : "private"
            fetchPosts(visibility: visibilityOption, startAfterDocument: previousDoc)
        }
    }
    
    @IBAction func post1Pressed(_ sender: Any) {
        presentPostViewController(forPost: posts[0])
    }

    @IBAction func post2Pressed(_ sender: Any) {
        presentPostViewController(forPost: posts[1])
    }

    @IBAction func post3Pressed(_ sender: Any) {
        presentPostViewController(forPost: posts[2])
    }

    func presentPostViewController(forPost post: Post) {
        db.collection("users").document(post.uid).getDocument { [weak self] (document, error) in
            if let error = error {
                print("Error fetching user: \(error)")
                return
            }

            guard let self = self, let document = document, document.exists else {
                print("Document does not exist")
                return
            }

            let username = document.data()?["username"] as? String ?? "Username not found"

            // Create and configure the PostViewController
            guard let postVC = self.storyboard?.instantiateViewController(withIdentifier: "postViewController") as? PostViewController else { return }
            
            // Pass data to PostViewController
            postVC.username = username
            postVC.journal = post.journal
            postVC.goal = post.aiGoal.isEmpty ? "No goal set" : post.aiGoal
            postVC.documentID = post.documentId
            postVC.uid = post.uid
            postVC.onDeleteSuccess = { [weak self] in
                self?.refreshPosts()
            }            // Set the presentation style
            postVC.modalPresentationStyle = .pageSheet
            postVC.modalTransitionStyle = .coverVertical

            // Present the PostViewController
            DispatchQueue.main.async {
                self.present(postVC, animated: true, completion: nil)
            }
        }
    }
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }

        let postIndex = sender.tag
        guard postIndex < posts.count else {
            print("Invalid post index")
            return
        }

        var post = posts[postIndex]

        // Add or remove the UID from the likes array
        if let likeIndex = post.likes.firstIndex(of: currentUserUID) {
            post.likes.remove(at: likeIndex)
        } else {
            post.likes.append(currentUserUID)
        }

        // Update Firestore
        db.collection("check-ins").document(post.documentId).updateData([
            "likes": post.likes
        ]) { [weak self] error in
            if let error = error {
                print("Error updating likes: \(error)")
            } else {
                print("Likes successfully updated")
                // Update the local post array
                self?.posts[postIndex] = post
                // Fetch usernames and update UI
                self?.fetchUsernamesAndUpdateUI(posts: self?.posts ?? [])
            }
        }
    }
    @IBAction func logoutTapped(_ sender: Any) {
        didTapLogout()
    }
    // MARK: - Selectors
    @objc private func didTapLogout() {
        AuthService.shared.signOut { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showLogoutError(on: self, with: error)
                return
            }
            
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
    }
}
