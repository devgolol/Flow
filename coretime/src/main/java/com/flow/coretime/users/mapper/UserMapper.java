
package com.flow.coretime.users.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.flow.coretime.users.model.User;



@Mapper 
public interface UserMapper {

	void insertUser(User user);
	
	User findById(String id);
	
	List<User> findAllUsers();
	
	int countById(String id);

	void deleteUsersByIds(List<String> userIds);
	
	void updateUserByExistingId(@Param("existingId")String existingId, @Param("newUserInfo")User newUserInfo);

//    // XML 매퍼 파일의 id="findById"와 매핑됩니다.
//    Optional<User> findById(Long id);
//
//    // XML 매퍼 파일의 id="findByUsername"과 매핑됩니다.
//    Optional<User> findByUsername(String username);
//
//    // XML 매퍼 파일의 id="insertUser"와 매핑됩니다.
//    void insertUser(User user);
//
//    // @Select 어노테이션을 사용하여 간단한 쿼리는 XML 없이도 정의할 수 있습니다.
//    @Select("SELECT ID, USERNAME, PASSWORD, ROLES FROM USERS")
//    List<User> findAllUsers();
//
//    // 여러 파라미터를 넘길 때는 @Param 어노테이션을 사용하는 것이 좋습니다.
//    @Select("SELECT ID, USERNAME, PASSWORD, ROLES FROM USERS WHERE USERNAME = #{username} AND ROLES = #{role}")
//    List<User> findByUsernameAndRole(@Param("username") String username, @Param("role") String role);
}