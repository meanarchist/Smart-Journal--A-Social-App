//
//  ChatGPTManager.swift
//  FPF23
//


import UIKit
import Foundation

class ChatGPTManager: NSObject {

    // Singleton instance
    static let shared = ChatGPTManager()

    // Function to interact with OpenAI API
    func generateGoal(from journalText: String, withPrompt promptMessage: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Construct the URL for the OpenAI Chat Completions API
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!

        // Construct the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // Securely set your API Key here
        request.addValue("Bearer API_KEY_HERE", forHTTPHeaderField: "Authorization")

        // Define the body of the request with messages array
        let requestBody: [String: Any] = [
            "model": "gpt-3.5-turbo",  // Specify the model you are using
            "messages": [
                ["role": "system", "content": "You are a helpful assistant."],
                ["role": "user", "content": "\(promptMessage) \(journalText)"]
            ]
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch let error {
            completion(.failure(error))
            return
        }

        // Perform the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            // Parse the result and return it
            do {
                let responseDict = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                if let choices = responseDict?["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    completion(.success(content))
                } else {
                    completion(.failure(URLError(.cannotParseResponse)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

}
