package com.tientien.foodapp.chat.controller;

import com.tientien.foodapp.chat.entity.ChatMessage;
import com.tientien.foodapp.chat.entity.ChatRoom;
import com.tientien.foodapp.chat.enums.ChatRoomType;
import com.tientien.foodapp.chat.repository.ChatMessageRepository;
import com.tientien.foodapp.chat.repository.ChatRoomRepository;
import com.tientien.foodapp.user.entity.User;
import com.tientien.foodapp.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/chat")
@RequiredArgsConstructor
public class ChatController {

    private final ChatRoomRepository chatRoomRepository;
    private final ChatMessageRepository chatMessageRepository;
    private final UserRepository userRepository;
    private final SimpMessagingTemplate messagingTemplate;

    @GetMapping("/rooms/{userId}")
    public List<ChatRoom> getChatRooms(@PathVariable Long userId) {
        return chatRoomRepository.findByUser1IdOrUser2Id(userId, userId);
    }

    @GetMapping("/room/{id}/messages")
    public List<ChatMessage> getMessages(@PathVariable Long id) {
        return chatMessageRepository.findByChatRoomIdOrderByCreatedAtAsc(id);
    }

    @GetMapping("/room/{id}/unread")
    public List<ChatMessage> getUnreadMessages(@PathVariable Long id) {
        return chatMessageRepository.findByChatRoomIdAndIsReadFalseOrderByCreatedAtAsc(id);
    }

    @PostMapping("/room")
    public ChatRoom createChatRoom(
            @RequestParam Long user1Id,
            @RequestParam Long user2Id,
            @RequestParam String type,
            @RequestParam(required = false) Long referenceId) {
        User user1 = userRepository.findById(user1Id)
                .orElseThrow(() -> new RuntimeException("User 1 not found"));
        User user2 = userRepository.findById(user2Id)
                .orElseThrow(() -> new RuntimeException("User 2 not found"));

        // Check if room already exists
        Optional<ChatRoom> existingRoom;
        if (referenceId != null) {
            existingRoom = chatRoomRepository.findByUser1IdAndUser2IdAndReferenceId(
                    user1Id, user2Id, referenceId);
        } else {
            existingRoom = chatRoomRepository.findByUser1IdAndUser2IdAndType(
                    user1Id, user2Id, ChatRoomType.valueOf(type));
        }

        if (existingRoom.isPresent()) {
            return existingRoom.get();
        }

        ChatRoom chatRoom = new ChatRoom();
        chatRoom.setUser1(user1);
        chatRoom.setUser2(user2);
        chatRoom.setType(ChatRoomType.valueOf(type));
        chatRoom.setReferenceId(referenceId);

        return chatRoomRepository.save(chatRoom);
    }

    @PostMapping("/room/{id}/message")
    public ChatMessage sendMessage(
            @PathVariable Long id,
            @RequestParam Long senderId,
            @RequestParam String content) {
        ChatRoom chatRoom = chatRoomRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Chat room not found"));

        User sender = userRepository.findById(senderId)
                .orElseThrow(() -> new RuntimeException("Sender not found"));

        ChatMessage message = new ChatMessage();
        message.setChatRoom(chatRoom);
        message.setSender(sender);
        message.setContent(content);
        message.setIsRead(false);

        ChatMessage saved = chatMessageRepository.save(message);

        // Send real-time message via WebSocket
        messagingTemplate.convertAndSend("/topic/chat/" + id, saved);

        return saved;
    }

    @PutMapping("/message/{id}/read")
    public ChatMessage markAsRead(@PathVariable Long id) {
        ChatMessage message = chatMessageRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Message not found"));
        message.setIsRead(true);
        return chatMessageRepository.save(message);
    }

    // WebSocket endpoints for real-time messaging
    @MessageMapping("/chat/{roomId}/send")
    @SendTo("/topic/chat/{roomId}")
    public ChatMessage handleChatMessage(
            @DestinationVariable Long roomId,
            @Payload ChatMessage message) {
        return message;
    }
}
