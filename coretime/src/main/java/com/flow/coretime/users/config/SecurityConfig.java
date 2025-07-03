<<<<<<< HEAD
package com.flow.coretime.users.config;
=======
package com.flow.coretime.config;
>>>>>>> d3784773a0a3902c70d05c36a88f9790ca5cbb26

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {
	
	@Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
	
	@Bean
	public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
		http
				.csrf().disable()
				.authorizeHttpRequests(authorize -> authorize
						.requestMatchers("/login", "doLogin").permitAll()
						.requestMatchers("/WEB-INF/**").permitAll() 
						.requestMatchers("/resources/**").permitAll()
						.anyRequest().authenticated()
				)
				.formLogin(formLogin -> formLogin
						.loginPage("/login")
					    .loginProcessingUrl("/doLogin")
					    .usernameParameter("username")
					    .passwordParameter("password")
					    .defaultSuccessUrl("/", true)
					    .failureUrl("/login?error=true")
					    .permitAll()
				)
				.logout(logout -> logout
						.logoutUrl("/logout")
						.logoutSuccessUrl("/login")
						.permitAll()
				);

		return http.build();
	}
}
