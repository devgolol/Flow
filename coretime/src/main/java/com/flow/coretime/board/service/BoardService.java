package com.flow.coretime.board.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.flow.coretime.board.dto.Board;
import com.flow.coretime.board.mapper.BoardMapper;
import com.flow.coretime.users.model.User;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BoardService {

	private final BoardMapper boardMapper;

	@Transactional
	public void createBoard(Board board, User user) {		
		board.setAuthor(user.getName());
		board.setDepartmentName(user.getDepartment());
		board.setRole(user.getRole());
		
		boardMapper.save(board);
	}
}
