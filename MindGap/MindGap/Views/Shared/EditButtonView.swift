import SwiftUI

struct EditButtonView: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "pencil")
                Text("Edit Goal")
            }
        }
        .buttonStyle(AppButtonStyle(style: .primary()))
    }
}

struct EditButtonView_Previews: PreviewProvider {
    static var previews: some View {
        EditButtonView(action: { print("Edit tapped") })
            .padding()
            .background(AppColors.background)
    }
}
