import Foundation

public struct TodoModel: Decodable {
    public let id: Int
    public let title: String
    public let completed: Bool
}
