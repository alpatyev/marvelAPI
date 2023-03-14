import Foundation

// MARK: - Specific character data

struct SpecificCharacterModel: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let modified: String?
    let thumbnail: CharacterImage?
    let resourceURI: String?
    let comics: Container?
    let series: Container?
    let stories: Container?
    let events: Container?
    var imageData: Data?
}

// MARK: - All specific properties container for this character

struct Container: Decodable {
    let items: [Item]
}

// MARK: - Specific item for this character

struct Item: Decodable {
    let name: String
}

// MARK: - Model as description

final class CharacterInfo {
    
    var categories = [String]() 
    var descriptions = [String]()
    
    init(using model: SpecificCharacterModel) {
        createTextualRepresentation(from: model)
    }
    
    private func createTextualRepresentation(from characterModel: SpecificCharacterModel?) {
        guard let model = characterModel else { return }
        var infoLine = "ABOUT.."
        categories.append(infoLine)
        
        if let id = model.id {
            infoLine += "\n\n#️⃣ ID: [\(id)]"
        }
        if let description = model.description, description != "" {
            infoLine += "\n\n✨ \(description) "
        }
        if let date = model.modified, date != "" {
            infoLine += "\n\n💾 MODIFIED: \(date)"
        }
        if let url = model.resourceURI, url != "" {
            infoLine += "\n\n🔗URL: \(url)"
        }
        descriptions.append(infoLine)
        
        createLineFor(data: model.comics, named: "COMICS ⭐️")
        createLineFor(data: model.series, named: "SERIES 📺")
        createLineFor(data: model.stories, named: "STORIES 💭")
        createLineFor(data: model.events, named: "EVENTS 👤")
    }
    
    private func createLineFor(data: Container?, named: String) {
        guard let property = data, property.items.count > 0 else { return }
        categories.append("\(named)\n")
        var summaryLine = named
        for (index, item) in property.items.enumerated() {
            summaryLine += "\n\(index + 1). \(item.name)"
        }
        descriptions.append(summaryLine)
    }
}
