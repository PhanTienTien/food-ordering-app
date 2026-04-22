package com.tientien.foodapp.chat.repository;

import com.tientien.foodapp.chat.entity.ChatMessage;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ChatMessageRepository extends JpaRepository<ChatMessage, Long> {
    List<ChatMessage> findByChatRoomIdOrderByCreatedAtAsc(Long chatRoomId);
    List<ChatMessage> findByChatRoomIdAndIsReadFalseOrderByCreatedAtAsc(Long chatRoomId);
}
