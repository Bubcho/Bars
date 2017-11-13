import Foundation


struct Resource<T> {
	let url: URL
	let parse: (Data) -> T?
}
