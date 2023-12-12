//
//  CheckInViewController.swift
//  FPF23
//
//  Created by Chase Yano on 11/16/23.
//

import UIKit
import Firebase
import FirebaseFirestore

class CheckInViewController: UIViewController {



    @IBOutlet weak var greatButton: UIButton!
    
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var okayButton: UIButton!
    @IBOutlet weak var badButton: UIButton!
    
    @IBOutlet weak var awfulButton: UIButton!

    let db = Firestore.firestore()
    let dateFormatter = DateFormatter()
    var documentID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonTags()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH:mm:ss"

    }

    func setupButtonTags() {
        greatButton.tag = 0
        goodButton.tag = 1
        okayButton.tag = 2
        badButton.tag = 3
        awfulButton.tag = 4
    }

    @IBAction func emotionButtonPressed(_ sender: UIButton) {
        let emotions = ["great", "good", "okay", "bad", "awful"]
        let selectedEmotion = emotions[sender.tag]
        print("PRESSED!")
        guard let uid = Auth.auth().currentUser?.uid else { return }

        updateFirestoreWithEmotion(uid: uid, emotion: selectedEmotion) { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.navigateToJournalViewController()
                }
            } else {
                print("Error updating Firestore")
                // Handle error here
            }
        }
    }

    func updateFirestoreWithEmotion(uid: String, emotion: String, completion: @escaping (Bool) -> Void) {
        documentID = UUID().uuidString // Generate a UUID

        let entryRef = db.collection("check-ins").document(documentID ?? "")
        // Initialize the likes array with the current user's UID
        let likesArray = [uid]
        let commentsArray: [[String: String]] = [
           

        ]

        entryRef.setData([
            "dateTime": Timestamp(date: Date()),
            "emotion": emotion,
            "uid": uid, // Store the UID as a field within the document
            "likes": likesArray,
            "comments": commentsArray
        ]) { error in
            if let error = error {
                print("Error writing entry: \(error)")
                completion(false)
            } else {
                print("Entry successfully written with document ID: \(String(describing: self.documentID))")
                completion(true)
            }
        }
    }


    func addEntryToCheckIn(entryRef: DocumentReference, emotion: String, uid: String, likes: [String], comments: [String], completion: @escaping (Bool) -> Void) {
        entryRef.setData([
            "dateTime": Timestamp(date: Date()),
            "emotion": emotion,
            "uid": uid,
            "likes": likes,
            "comments": comments
        ], merge: true) { error in
            if let error = error {
                print("Error writing entry: \(error)")
                completion(false)
            } else {
                print("Entry successfully written!")
                completion(true)
            }
        }
    }



    func navigateToJournalViewController() {
        if let journalVC = storyboard?.instantiateViewController(withIdentifier: "journalViewController") as? JournalViewController {
            journalVC.documentID = documentID  // Pass the documentID
            self.navigationController?.pushViewController(journalVC, animated: true)
        }
    }
}
