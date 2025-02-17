//
//  RichTextAttributeWriter+Style.swift
//
//
//  Created by Divyesh Vekariya on 28/12/23.
//

import Foundation

public extension NSMutableAttributedString {
    
    /**
     Set a rich text style at a certain range.
     
     The function uses `safeRange(for:)` to handle incorrect
     ranges, which is not handled by the native functions.
     
     - Parameters:
     - style: The style to set.
     - newValue: The new value to set the attribute to.
     - range: The range to affect, by default the entire text.
     */
    func setRichTextStyle(
        _ style: RichTextStyle,
        to newValue: Bool,
        at range: NSRange? = nil
    ) {
        let rangeValue = range ?? richTextRange
        let range = safeRange(for: rangeValue)
        let attributeValue = newValue ? 1 : 0
        if style == .underline { return setRichTextAttribute(.underlineStyle, to: attributeValue, at: range) }
        guard let font = richTextFont(at: range) else { return }
        let styles = richTextStyles(at: range)
        let shouldAdd = newValue && !styles.hasStyle(style)
        let shouldRemove = !newValue && styles.hasStyle(style)
        guard shouldAdd || shouldRemove || style.isHeaderStyle else { return }
        var descriptor = font.fontDescriptor
        if !style.isDefault && !style.isHeaderStyle {
            descriptor = descriptor.byTogglingStyle(style)
        }
        let newFont: FontRepresentable? = FontRepresentable(
            descriptor: descriptor,
            size: byTogglingFontSizeFor(style: style, font: font, shouldAdd: newValue))
        guard let newFont = newFont else { return }
        setRichTextFont(newFont, at: range)
    }
    
    /**
     This will reset font size befor multiplying new size
     */
    private func byTogglingFontSizeFor(style: TextSpanStyle, font: FontRepresentable, shouldAdd: Bool) -> CGFloat {
        guard style.isHeaderStyle || style.isDefault else { return  font.pointSize }
        
        let cleanFont = style.getFontAfterRemovingStyle(font: font)
        if shouldAdd {
            return cleanFont.pointSize * style.fontSizeMultiplier
        } else {
            return font.pointSize / style.fontSizeMultiplier
        }
    }
}
