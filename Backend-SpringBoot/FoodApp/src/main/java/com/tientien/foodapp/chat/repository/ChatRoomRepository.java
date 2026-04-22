package com.tientien.foodapp.chat.repository;

import com.tientien.foodapp.chat.entity.ChatRoom;
import com.tientien.foodapp.chat.enums.ChatRoomType;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ChatRoomRepository extends JpaRepository<ChatRoom, Long> {
    List<ChatRoom> findByUser1IdOrUser2Id(Long user1Id, Long user2Id);
    Optional<ChatRoom> findByUser1IdAndUser2IdAndReferenceId(Long user1Id, Long user2Id, Long referenceId);
    Optional<ChatRoom> findByUser1IdAndUser2IdAndType(Long user1Id, Long user2Id, ChatRoomType type);
}
