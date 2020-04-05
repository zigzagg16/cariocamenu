import UIKit

class CustomPolygonIndicator: UIView, CariocaIndicatorConfiguration {
    public func iconMargins(for _: UIRectEdge) -> (top: CGFloat, right: CGFloat, bottom: CGFloat, left: CGFloat) {
        return (top: 0.0, right: 0.0, bottom: 0.0, left: 0.0)
    }

    var size: CGSize = CGSize(width: 50, height: 50)

    func shape(for _: UIRectEdge, frame: CGRect) -> UIBezierPath {
        let polygonPath = UIBezierPath()
        polygonPath.move(to: CGPoint(x: frame.minX + 0.50500 * frame.width, y: frame.minY + 0.01000 * frame.height))
        polygonPath.addLine(to: CGPoint(x: frame.minX + 0.79595 * frame.width, y: frame.minY + 0.10454 * frame.height))
        polygonPath.addLine(to: CGPoint(x: frame.minX + 0.97577 * frame.width, y: frame.minY + 0.35204 * frame.height))
        polygonPath.addLine(to: CGPoint(x: frame.minX + 0.97577 * frame.width, y: frame.minY + 0.65796 * frame.height))
        polygonPath.addLine(to: CGPoint(x: frame.minX + 0.79595 * frame.width, y: frame.minY + 0.90546 * frame.height))
        polygonPath.addLine(to: CGPoint(x: frame.minX + 0.50500 * frame.width, y: frame.minY + 1.00000 * frame.height))
        polygonPath.addLine(to: CGPoint(x: frame.minX + 0.21405 * frame.width, y: frame.minY + 0.90546 * frame.height))
        polygonPath.addLine(to: CGPoint(x: frame.minX + 0.03423 * frame.width, y: frame.minY + 0.65796 * frame.height))
        polygonPath.addLine(to: CGPoint(x: frame.minX + 0.03423 * frame.width, y: frame.minY + 0.35204 * frame.height))
        polygonPath.addLine(to: CGPoint(x: frame.minX + 0.21405 * frame.width, y: frame.minY + 0.10454 * frame.height))
        polygonPath.close()
        UIColor(red: 0.63, green: 0.76, blue: 0.22, alpha: 1.00).setFill()
        polygonPath.fill()
        return polygonPath
    }
}
