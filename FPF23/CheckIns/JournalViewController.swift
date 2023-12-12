import UIKit
import Firebase
import FirebaseFirestore

class JournalViewController: UIViewController {

    @IBOutlet weak var journalTextView: UITextView!
    var documentID: String?

    var isAIGoalSet = false
    let db = Firestore.firestore()
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        journalTextView.text = "" // Clear the text view
        dateFormatter.dateFormat = "yyyy-MM-dd_HH:mm:ss"
    }
    func isJournalEmpty() -> Bool {
        return journalTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    @IBAction func privatePost(_ sender: Any) {
        if !isAIGoalSet {
            presentAIGoalRequirementAlert()
            return
        }
        
        if isJournalEmpty() {
            presentAlert(message: "You must write something to post.")
            return
        }
        saveJournalEntry(visibility: "private") {
            self.navigateToHomePage()
        }
    }



    @IBAction func publicPost(_ sender: Any) {
        if !isAIGoalSet {
            presentAIGoalRequirementAlert()
            return
        }
        
        if isJournalEmpty() {
            presentAlert(message: "You must write something to post.")
            return
        }
        saveJournalEntry(visibility: "public") {
            self.navigateToHomePage()
        }
    }
    func presentAIGoalRequirementAlert() {
        let alert = UIAlertController(title: "AI Goal Required", message: "Please generate an AI goal before posting.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func presentAlert(message: String) {
        let alert = UIAlertController(title: "Empty Journal Entry", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

    func saveJournalEntry(visibility: String, completion: @escaping () -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("NO UID!")
            return
        }

        let entryRef: DocumentReference

        if let docID = documentID {
            // Use the passed documentID if available
            entryRef = db.collection("check-ins").document(docID)
        } else {
            // Otherwise, create a new documentID
            let newDocumentID = UUID().uuidString // Generate a UUID

            entryRef = db.collection("check-ins").document(newDocumentID)
        }

        let journalContent = journalTextView.text ?? ""

        // Save or update the journal entry
        entryRef.setData([
            "journal": journalContent,
            "visibility": visibility,
            // other fields...
        ], merge: true) { error in
            if let error = error {
                print("Error saving entry: \(error)")
            } else {
                print("Entry successfully saved/updated!")
                completion()
            }
        }
    }

    
    @IBAction func generateAIGoalButtonTapped(_ sender: Any) {
        guard let journalText = journalTextView.text, !journalText.isEmpty else {
                // Handle the empty text state appropriately
                return
            }

            // Define the prompt message that guides the AI
            let promptMessage = "Write a goal for our SmartJournal app based off of the following journal Entry. This goal should include a difficulty level  from (1,2.3,4,5) formatted like Title (first line) ,Difficulty Level: X (second line)  as well as a 2-3 sentence response giving tangible advice on how to move forward given the entry (third line on)."

            // Call the ChatGPTManager to generate the goal
            ChatGPTManager.shared.generateGoal(from: journalText, withPrompt: promptMessage) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let generatedGoal):
                        // Update Firestore with the generated goal
                        self?.updateAIGoalField(generatedGoal)
                    case .failure(let error):
                        // Handle the error appropriately
                        print(error.localizedDescription)
                    }
                }
            }
    }
    
    func updateAIGoalField(_ generatedGoal: String) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("NO UID!")
            return
        }
        let entryRef: DocumentReference

        if let docID = documentID {
            // Use the passed documentID if available
            entryRef = db.collection("check-ins").document(docID)
        } else {
            // Otherwise, create a new documentID
            let newDocumentID = UUID().uuidString // Generate a UUID

            entryRef = db.collection("check-ins").document(newDocumentID)
        }
        entryRef.updateData([
            "aiGoal": generatedGoal
        ]) { [weak self] error in
            if let error = error {
                print("Error updating AI goal: \(error)")
            } else {
                print("AI goal successfully updated.")
                self?.isAIGoalSet = true // Update the flag
                DispatchQueue.main.async {
                    self?.presentAIGoalAlert(generatedGoal)
                }
            }
        }
    }

    func presentAIGoalAlert(_ goal: String) {
        let alert = UIAlertController(title: "AI Generated Goal", message: goal, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    func navigateToHomePage() {
        if let homePageVC = storyboard?.instantiateViewController(withIdentifier: "homePageViewController") as? HomePageViewController {
            self.navigationController?.pushViewController(homePageVC, animated: true)
        }
    }
}
