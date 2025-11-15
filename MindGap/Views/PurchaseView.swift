import SwiftUI
import StoreKit

/// A view dedicated to presenting premium features and handling the purchase flow.
struct PurchaseView: View {
    
    @StateObject private var storeKitManager = StoreKitManager()
    @EnvironmentObject private var premiumManager: PremiumManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var isPurchasing = false
    @State private var errorAlert: ErrorAlert? = nil

    var body: some View {
        VStack(spacing: 20) {
            Text("Unlock Premium")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            featureList
            
            Spacer()
            
            if let product = storeKitManager.products.first {
                purchaseButton(for: product)
            } else {
                Text("Loading offers...")
                    .font(.headline)
            }
            
            restorePurchaseButton
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background.ignoresSafeArea())
        .alert(item: $errorAlert) { alert in
            Alert(title: Text(alert.title), message: Text(alert.message), dismissButton: .default(Text("OK")))
        }
    }
    
    /// A list of premium features.
    private var featureList: some View {
        VStack(alignment: .leading, spacing: 15) {
            featureRow(icon: "chart.xyaxis.line", text: "See full mood analytics and trends over time.")
            featureRow(icon: "paintbrush.fill", text: "Unlock exclusive theme packs to customize your journal.")
            featureRow(icon: "icloud.fill", text: "Automatically sync your reflections with iCloud.")
            featureRow(icon: "square.and.arrow.up.fill", text: "Export your journal entries to PDF or text.")
        }
    }
    
    private func featureRow(icon: String, text: String) -> some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(AppColors.accent)
                .frame(width: 30)
            Text(text)
                .font(.body)
        }
    }
    
    /// The main button to purchase a product.
    private func purchaseButton(for product: Product) -> some View {
        Button(action: {
            Task { await purchase(product) }
        }) {
            if isPurchasing {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else {
                VStack {
                    Text("Unlock Now")
                        .font(.headline)
                    Text(product.displayPrice)
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(AppColors.accent)
        .foregroundStyle(.white)
        .clipShape(Capsule())
        .disabled(isPurchasing)
    }
    
    /// A button to allow users to restore their previous purchases.
    private var restorePurchaseButton: some View {
        Button(action: {
            Task {
                try? await AppStore.sync()
                await storeKitManager.updatePurchasedProducts()
                if storeKitManager.purchasedProductIDs.contains(storeKitManager.products.first?.id ?? "") {
                    premiumManager.unlockPremium()
                    dismiss()
                }
            }
        }) {
            Text("Restore Purchases")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
    
    /// The function that handles the purchase logic.
    private func purchase(_ product: Product) async {
        isPurchasing = true
        do {
            try await storeKitManager.purchase(product)
            // On successful purchase, the transaction listener will update the state.
            // We check if the purchase was successful and then dismiss the view.
            if storeKitManager.purchasedProductIDs.contains(product.id) {
                premiumManager.unlockPremium()
                dismiss()
            }
        } catch {
            errorAlert = ErrorAlert(message: "Purchase failed. Please try again.")
            print("Purchase failed with error: \(error)")
        }
        isPurchasing = false
    }
}

/// A simple struct to hold alert information.
struct ErrorAlert: Identifiable {
    var id = UUID()
    var title: String = "Error"
    var message: String
}

#Preview {
    PurchaseView()
        .environmentObject(PremiumManager())
}
