import SwiftUI

struct Profile: Equatable {
    let firstName: String
    let lastName: String
    let avatarData: Data?
    
    var avatar: Image {
        if let data = avatarData, let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "person.crop.circle")
        }
    }
    
    static func isValid(_ profile: Profile) -> Bool {
        !profile.firstName.isEmpty &&
        !profile.lastName.isEmpty &&
        profile.avatarData != nil
    }
    
    static let placeholder: Self = .init(
        firstName: "",
        lastName: "",
        avatarData: nil
    )
}
