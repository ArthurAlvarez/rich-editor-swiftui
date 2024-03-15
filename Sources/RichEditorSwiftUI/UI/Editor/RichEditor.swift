//
//  RichEditor.swift
//
//
//  Created by Divyesh Vekariya on 24/10/23.
//

import SwiftUI

public struct RichEditor: View {
    @ObservedObject var state: RichEditorState
    @Binding var textView: TextViewOverRidden?
    
    public init(state: ObservedObject<RichEditorState>, textView: Binding<TextViewOverRidden?>) {
        self._state = state
        self._textView = textView
    }
    
    public var body: some View {
        VStack(content: {
            EditorToolBarView(state: state)
            
            TextViewWrapper(state: _state,
                            attributesToApply:  $state.attributesToApply,
                            isScrollEnabled: true,
                            fontStyle: state.curretFont,
                            onTextViewEvent: state.onTextViewEvent(_:),
                            textView: $textView)
        })
    }
}
