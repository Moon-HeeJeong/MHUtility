//
//  File.swift
//  
//
//  Created by LittleFoxiOSDeveloper on 2023/05/23.
//

import Foundation
import UIKit

extension UITableView{
    public var cells:[UITableViewCell] {
        return (0..<self.numberOfSections).indices.map { (sectionIndex:Int) -> [UITableViewCell] in
            return (0..<self.numberOfRows(inSection: sectionIndex)).indices.compactMap{ (rowIndex:Int) -> UITableViewCell? in
                return self.cellForRow(at: IndexPath(row: rowIndex, section: sectionIndex))
            }
            }.flatMap{$0}
    }
    
    public func delayedShowUpCells(){
        var delyaedTime: TimeInterval = 0
        for cell in self.visibleCells {
            let originPosY = cell.frame.origin.y
            cell.frame = CGRect(x:0, y:cell.frame.origin.y + UIScreen.main.bounds.size.height, width:cell.frame.size.width, height:cell.frame.size.height)
            UIView.animate(withDuration: 0.35, delay: delyaedTime, options: .curveEaseInOut, animations: {
                cell.frame = CGRect(x:0, y:originPosY - 10, width:cell.frame.size.width, height:cell.frame.size.height)
            }, completion: {_ in
                UIView.animate(withDuration: 0.1, animations: {
                    cell.frame = CGRect(x:0, y:originPosY, width:cell.frame.size.width, height:cell.frame.size.height)
                })
            })
            delyaedTime += 0.03
        }
    }
    
    public func cellHidden(indexPath: IndexPath, isHidden: Bool){
        self.cellForRow(at: indexPath)?.isHidden = isHidden
    }
}


