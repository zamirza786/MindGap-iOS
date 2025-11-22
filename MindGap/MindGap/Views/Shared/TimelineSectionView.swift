import SwiftUI

struct TimelineSectionView: View {
    let timeline: [TimelineEvent]

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            Text("Timeline")
                .appFont(style: .headline)
                .padding(.horizontal)

            if timeline.isEmpty {
                Text("No events yet.")
                    .appFont(style: .body)
                    .foregroundColor(AppColors.textSecondary)
                    .padding(.horizontal)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: AppSpacing.medium) {
                        ForEach(timeline) { event in
                            TimelineItemView(event: event)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct TimelineItemView: View {
    let event: TimelineEvent

    var body: some View {
        VStack(spacing: AppSpacing.small) {
            // Icon
            Image(systemName: event.icon)
                .font(.title2)
                .foregroundColor(AppColors.accent)
                .frame(width: 50, height: 50)
                .background(AppColors.accent.opacity(0.1))
                .clipShape(Circle())
            
            // Description
            Text(event.description)
                .appFont(style: .caption)
                .multilineTextAlignment(.center)
                .frame(width: 100)
            
            // Date
            Text(event.date.formatted(date: .abbreviated, time: .omitted))
                .appFont(style: .caption2)
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(.vertical)
    }
}

struct TimelineSectionView_Previews: PreviewProvider {
    static let sampleTimeline: [TimelineEvent] = [
        TimelineEvent(date: Date().addingTimeInterval(-86400 * 5), description: "Goal Created", icon: "flag.fill"),
        TimelineEvent(date: Date().addingTimeInterval(-86400 * 3), description: "Milestone: 'Initial Research' Completed", icon: "checkmark.circle.fill"),
        TimelineEvent(date: Date().addingTimeInterval(-86400 * 1), description: "Progress updated to 50%", icon: "chart.bar.fill"),
    ]

    static var previews: some View {
        TimelineSectionView(timeline: sampleTimeline)
            .padding()
            .background(AppColors.background)
    }
}
