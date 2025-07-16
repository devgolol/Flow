package com.flow.coretime.board.controller;

import java.security.Principal;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
	                                @RequestParam(value = "page", defaultValue = "1") int page,
	                                @RequestParam(value = "searchType", required = false) String searchType,
	                                @RequestParam(value = "keyword", required = false) String keyword) {

	    // 파라미터를 하나로 합쳐서 서비스 호출
	    int pageSize = 15; // 한 페이지에 보여줄 전체 게시글 수 (공지 포함)
	    int offset = (page - 1) * pageSize;

	    Map<String, Object> params = new HashMap<>();
	    params.put("offset", offset);
	    params.put("pageSize", pageSize);
	    params.put("searchType", searchType);
	    params.put("keyword", keyword);
	    // boardType을 파라미터에서 제거하여 모든 글을 가져오도록 함

	    List<Board> boardList = boardService.getBoardList(params);

	    // 페이징을 위한 전체 개수 조회
	    Map<String, Object> countParams = new HashMap<>();
	    countParams.put("searchType", searchType);
	    countParams.put("keyword", keyword);
	    int totalCount = boardService.getBoardCount(countParams);
	    int totalPages = (int) Math.ceil((double) totalCount / pageSize);

	    // Model에 데이터 담기
	    model.addAttribute("boardList", boardList); // 이제 리스트는 하나만 필요
	    model.addAttribute("totalPages", totalPages);
	    model.addAttribute("currentPage", page);
	    model.addAttribute("searchType", searchType);
	    model.addAttribute("keyword", keyword);

	    // JSP 파일 이름도 하나로 통일된 리스트를 보여주는 이름으로 변경하는 것이 좋음
	    // 예: "boards/list"
	    return "combinedList"; // 이 부분은 기존 JSP에 맞게 유지
	}
	
	//게시글 상세 조회
	@GetMapping("/{id}")
	public String boardDetail(@PathVariable("id")Long id, Model model, Principal principal) {
		
		Board board = boardService.getBoardDetail(id);
		model.addAttribute("board",board);
		
		boolean isOwner = false;
		if(principal != null) {
			if(principal.getName().equals(board.getAuthor())) {
				isOwner = true;
			}
		}
		model.addAttribute("isOwner", isOwner);
		
		return "detail";
	}
	
	//게시글 작성 폼
	@GetMapping("/write")
	public String writeForm(Model model, Principal principal) {
		if(principal == null) {
			return "redirect:/login";
		}
		
		Authentication authentication = (Authentication) principal;
		Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
		boolean isAdmin = authorities.stream().anyMatch(auth -> auth.getAuthority().equals("ROLE_ADMIN"));
		
		model.addAttribute("userRole", isAdmin ? "ROLE_ADMIN" : "ROLE_USER");
		model.addAttribute("board", new Board());
		
		return "writeForm";
	}

	//게시글 생성 처리	
	@PostMapping("/write")
	public String createBoard(@ModelAttribute Board board, Principal principal, RedirectAttributes rttr) {
		if (principal == null) {
			return "redirect:/login";
		}
		
		Authentication authentication = (Authentication)principal;
		Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
		boolean isAdmin = authorities.stream().anyMatch(auth -> auth.getAuthority().equals("ROLE_ADMIN"));
		String userRole = isAdmin ? "ROLE_ADMIN,ROLE_USER" : "ROLE_USER";
		
		if("NOTICE".equals(board.getBoardType()) && !isAdmin) {
			rttr.addFlashAttribute("errorMessage","공지사항 작성 권한이 없습니다.");
			return "redirect:/boards/write";
		}
		
		board.setAuthor(principal.getName());
		board.setRole(userRole);
		
		board.setDepartmentName(null);
		board.setEmail(null);
		
		boardService.createBoard(board);
		
		rttr.addFlashAttribute("successMessage", "게시글이 성공적으로 등록되었습니다.");
		return "redirect:/boards";
	}
	
	@GetMapping("/{id}/edit")
	public String editForm(@PathVariable("id") Long id, Model model, Principal principal, RedirectAttributes rttr) {
		if(principal == null) {
			return "redirect:/login";
		}
		
		Board boardToEdit = boardService.getBoardByIdForUpdate(id);
		
		if (!Objects.equals(boardToEdit.getAuthor(), principal.getName())) {
			rttr.addFlashAttribute("errorMessage","수정 권한이 없습니다.");
			return "redirect:/boards/" + id;
		}
		
		model.addAttribute("board",boardToEdit);
		return "editForm";
	}
	
	@PostMapping("/{id}/edit")
	public String updateBoard(@PathVariable("id") Long id, @ModelAttribute Board board, Principal principal, RedirectAttributes rttr) {
		if(principal == null) {
			return "redirect:/login";
		}
		Board existingBoard = boardService.getBoardByIdForUpdate(id);
		
		if(!Objects.equals(existingBoard.getAuthor(), principal.getName())) {
			rttr.addFlashAttribute("errorMessage", "수정 권한이 없습니다.");
			return "redirect:/boards/" + id;
		}
		
		existingBoard.setTitle(board.getTitle());
		existingBoard.setContent(board.getContent());
		
		boardService.updateBoard(existingBoard);
		
		rttr.addFlashAttribute("successMessage" , "게시글이 성공적으로 수정되었습니다.");
		return "redirect:/boards/" + id;
	}
	
	@PostMapping("/{id}/delete")
	public String deleteBoard(@PathVariable("id") Long id,Principal principal, RedirectAttributes rttr) {
		if (principal == null) {
			return "redirect:/login";
		}
		Board boardToDelete = boardService.getBoardByIdForUpdate(id);
		
		if(!Objects.equals(boardToDelete.getAuthor(), principal.getName())) {
			rttr.addFlashAttribute("errorMessage", "삭제 권한이 없습니다");
			return "redirect:/boards/" +id;
		}
		
		boardService.deleteBoard(id);
		
		rttr.addFlashAttribute("successMessage","게시글이 성공적으로 삭제되었습니다.");
		return "redirect:/boards";
	}
	
}
