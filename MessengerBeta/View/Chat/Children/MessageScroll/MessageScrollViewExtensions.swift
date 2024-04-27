import SwiftUI
extension MessageScrollView{
    func markAllRead(){
        for message in (messages.compactMap{message in
            if !message.isRead{
                return message
            }
            return nil
        }){
            message.isRead = true
        }
    }
    
    func messageGlow(){
        let glowMessage = glowOriginMessage
        glowOriginMessage = nil
        if glowMessage != nil && messages.contains(where: {$0.id == glowMessage!}){
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                withAnimation(.easeIn){
                    messages.first(where: {$0.id == glowMessage})!.background = "glow"
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+0.25){
                    withAnimation(.easeIn){
                        messages.first(where: {$0.id == glowMessage})!.background = "normal"
                    }
                }
            }
        }
    }
    
    func setup(){
        rangeStart = max(messages.count - 51, 0)
        if messages.count == 0{
            rangeEnd = 0
            renderedMessages = []
            return
        }
        rangeEnd = max(messages.count - 1, 0)
        renderedMessages = messages[rangeStart...rangeEnd].reversed()
        containsUnread = renderedMessages.contains(where: {!$0.isRead})
        if containsUnread{
            lastUnreadIndex = containsUnread ? renderedMessages.lastIndex(where: {!$0.isRead}) : nil
        }
    }
    
    func deleteMessage(){
        if messageToDelete == nil { return }
        rangeEnd = messages.count - 1
    }
    
    func scenePhaseChanged(newScenePhase: ScenePhase){
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
    
    func newMessage(){
        triggerBottomScroll.toggle()
        rangeStart = messages.count - 51
        rangeEnd = messages.count - 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            withAnimation(.smooth(duration: 0.3)){
                renderedMessages = messages[rangeStart...rangeEnd].reversed()
            }
        }
    }
    
    func loadScrollDestination(){
        if renderedMessages.firstIndex(where: {$0.id == scrollTo}) == nil{
            let index = messages.firstIndex(where: {$0.id == scrollTo})
            if index == nil { return }
            let previousStart = rangeStart
            rangeStart = max(index! - 5, 0)
            renderedMessages.append(contentsOf: messages[rangeStart...previousStart - 1].reversed())
        }
    }
    
}

extension MessageScrollView{
    func bottomScrollOverlay()-> some View {
        HStack{
            if showBottomScrollButton{
                Circle()
                    .fill(.blue)
                    .frame(width: 50, height: 50)
                    .overlay{
                        Image(systemName: "arrowtriangle.down")
                            .allowsHitTesting(false)
                    }
                    .onTapGesture{
                        triggerBottomScroll.toggle()
                        rangeStart = max(messages.count - 51, 0)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                            renderedMessages = messages[rangeStart...rangeEnd].reversed()
                        }
                    }
            }
        }
    }
}
