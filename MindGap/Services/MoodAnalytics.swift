import Foundation

/// A service providing analytics functions for mood trends.
struct MoodAnalytics {

    /// A summary of mood distribution over a set of reflection entries.
    struct MoodSummary {
        let happyPercentage: Double
        let neutralPercentage: Double
        let sadPercentage: Double
        let totalEntries: Int
        
        var dominantMood: ReflectionEntry.Mood? {
            let percentages = [
                (ReflectionEntry.Mood.happy, happyPercentage),
                (ReflectionEntry.Mood.neutral, neutralPercentage),
                (ReflectionEntry.Mood.sad, sadPercentage)
            ]
            // Find the mood with the highest percentage, ensuring it's greater than 0.
            let maxMood = percentages.max(by: { $0.1 < $1.1 })
            return (maxMood?.1 ?? 0) > 0 ? maxMood?.0 : nil
        }
    }

    /// Calculates the mood distribution for a given list of reflection entries.
    /// - Parameter reflections: An array of `ReflectionEntry` to analyze.
    /// - Returns: A `MoodSummary` containing the percentage of each mood.
    static func generateSummary(for reflections: [ReflectionEntry]) -> MoodSummary {
        let total = reflections.count
        guard total > 0 else {
            return MoodSummary(happyPercentage: 0, neutralPercentage: 0, sadPercentage: 0, totalEntries: 0)
        }

        // Count occurrences of each mood.
        let moodCounts = reflections.reduce(into: [ReflectionEntry.Mood: Int]()) { counts, entry in
            counts[entry.mood, default: 0] += 1
        }

        // Calculate percentages.
        let happyCount = moodCounts[.happy] ?? 0
        let neutralCount = moodCounts[.neutral] ?? 0
        let sadCount = moodCounts[.sad] ?? 0

        let happyPercentage = (Double(happyCount) / Double(total)) * 100
        let neutralPercentage = (Double(neutralCount) / Double(total)) * 100
        let sadPercentage = (Double(sadCount) / Double(total)) * 100

        return MoodSummary(
            happyPercentage: happyPercentage,
            neutralPercentage: neutralPercentage,
            sadPercentage: sadPercentage,
            totalEntries: total
        )
    }
}
