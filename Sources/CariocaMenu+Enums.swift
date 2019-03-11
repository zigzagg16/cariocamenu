import Foundation

///The boomerang types.
public enum BoomerangType: Int {
    ///The indicators will always return where they were let.
    case none = 0
	///The indicator will return always on the original edge.
	case horizontal = 1
    ///The indicator will return always on the original Y position. It may switch from Edge.
    case vertical = 2
    ///The indicator will always come back to it's original position
    case originalPosition = 3
}
