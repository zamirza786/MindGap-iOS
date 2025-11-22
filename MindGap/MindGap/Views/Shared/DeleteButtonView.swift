import SwiftUI

struct DeleteButtonView: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "trash.fill")
                Text("Delete Goal")
            }
        }
        .buttonStyle(AppButtonStyle(style: .destructive))
    }
}

struct DeleteButtonView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteButtonView(action: { print("Delete tapped") })
            .padding()
            .background(AppColors.background)
    }
}
