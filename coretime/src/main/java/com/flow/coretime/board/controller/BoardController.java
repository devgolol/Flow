package com.flow.coretime.board.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.flow.coretime.board.dto.Board;
import com.flow.coretime.board.service.BoardService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/boards")
@RequiredArgsConstructor
public class BoardController {
	
	private final BoardService boardService;
	
	@GetMapping
	public String combinedBoardList(Model model,
									@RequestParam(value = "page" , defaultValue = "1") int page,
									@RequestParam(value = "searchType" , required = false) String searchType,
									@RequestParam(value = "keyword" , required = false) String keyword) {
		
		// 1-1. 공지사항 목록 조회(상위 5개만 고정)
		Map<String , Object> noticeParams = new HashMap<>();
		noticeParams.put("boardType", "NOTICE");
		noticeParams.put("offset", 0);
		noticeParams.put("pageSize", 5);
		List<Board> noticeList = boardService.getBoardList(noticeParams);
		
		// 1-2. 일반게시판 목록 조회 (페이징 및 검색 적용)
		int pageSize = 10; //일반게시판은 페이지당 10개 보이게
		int offset = (page -1)* pageSize;
		
		Map<String, Object> generalParams =new HashMap<>();
		generalParams.put("boardType", "GENERAL");
		generalParams.put("offset", offset);
		generalParams.put("pageSize", pageSize);
		generalParams.put("searchType", searchType);
		generalParams.put("keyword", keyword);
		List<Board> generalList = boardService.getBoardList(generalParams);
		
		// 1-3. 일반게시판 페이징을 위한 전체 개수 조회
		int totalCount = boardService.getBoardCount(generalParams);
		int totalPages = (int)Math.ceil((double) totalCount / pageSize);
		
		// 1-4. Model에 데이터 담기
		model.addAttribute("noticeList", noticeList);
		model.addAttribute("generalList", generalList);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("currentPage", page);
		model.addAttribute("searchType", searchType);
		model.addAttribute("keyword", keyword);
		
		return "boards/combinedList";
	}
	
	
	

}
