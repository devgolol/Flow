
package com.flow.coretime.users.config;


import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc; // 이 어노테이션이 필요할 수 있습니다.
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

@Configuration
@EnableWebMvc // Spring MVC 설정을 활성화합니다.
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 웹 요청 경로가 "/resources/"로 시작하면,
        // 실제 src/main/webapp/resources/ 디렉토리에서 파일을 찾도록 매핑합니다.
        registry.addResourceHandler("/resources/**")
                .addResourceLocations("/resources/");
    }
    
    @Bean
    public InternalResourceViewResolver viewResolver() {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix("/WEB-INF/views/");
        resolver.setSuffix(".jsp");
        return resolver;
    }
}
