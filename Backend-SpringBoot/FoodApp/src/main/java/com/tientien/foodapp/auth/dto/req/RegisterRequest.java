package com.tientien.foodapp.auth.dto.req;

import lombok.Getter;
import lombok.Setter;

import jakarta.validation.constraints.*;

@Getter @Setter
public class RegisterRequest {

    @NotBlank
    private String name;

    @Email
    private String email;

    @Size(min = 6)
    private String password;
}
