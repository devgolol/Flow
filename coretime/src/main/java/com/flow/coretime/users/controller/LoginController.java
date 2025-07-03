<<<<<<< HEAD
package com.flow.coretime.users.controller;
=======
package com.flow.coretime.controller;
>>>>>>> d3784773a0a3902c70d05c36a88f9790ca5cbb26

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class LoginController {
	@GetMapping("/login")
	public String login() {
		return "login";
	}
	@GetMapping("/")
	public String root() {
		return "root";
	}

}
