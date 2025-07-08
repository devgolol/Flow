package com.flow.coretime.users.service;


import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;


import com.flow.coretime.users.exception.UserAlreadyExistsException;
import com.flow.coretime.users.mapper.UserMapper;
import com.flow.coretime.users.model.User;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

@Service
public class UserService implements UserDetailsService {

	private final UserMapper userMapper;
	private final PasswordEncoder passwordEncoder;

	@Value("${app.upload.profile-image-dir}")
    	private String uploadDir;

	public UserService(UserMapper userMapper, PasswordEncoder passwordEncoder) {
		this.userMapper = userMapper;
		this.passwordEncoder = passwordEncoder;
	}
	
	// find =============================
	public PageInfo<User> findUsersWithPagination(int pageNum, int pageSize) {
		PageHelper.startPage(pageNum, pageSize);
		List<User> userList = userMapper.findAllUsers();

		return new PageInfo<>(userList);
	}

	public List<User> findAllUsers() {
		return userMapper.findAllUsers();
	}
	
	public User findById(String id)
	{
		User foundUser= userMapper.findById(id);
		foundUser.setPassword(null);
		return foundUser;
	}
	
	
	// insert=============================
	public void insertUser(User user, String profileImagePath) {
		if (userMapper.countById(user.getId()) > 0) {
            		throw new UserAlreadyExistsException("이미 사용 중인 아이디입니다."); 
        	}
		if (profileImagePath != null && !profileImagePath.isEmpty()) {
			// 업로드 디렉토리가 없으면 생성
			Path uploadPath = Paths.get(uploadDir);
			if (!Files.exists(uploadPath)) {
				Files.createDirectories(uploadPath);
			}

			// 고유한 파일 이름 생성 (UUID 사용)
			String originalFilename = profileImagePath.getOriginalFilename();
			String fileExtension = "";
			if (originalFilename != null && originalFilename.contains(".")) {
				fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
			}
			String newFilename = UUID.randomUUID().toString() + fileExtension;
			Path filePath = uploadPath.resolve(newFilename);

			// 파일 저장
			Files.copy(profileImage.getInputStream(), filePath);

			// User 객체에 이미지 경로 저장 (DB에 저장될 경로)
			user.setProfileImagePath("/resources/upload/" + newFilename); // 웹 접근 경로
		}
		user.setPassword(passwordEncoder.encode(user.getPassword()));
		user.setCreatedAt(LocalDate.now());
		user.setUpdatedAt(LocalDate.now());
		user.setRole("ROLE_USER");
		userMapper.insertUser(user);
	}
	
	// update=============================
	public void updateUserByExistingId(String existingId, User newUserInfo)
	{
		newUserInfo.setUpdatedAt(LocalDate.now());
		userMapper.updateUserByExistingId(existingId, newUserInfo);
	}
	

	

	public void deleteUsersByIds(List<String> userIds) {
		userMapper.deleteUsersByIds(userIds);
	}
	
	
	
	@Override
	public UserDetails loadUserByUsername(String id) throws UsernameNotFoundException {
		User user = userMapper.findById(id);
		System.out.println(user.getId());

		List<GrantedAuthority> authorities = Arrays.stream(user.getRole().split(",")).map(SimpleGrantedAuthority::new)
				.collect(Collectors.toList());

		return new org.springframework.security.core.userdetails.User(user.getId(), // 사용자 아이디 (로그인에 사용될 식별자)
				user.getPassword(), // 암호화된 비밀번호 (DB에서 가져온 그대로)
				authorities // 사용자 권한 목록
		);
	}

}
