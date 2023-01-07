import UIKit
extension Double {
    
    func convertCalories() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        guard let caloriesText = formatter.string(for: self) else { return "Error" }
        return caloriesText + " cal"
    }
    
    
}
extension UIViewController {
    
    func convertCalories(calories: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        guard let caloriesText = formatter.string(for: calories) else { return "Error" }
        return caloriesText + " cal"
    }
    
    func convertTime(time: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        let hours = time / 60
        let remainingMinutes = time % 60
        let minutesString = remainingMinutes == 0 ? "" : "\(remainingMinutes)min"
        return time > 60 ? "\(hours)h \(minutesString)" : "\(time)min"
    }
    
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
