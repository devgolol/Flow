package com.flow.coretime.service;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.flow.coretime.exception.UserAlreadyExistsException;
import com.flow.coretime.mapper.UserMapper;
import com.flow.coretime.model.User;

@Service
public class UserService implements UserDetailsService {

	private final UserMapper userMapper;
	private final PasswordEncoder passwordEncoder;

	public UserService(UserMapper userMapper, PasswordEncoder passwordEncoder) {
		this.userMapper = userMapper;
		this.passwordEncoder = passwordEncoder;
	}

	public void insertUser(User user) {

		if (userMapper.countById(user.getId()) > 0) {
            // 비즈니스 규칙 위반이므로, 비즈니스 의미를 가진 커스텀 예외를 던집니다.
            throw new UserAlreadyExistsException("이미 사용 중인 아이디입니다."); 
        }
		user.setPassword(passwordEncoder.encode(user.getPassword()));
		user.setCreatedAt(LocalDate.now());
		user.setUpdatedAt(LocalDate.now());
		user.setRole("ROLE_USER");
		userMapper.insertUser(user);

	}

	public List<User> findAllUsers() {
		return userMapper.findAllUsers();
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
