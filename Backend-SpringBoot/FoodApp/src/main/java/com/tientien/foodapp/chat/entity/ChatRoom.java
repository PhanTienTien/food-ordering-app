package com.tientien.foodapp.chat.entity;

import com.tientien.foodapp.common.entity.BaseEntity;
import com.tientien.foodapp.chat.enums.ChatRoomType;
import com.tientien.foodapp.user.entity.User;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Entity
@Table(name = "chat_rooms")
@Getter
@Setter
public class ChatRoom extends BaseEntity {

    @ManyToOne
    @JoinColumn(name = "user1_id", nullable = false)
    private User user1;

    @ManyToOne
    @JoinColumn(name = "user2_id", nullable = false)
    private User user2;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ChatRoomType type;

    private Long referenceId; // order_id, restaurant_id, etc.

    @OneToMany(mappedBy = "chatRoom")
    private List<ChatMessage> messages;
}
