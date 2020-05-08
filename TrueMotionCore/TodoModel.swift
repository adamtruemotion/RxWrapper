import Foundation

public struct TodoReponseModel: Codable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}
