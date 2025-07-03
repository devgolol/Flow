package com.flow.coretime.board.boardDTO;

import java.time.LocalDateTime;

import com.flow.coretime.board.domain.Board;

import lombok.Getter;

@Getter
public class BoardResponse {

	private final Long id;
	
	private final String author;
	
	private final String email;
	
	private final String department;
	
	private final String title;
	
	private final String content;
	
	private final int viewcount;
	
	private final LocalDateTime createdAt;
	
	private final LocalDateTime updatedAt;
	
	private final String boardType;
	
	
	public BoardResponse(Board board) {
		this.id = board.getId();
		this.author = board.getAuthor();
		this.email = board.getEmail();
		this.department = board.getDepartment();
		this.title = board.getTitle();
		this.content = board.getContent();
		this.viewcount = board.getViewcount();
		this.createdAt = board.getCreatedAt();
		this.updatedAt = board.getUpdatedAt();
		this.boardType = board.getBoardtype();
	}
	
	
	
}
