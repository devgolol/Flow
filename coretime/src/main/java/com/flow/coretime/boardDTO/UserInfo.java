package com.flow.coretime.boardDTO;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UserInfo {

	private Long id;
	
	private String name;
	
	private String email;
	
	private String department;
	
	private String role;
}
