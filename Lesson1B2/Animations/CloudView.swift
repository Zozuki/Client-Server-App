//
//  CloudView.swift
//  Lesson1B2
//
//  Created by user on 11.05.2021.
//

import UIKit

class CloudView: UIView {

    let path = UIBezierPath()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    

        guard  let context = UIGraphicsGetCurrentContext() else {return}
        context.setStrokeColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        context.setFillColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        let x = 15
        let y = 450
        path.move(to: CGPoint(x: 165 + x , y: 75 + y))
        path.addLine(to: CGPoint(x: 235 + x, y: 75 + y))
        path.addCurve(to: CGPoint(x: 225 + x, y: 40 + y), controlPoint1: CGPoint(x: 265 + x, y: 60 + y), controlPoint2: CGPoint(x: 235 + x, y: 30 + y))
        path.addCurve(to: CGPoint(x: 180 + x, y: 30 + y), controlPoint1: CGPoint(x: 235 + x, y: 0 + y), controlPoint2: CGPoint(x: 175 + x, y: 0 + y))
        path.addCurve(to: CGPoint(x: 155 + x, y: 40 + y), controlPoint1: CGPoint(x: 180 + x, y: 20 + y), controlPoint2: CGPoint(x: 145 + x, y: 20 + y))
        path.addCurve(to: CGPoint(x: 165 + x, y: 75 + y), controlPoint1: CGPoint(x: 130 + x, y: 50 + y), controlPoint2: CGPoint(x: 145 + x, y: 75 + y))
        
//        path.move(to: CGPoint(x: 165 + x , y: 75 + y))
        path.addLine(to: CGPoint(x: 235 + x, y: 75 + y))
        path.addCurve(to: CGPoint(x: 225 + x, y: 40 + y), controlPoint1: CGPoint(x: 265 + x, y: 60 + y), controlPoint2: CGPoint(x: 235 + x, y: 30 + y))
        path.addCurve(to: CGPoint(x: 180 + x, y: 30 + y), controlPoint1: CGPoint(x: 235 + x, y: 0 + y), controlPoint2: CGPoint(x: 175 + x, y: 0 + y))
        path.addCurve(to: CGPoint(x: 155 + x, y: 40 + y), controlPoint1: CGPoint(x: 180 + x, y: 20 + y), controlPoint2: CGPoint(x: 145 + x, y: 20 + y))
        path.addCurve(to: CGPoint(x: 165 + x, y: 75 + y), controlPoint1: CGPoint(x: 130 + x, y: 50 + y), controlPoint2: CGPoint(x: 145 + x, y: 75 + y))
//
        path.fill()
        
        path.lineWidth = 3
        path.close()
        path.stroke()
    }
    
    
    func start() {
        
        path.lineWidth = 1
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        
        let animateLayer = CAShapeLayer()
        animateLayer.lineCap = CAShapeLayerLineCap.round;// Конец и начало линии будут заокругленными
        animateLayer.lineJoin = CAShapeLayerLineJoin.bevel;//Переход между линиями будет заоккругленный
        animateLayer.fillColor  = CGColor.init(gray: 0, alpha: 0)//сам слой будет прозрачный
        animateLayer.lineWidth  = 4
        animateLayer.strokeEnd  = 0.0
        animateLayer.strokeStart = 0
        animateLayer.path = path.cgPath
        animateLayer.strokeColor =  #colorLiteral(red: 0.589868784, green: 0.7395157218, blue: 1, alpha: 1).cgColor
        self.layer.addSublayer(animateLayer)
        animateLayer.strokeEnd  = 0.0
        
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 4
        pathAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        pathAnimation.fromValue = 0.05
        pathAnimation.toValue = 1.05
        pathAnimation.autoreverses = false
        
        animateLayer.add(pathAnimation, forKey: "strokeEndAnimation")
            

       
        let pathAnimation2 = CABasicAnimation(keyPath: "strokeStart")
        pathAnimation2.duration = 4
        pathAnimation2.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        pathAnimation2.fromValue = 0.0
        pathAnimation2.toValue = 1
        pathAnimation2.autoreverses = false;
        animateLayer.add(pathAnimation2, forKey: "strokeStartAnimation")
        
   
    }
}
