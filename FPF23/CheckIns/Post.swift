import Foundation
import FirebaseFirestore
struct Post {
    var uid: String
    var dateTime: Date
    var journal: String
    var emotion: String
    var likes: [String]
    var documentId: String
    var aiGoal: String

    init(dictionary: [String: Any], documentId: String) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.dateTime = (dictionary["dateTime"] as? Timestamp)?.dateValue() ?? Date()
        self.journal = dictionary["journal"] as? String ?? ""
        self.emotion = dictionary["emotion"] as? String ?? "okay"
        self.likes = dictionary["likes"] as? [String] ?? []
        self.documentId = documentId
        self.aiGoal = dictionary["aiGoal"] as? String ?? ""
    }
}
