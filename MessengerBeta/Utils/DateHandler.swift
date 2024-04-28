import Foundation

public class DateHandler {
    private static var dateFormatter = createDateFormatter()
    private static var timeFormatter = createTimeFormatter()
    private static var dateTimeFormatter = createDateTimeFormatter()
    
    static func formatDate(_ unixTimestamp: Int)-> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: Double(unixTimestamp)))
    }
    
    static func formatTime(_ unixTimestamp: Int, lang: String)-> String {
        return timeFormatter.string(from: Date(timeIntervalSince1970: Double(unixTimestamp)))
    }
    
    static func formatBoth(_ unixTimestamp: Int, lang: String)-> String {
        return dateTimeFormatter.string(from: Date(timeIntervalSince1970: Double(unixTimestamp)))
    }
    
    private static func createDateFormatter()-> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        return formatter
    }
    
    private static func createTimeFormatter()-> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        return formatter
    }
    
    private static func createDateTimeFormatter()-> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        return formatter
    }
}
