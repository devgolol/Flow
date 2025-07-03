<<<<<<< HEAD
package com.flow.coretime.users.util;
=======
package com.flow.coretime.util;
>>>>>>> d3784773a0a3902c70d05c36a88f9790ca5cbb26

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordGenerator {
	public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        String encodedPassword = encoder.encode("1234");
        System.out.println("Encoded Password: " + encodedPassword);
    }
}
