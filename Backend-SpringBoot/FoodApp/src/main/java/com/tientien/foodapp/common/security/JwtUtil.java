package com.tientien.foodapp.common.security;

import com.tientien.foodapp.user.entity.User;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Date;

@Component
public class JwtUtil {

    private static final String SECRET =
            "bXlfc3VwZXJfc2VjcmV0X2tleV9mb3Jfand0XzEyMzQ1Ng==";

    public String generateToken(User user) {

        SecretKey key = Keys.hmacShaKeyFor(
                Decoders.BASE64.decode(SECRET)
        );

        return Jwts.builder()
                .setSubject(user.getId().toString())
                .claim("role", user.getRole().name())
                .claim(
                        "restaurantId",
                        user.getRestaurant() != null ? user.getRestaurant().getId() : null
                )
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + 86400000))
                .signWith(key)
                .compact();
    }

    public Long extractUserId(String token) {
        SecretKey key = Keys.hmacShaKeyFor(
                Decoders.BASE64.decode(SECRET)
        );
        return Long.parseLong(
                Jwts.parser()
                        .setSigningKey(key)
                        .parseClaimsJws(token)
                        .getBody()
                        .getSubject()
        );
    }
}
