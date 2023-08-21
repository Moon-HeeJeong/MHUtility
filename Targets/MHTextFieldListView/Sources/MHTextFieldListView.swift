import Foundation
import UIKit
import RxSwift

public protocol MHTextFieldListViewProtocol: AnyObject{
    associatedtype T: MHTextFieldListViewKindRequiresEnum
    
//    var textBtns: [T.RawValue : UIButton] {get set}
//    var textKinds: [T] {get set}
    var textFieldListTapped: ((_ tag: T?)->())? {get set}
}

extension MHTextFieldListViewProtocol{
    public func setTextFieldListTapped(closure: @escaping (_ tag: T?)->()){
        self.textFieldListTapped = closure
    }
}

public protocol MHTextFieldListViewKindRequiresEnum: RawRepresentable where RawValue == String{
//    var text: String {get}
}

public class MHTextFieldListView<T: MHTextFieldListViewKindRequiresEnum>: UIView, MHTextFieldListViewProtocol{

    public var textFieldListTapped: ((_ tag: T?)->())?
    
    private var _scrollview: UIScrollView!
    private let _leftMaigin: CGFloat
    private let _elementHeight: CGFloat
    private let _textAligment: UIControl.ContentHorizontalAlignment
    
    private let _maxRowCount: Int
    private let _textColor: UIColor
    
    private var _placeholderLabel: UILabel!
    
    public var textBtns: [T.RawValue : UIButton] = [:]
    
    public var isShow: Bool = false{
        didSet{
            if self.isShow{
                self.show()
            }else{
                self.hide()
            }
        }
    }
    
    public var textKinds: [T]?{
        didSet{
            guard let textKinds = textKinds else {
                return
            }

            self.addTexts(textKinds: textKinds, textColor: self._textColor)
        }
    }
    
    private var _originHeight: CGFloat {
        self._elementHeight*(CGFloat(min(self.textKinds?.count ?? 0, self._maxRowCount))+0.5)
    }
    
    
    public init(frame: CGRect, elementHeight: CGFloat, borderColor: UIColor, textColor: UIColor, leftMargin: CGFloat, maxRowCount: Int = 4, textAlignment: UIControl.ContentHorizontalAlignment, placeholder: String?){

        self._elementHeight = elementHeight
        self._leftMaigin = leftMargin
        self._maxRowCount = maxRowCount
        self._textAligment = textAlignment
        self._textColor = textColor
        
        super.init(frame: frame)
        
        let byRoundingCorners: UIRectCorner = [.bottomLeft, .bottomRight]
        self.addRoundSpecificedCorners(cornerRadius: 10, byRoundingCorners: byRoundingCorners, boderColor: borderColor, boderWidth: 1)
        
        self._scrollview = UIScrollView(frame: CGRect(origin: .zero, size: CGSize(width: self.frame.size.width, height: self.frame.size.height)))
        self._scrollview.addRoundSpecificedCorners(cornerRadius: 10, byRoundingCorners: byRoundingCorners, boderColor: borderColor, boderWidth: 1)
        self.addSubview(self._scrollview)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addTexts(textKinds: [T], textColor: UIColor){
        
        self.removeAllBtns()
        
        let btnWidth = self.frame.size.width
        let btnHeight = self._elementHeight
        
        self.textBtns = {
            var textBtns = [T.RawValue : UIButton]()
            for i in 0..<textKinds.count{
                let data = textKinds[i]
                let btn = UIButton(frame: CGRect(origin: CGPoint(x: self._leftMaigin, y: btnHeight*CGFloat(i)), size: CGSize(width: btnWidth-self._leftMaigin*2, height: btnHeight)))
                btn.titleLabel?.numberOfLines = 0
//                btn.setTitle(textKinds[i].rawValue, for: .normal)
                btn.setTitle(textKinds[i].rawValue, for: .normal)
                btn.setTitleColor(textColor, for: .normal)
                btn.contentHorizontalAlignment = self._textAligment
                btn.addTarget(self, action: #selector(btnCallback(sender:)), for: .touchUpInside)
                self._scrollview.addSubview(btn)
                self._scrollview.contentSize.height = btn.frame.origin.y + btn.frame.size.height //btn end pos y
                textBtns[data.rawValue] = btn
            }
            return textBtns
        }()
    }
    
    private func removeAllBtns(){
        for btn in self.textBtns{
            btn.value.removeFromSuperview()
        }
        self.textBtns.removeAll()
    }
    
    private func show(){
        self.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.frame.size.height = self._originHeight
            self._scrollview.frame.size.height = self.frame.size.height
        } completion: { _ in
        }
    }
    
    private func hide(){
        UIView.animate(withDuration: 0.3) {
            self.frame.size.height = 0
        } completion: { _ in
            self.isHidden = true
        }

    }
    
    @objc fileprivate func btnCallback(sender: UIButton){
        let tag = T(rawValue: sender.titleLabel?.text ?? "")
        self.textFieldListTapped?(tag)
    }
}


extension UIView{
    public func addRoundSpecificedCorners(cornerRadius: CGFloat, byRoundingCorners: UIRectCorner, boderColor: UIColor = .clear, boderWidth: CGFloat = 1.5) {
        clipsToBounds = true
        if #available(iOS 11.0, *) {
            
            layer.cornerRadius = cornerRadius
            layer.borderColor = boderColor.cgColor
            layer.borderWidth = boderWidth
            layer.maskedCorners = CACornerMask(rawValue: byRoundingCorners.rawValue)
        } else {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: byRoundingCorners,
                                    cornerRadii: CGSize(width:cornerRadius, height: cornerRadius))
            
            let maskLayer = CAShapeLayer()
            maskLayer.borderColor = boderColor.cgColor
            //                maskLayer.boderWidth = boderWidth
            maskLayer.borderWidth = boderWidth
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            
            layer.mask = maskLayer
        }
    }
}

/** generic rx 연결을 위한 extension **/
extension MHTextFieldListView {
  public struct Reactive<T: MHTextFieldListViewKindRequiresEnum> {
    let base: MHTextFieldListView<T>
    
    fileprivate init(_ base: MHTextFieldListView<T>) {
      self.base = base
    }
  }
  
  public var rx: Reactive<T> {
    return Reactive(self)
  }
}

/** generic rx 연결을 위한 extension **/
extension MHTextFieldListView.Reactive{
    public var textKinds: Binder<[T]>{
        Binder(self.base) { view, kind in
            view.textKinds = kind
        }
    }

    public var listTap: Observable<T>{
        return Observable<T>.create { ob in
            self.base.setTextFieldListTapped { tag in

                guard let tag = tag else{
                    return
                }
                ob.onNext(tag)
            }

            return Disposables.create {
                self.base.textFieldListTapped = nil
            }
        }
    }
}
