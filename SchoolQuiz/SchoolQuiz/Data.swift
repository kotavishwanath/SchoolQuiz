
import Foundation
struct Data : Codable {
	let response_code : Int?
	let results : [Results]?

	enum CodingKeys: String, CodingKey {

		case response_code = "response_code"
		case results = "results"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		response_code = try values.decodeIfPresent(Int.self, forKey: .response_code)
		results = try values.decodeIfPresent([Results].self, forKey: .results)
	}

}
