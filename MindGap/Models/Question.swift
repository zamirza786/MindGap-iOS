import Foundation

/// Represents a single question loaded from the JSON resource.
struct Question: Codable, Identifiable, Hashable {
    var id = UUID()
    let text: String
    let category: String

    // Conform to Codable by specifying coding keys, mapping "id" to a property that isn't in the JSON.
    enum CodingKeys: String, CodingKey {
        case text
        case category
    }
}