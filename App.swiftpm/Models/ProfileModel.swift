import SwiftUI

struct Profile: Equatable {
    let firstName: String
    let lastName: String
    let avatar: Image
    
    static func isValid(_ profile: Profile) -> Bool {
        !profile.firstName.isEmpty &&
        !profile.lastName.isEmpty &&
        profile.avatar != self.placeholder.avatar
    }
    
    static let placeholder: Self = .init(
        firstName: "",
        lastName: "",
        avatar: Image(systemName: "person.crop.circle")
    )
}
