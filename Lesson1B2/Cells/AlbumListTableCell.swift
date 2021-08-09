//
//  AlbumListTableCell.swift
//  Lesson1B2
//
//  Created by user on 08.08.2021.
//

import Foundation
import AsyncDisplayKit

class AlbumListTableCell: ASCellNode {
    
    private let resource: Item
    private let imageNode = ASNetworkImageNode()
    private let textNode = ASTextNode()
    
    init(resource: Item) {
        self.resource = resource
        
        super.init()
        
        self.setupSubnodes()
    }
    
    private func setupSubnodes() {
        self.imageNode.url = URL(string: resource.thumbSrc)
        self.imageNode.contentMode = .scaleAspectFit
        self.imageNode.shouldRenderProgressImages = true
        
        self.textNode.attributedText = NSAttributedString(string: resource.title)
//        self.textNode.contentMode = .scaleAspectFit
    
        self.addSubnode(self.textNode)
        self.addSubnode(self.imageNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let width = constrainedSize.max.width
        
        self.textNode.style.preferredSize = CGSize(width: width/2, height: 80)
        self.textNode.style.layoutPosition = CGPoint(x: 50 , y: 40)

        self.imageNode.style.preferredSize = CGSize(width: width, height: 80)
        self.imageNode.style.layoutPosition = CGPoint(x: 0, y: 0)
        
        return ASWrapperLayoutSpec(layoutElements: [self.imageNode, self.textNode])
    }
}
