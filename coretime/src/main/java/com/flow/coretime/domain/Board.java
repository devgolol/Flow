package com.flow.coretime.domain;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Board {
	
	private Long id;

	private String author;
	
	private String email;
	
	private String department;
	
	private String title;
	
	private String content;
	
	private int viewcount;
	
	private LocalDateTime createdAt;
	
	private LocalDateTime updatedAt;
	
	private String boardtype;
	
	private String role;
	
	
}
