import Foundation
import StoreKit
import Combine

// Define a type alias for the transaction listener to simplify its usage.
typealias TransactionUpdateListener = Task<Void, Error>

/// A manager for handling StoreKit 2 interactions, including fetching products and processing purchases.
@MainActor
final class StoreKitManager: ObservableObject {

    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs: Set<String> = []

    private var transactionListener: TransactionUpdateListener? = nil
    
    // The product identifiers for your in-app purchases.
    // Replace these with your actual product IDs from App Store Connect.
    private let productIds = ["com.yourapp.premiumunlock"]

    init() {
        // Start a transaction listener as soon as the manager is initialized.
        transactionListener = configureTransactionListener()
        
        // Asynchronously load products.
        Task {
            await loadProducts()
            await updatePurchasedProducts()
        }
    }
    
    deinit {
        // Stop listening for transactions when the object is deallocated.
        transactionListener?.cancel()
    }

    /// Sets up a listener to handle transaction updates from the App Store.
    private func configureTransactionListener() -> TransactionUpdateListener {
        Task.detached(priority: .background) {
            for await result in Transaction.updates {
                await self.handleTransaction(result)
            }
        }
    }

    /// Fetches product information from the App Store.
    private func loadProducts() async {
        do {
            let storeProducts = try await Product.products(for: productIds)
            self.products = storeProducts
            print("Successfully loaded \(storeProducts.count) products.")
        } catch {
            print("Failed to load products: \(error)")
        }
    }

    /// Initiates the purchase process for a given product.
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            print("Purchase successful, handling transaction...")
            await handleTransaction(verification)
        case .userCancelled:
            print("Purchase cancelled by user.")
        case .pending:
            print("Purchase is pending.")
        @unknown default:
            print("An unknown purchase error occurred.")
        }
    }

    /// Processes a transaction verification result.
    private func handleTransaction(_ verificationResult: VerificationResult<Transaction>) async {
        switch verificationResult {
        case .verified(let transaction):
            // Transaction is verified. Unlock content and finish the transaction.
            print("Transaction verified for product: \(transaction.productID)")
            await self.updatePurchasedProducts()
            await transaction.finish()
        case .unverified(let transaction, let error):
            // Transaction could not be verified. Do not unlock content.
            print("Transaction unverified for product: \(transaction.productID). Error: \(error)")
        }
    }
    
    /// Updates the set of purchased product IDs by checking the latest transaction data.
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else { continue }
            
            // Check if the product is a consumable or a non-renewing subscription.
            // For this app, we assume a non-consumable "premium unlock".
            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }
        print("Updated purchased products: \(self.purchasedProductIDs)")
    }
}
