
// MARK: - Common models

struct MarvelResponseModel<DataModel: Decodable>: Decodable {
    let data: DataModel
}

struct MarvelDataModel<Container: Decodable>: Decodable {
    let results: [Container]
}
