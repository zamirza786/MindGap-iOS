import Foundation

/// Manages loading and saving reflection entries to a local JSON file.
@MainActor
final class DataManager: ObservableObject {
    
    /// The user's saved reflection entries, published for SwiftUI views.
    @Published var reflections: [ReflectionEntry] = []

    /// Singleton instance for global access.
    static let shared = DataManager()

    private let fileManager = FileManager.default
    private var dataFileURL: URL {
        documentsDirectory.appendingPathComponent("reflections.json")
    }
    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    private init() {
        loadReflections()
    }

    /// Loads reflections from the JSON file in the documents directory.
    func loadReflections() {
        // Check if the file exists. If not, there's nothing to load.
        guard fileManager.fileExists(atPath: dataFileURL.path) else {
            self.reflections = []
            return
        }

        // Read the data from the file.
        do {
            let data = try Data(contentsOf: dataFileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let entries = try decoder.decode([ReflectionEntry].self, from: data)
            self.reflections = entries.sorted(by: { $0.date > $1.date })
        } catch {
            print("Error loading reflections: \(error.localizedDescription)")
            // If loading fails, reset to an empty array.
            self.reflections = []
        }
    }

    /// Saves a single reflection entry.
    ///
    /// This method adds the new entry and then saves the entire array to the JSON file.
    /// It ensures that there is only one entry per day by removing any existing entry for the same day.
    func saveReflection(_ entry: ReflectionEntry) {
        // Remove any existing entry for the same day to avoid duplicates.
        reflections.removeAll { Calendar.current.isDate($0.date, inSameDayAs: entry.date) }
        
        // Add the new entry and sort the reflections array.
        reflections.append(entry)
        reflections.sort(by: { $0.date > $1.date })

        // Save the updated array to the file.
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(reflections)
            try data.write(to: dataFileURL, options: [.atomic, .completeFileProtection])
        } catch {
            print("Error saving reflections: \(error.localizedDescription)")
        }
    }
}
