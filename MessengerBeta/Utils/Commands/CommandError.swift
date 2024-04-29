import Foundation

enum CommandError: Error{
    case missingParameter
    case regexFailed
    case paramInvalidType(String)
}
