package com.bizzan.bitrade.job;

import com.bizzan.bitrade.util.WebSocketConnectionManage;
import org.java_websocket.enums.ReadyState;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class CheckWebSocketJob {
    /**
     * 10秒检查一次,重连
     */
    @Scheduled(cron = "*/10 * * * * *")
    public void checkWebSocket(){
        if(WebSocketConnectionManage.getWebSocket() != null && !WebSocketConnectionManage.getWebSocket().getReadyState().equals(ReadyState.OPEN)) {
            WebSocketConnectionManage.getWebSocket().reconnect();
        }
    }
}
