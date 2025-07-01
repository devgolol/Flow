package com.flow.coretime.model;

import java.time.LocalDate;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class User {
    private String name;
    private String id;
    private String password;
    private String confirmPassword;
    private String email;
    private String tel;
    private String rank;
    private String department;
    
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate birth;
    private LocalDate createdAt;
    private LocalDate updatedAt;
    private String role; // DB의 ROLES (예: "USER")
    // Getters and Setters
}
