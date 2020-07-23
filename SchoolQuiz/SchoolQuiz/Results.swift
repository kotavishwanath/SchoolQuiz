
import Foundation
struct Results : Codable {
	let category : String?
	let type : String?
	let difficulty : String?
	let question : String?
	let correct_answer : String?
	let incorrect_answers : [String]?

	enum CodingKeys: String, CodingKey {

		case category = "category"
		case type = "type"
		case difficulty = "difficulty"
		case question = "question"
		case correct_answer = "correct_answer"
		case incorrect_answers = "incorrect_answers"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		category = try values.decodeIfPresent(String.self, forKey: .category)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		difficulty = try values.decodeIfPresent(String.self, forKey: .difficulty)
		question = try values.decodeIfPresent(String.self, forKey: .question)
		correct_answer = try values.decodeIfPresent(String.self, forKey: .correct_answer)
		incorrect_answers = try values.decodeIfPresent([String].self, forKey: .incorrect_answers)
	}

}
