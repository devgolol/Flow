<<<<<<< HEAD
package com.flow.coretime.users.mapper;
=======
package com.flow.coretime.mapper;
>>>>>>> d3784773a0a3902c70d05c36a88f9790ca5cbb26
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

<<<<<<< HEAD
import com.flow.coretime.users.model.User;
=======
import com.flow.coretime.model.User;
>>>>>>> d3784773a0a3902c70d05c36a88f9790ca5cbb26


@Mapper 
public interface UserMapper {

	void insertUser(User user);
	
	User findById(String id);
	
	List<User> findAllUsers();
	
	int countById(String id);

	void deleteUserByIds(List<String> userIds);

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