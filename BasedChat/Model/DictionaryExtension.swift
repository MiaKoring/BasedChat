import Foundation

extension Dictionary where Value: Equatable {
    func keys(forValue value: Value)-> [Key] {
        return compactMap{ (key, element) in
            return element == value ? key : nil
        }
    }
}
