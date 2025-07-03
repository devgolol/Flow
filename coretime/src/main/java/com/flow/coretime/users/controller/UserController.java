<<<<<<< HEAD
package com.flow.coretime.users.controller;
=======
package com.flow.coretime.controller;
>>>>>>> d3784773a0a3902c70d05c36a88f9790ca5cbb26

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

<<<<<<< HEAD
import com.flow.coretime.users.exception.UserAlreadyExistsException;
import com.flow.coretime.users.model.User;
import com.flow.coretime.users.service.UserService;
=======
import com.flow.coretime.exception.UserAlreadyExistsException;
import com.flow.coretime.model.User;
import com.flow.coretime.service.UserService;
>>>>>>> d3784773a0a3902c70d05c36a88f9790ca5cbb26
import com.github.pagehelper.PageInfo;

import jakarta.validation.Valid;

@Controller
@RequestMapping("/users")
public class UserController {
	
	private final UserService userService;
	
	public UserController(UserService userService) {
		this.userService= userService;
	}
	
//	@GetMapping
//	public String showUsers(Model model) {
//		List<User> userList = userService.findAllUsers(); // 서비스에서 모든 사용자 가져오기
//        model.addAttribute("userList", userList); // 모델에 리스트 추가
//        return "users";
//	}
	
	@GetMapping
	public String showUsers(
			@RequestParam(value = "page", defaultValue = "1") int pageNum, // 페이지 번호 (1부터 시작)
            @RequestParam(value = "size", defaultValue = "10") int pageSize, // 페이지 당 항목 수
            Model model) {
        
        // 서비스 계층에서 PageInfo 객체를 받아옴
        PageInfo<User> pageInfo = userService.findUsersWithPagination(pageNum, pageSize);

        // JSP에서 사용할 페이징 정보와 목록을 모델에 추가
        model.addAttribute("userList", pageInfo.getList()); // 현재 페이지의 사용자 목록
        model.addAttribute("pageInfo", pageInfo); // PageInfo 객체 전체 (다양한 페이징 정보 포함)

		return "users";
	}
	
	@GetMapping("/list")
	public String showUserList(Model model) {
		List<User> userList = userService.findAllUsers(); // 서비스에서 모든 사용자 가져오기
        model.addAttribute("userList", userList); // 모델에 리스트 추가
        return "userList";
	}
	
	@GetMapping("/new")
	public String showUserForm(Model model) {
		model.addAttribute("user", new User());
		return "userForm";
	}

	@PostMapping("/insert")
	public String insertUser(@Valid @ModelAttribute User user, BindingResult bindingResult, Model model) {
		if (bindingResult.hasErrors()) {
            System.out.println("Validation errors: " + bindingResult.getAllErrors());
			return "userForm";
		}
		
		try {
			userService.insertUser(user);
		} catch (UserAlreadyExistsException e) {
			bindingResult.addError(new FieldError("user", "id", user.getId(), false, null, null, e.getMessage()));
			model.addAttribute("user", user);
			return "userForm";
		} catch (Exception e) {
            System.err.println("Unhandled Exception during user insertion: " + e.getMessage());
            model.addAttribute("errorMessage", "사용자 등록 중 알 수 없는 오류가 발생했습니다.");
            model.addAttribute("user", user);
            return "userForm"; 
        }
		
		return "redirect:/users";
	}
	
	@PostMapping("/delete")
    public ResponseEntity<Map<String, String>> deleteUsers(@RequestBody Map<String, List<String>> payload) {
        List<String> userIds = payload.get("ids");
        try {
            if (userIds == null || userIds.isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of("message", "삭제할 사용자 ID가 없습니다."));
            }
            userService.deleteUsersByIds(userIds);
            return ResponseEntity.ok(Map.of("message", "사용자가 성공적으로 삭제되었습니다."));
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(Map.of("message", "사용자 삭제 중 오류 발생: " + e.getMessage()));
        }
		
//		System.out.println("야이야이야");
//		return ResponseEntity.ok(Map.of("message", "사용자가 성공적으로 삭제되었습니다."));
    }

}

