import UIKit

extension Double {
    
    func convertCalories() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        guard let caloriesText = formatter.string(for: self) else { return "Error" }
        return caloriesText + " cal"
    }
}

extension Int {
    
    func convertTime() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        let hours = self / 60
        let remainingMinutes = self % 60
        let minutesString = remainingMinutes == 0 ? "" : "\(remainingMinutes)min"
        return self > 60 ? "\(hours)h \(minutesString)" : "\(self)min"
    }
}

extension UIViewController {
    
    func imageRequest(image: String, completion: @escaping (Data) -> Void) {
        let imageService = RecipeImageService()
        imageService.request(image: image) { [weak self] result in
            switch result {
            case let .success(data):
                completion(data)
            case .failure:
                self?.presentAlert(message: "Something happened wrong. Please try later.")
            }
        }
    }
}
