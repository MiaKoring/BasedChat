import SwiftUI
import SwiftChameleon

extension MessageScrollView {
    //TODO: Rewrite paging
    /*
    func markAllRead() {
        for message in (chat.messages.compactMap { message in
            if !message.isRead {
                return message
            }
            return nil
        }) {
            message.isRead = true
        }
    }
    */
    func messageGlow() {
        let glowMessage = glowOriginMessage
        glowOriginMessage = nil
        
        if glowMessage != nil && chat.messages.contains(where: { $0.messageUUID == glowMessage! }) {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                withAnimation(.easeIn) {
                    chat.messages.first(where: {$0.messageUUID == glowMessage})!.background = "glow"
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
                    withAnimation(.easeIn) {
                        chat.messages.first(where: {$0.messageUUID == glowMessage})!.background = "default"
                    }
                }
            }
        }
    }
    /*
    func setup() {
        rangeStart = max(chat.messages.count - 51, 0)
        
        if chat.messages.count == 0 {
            rangeEnd = 0
            renderedMessages = []
            return
        }
        
        rangeEnd = max(chat.messages.count - 1, 0)
        renderedMessages = chat.messages[rangeStart...rangeEnd].reversed()
        containsUnread = renderedMessages.contains(where: { !$0.isRead })
        
        if containsUnread {
            lastUnreadIndex = containsUnread ? renderedMessages.lastIndex(where: { !$0.isRead }) : nil
        }
    }
    
    func deleteMessage() {
        if messageToDelete.isNil { return }
        rangeEnd = chat.messages.count - 1
    }
    
    func scenePhaseChanged(newScenePhase: ScenePhase) {
        switch newScenePhase {
        case .active:
            break
        case .inactive:
            markAllRead()
            break
        case .background:
            markAllRead()
            break
        @unknown default:
            break
        }
    }
    
    func newMessage() {
        triggerBottomScroll.toggle()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.smooth(duration: 0.3)) {
                rangeStart = max(chat.messages.count - 51, 0)
                rangeEnd = max(chat.messages.count - 1, 0)
                renderedMessages = chat.messages[rangeStart...rangeEnd].reversed()
            }
        }
    }
    
    func loadScrollDestination() {
        if renderedMessages.firstIndex(where: {$0.messageUUID == scrollTo}).isNil {
            let index = messages.firstIndex(where: { $0.messageUUID == scrollTo })
            
            if index.isNil { return }
            
            let previousStart = rangeStart
            rangeStart = max(index! - 5, 0)
            renderedMessages.append(contentsOf: messages[rangeStart...previousStart - 1].reversed())
        }
    }
     */
    
    func bottomScrollOverlay()-> some View {
        HStack {
            if showBottomScrollButton {
                UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 15.0, bottomLeading: 15.0, bottomTrailing: 0.0, topTrailing: 0.0), style: .continuous)
                    .fill(.ultraThinMaterial)
                    .strokeBorder(.ultraThinMaterial, lineWidth: 1)
                    .frame(width: 65, height: 45)
                    .overlay {
                        HStack{
                            Image(systemName: "arrowtriangle.down")
                                .font(.system(size: 24))
                                .allowsHitTesting(false)
                                .padding(.leading, 20)
                            Spacer()
                        }
                    }
                    .padding(.bottom, 30)
                    .onTapGesture{ bottomScrollButtonTapped() }
            }
        }
    }
    
    func bottomScrollButtonTapped() {
        triggerBottomScroll.toggle()
        rangeStart = max(chat.messages.count - 51, 0)
        
        /*DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            renderedMessages = chat.messages[rangeStart...rangeEnd].reversed()
        }*/
    }
    
}
