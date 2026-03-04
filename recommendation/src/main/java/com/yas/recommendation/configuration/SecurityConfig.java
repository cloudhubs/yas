package com.yas.recommendation.configuration;

import org.springframework.http.HttpMethod;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;


@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http, SecurityProperties securityProps) throws Exception {

        return http
            .authorizeHttpRequests(auth -> {
                for (SecurityProperties.Rule rule : securityProps.getRules()) {
                    String[] patternsArray = rule.getPatterns().toArray(new String[0]);
                    
                    if (rule.getMethods() != null && !rule.getMethods().isEmpty()) {
                        for (String method : rule.getMethods()) {
                            HttpMethod httpMethod = HttpMethod.valueOf(method.toUpperCase());
                            if (rule.isPermitAll()) {
                                auth.requestMatchers(httpMethod, patternsArray).permitAll();
                            } else if (!rule.getRoles().isEmpty()) {
                                String[] rolesArray = rule.getRoles().toArray(new String[0]);
                                auth.requestMatchers(httpMethod, patternsArray).hasAnyRole(rolesArray);
                            }
                        }
                    } else {
                        if (rule.isPermitAll()) {
                            auth.requestMatchers(patternsArray).permitAll();
                        } else if (!rule.getRoles().isEmpty()) {
                            String[] rolesArray = rule.getRoles().toArray(new String[0]);
                            auth.requestMatchers(patternsArray).hasAnyRole(rolesArray);
                        }
                    }
                }
                auth.anyRequest().authenticated();
            })
            .oauth2ResourceServer(oauth2 -> oauth2.jwt(Customizer.withDefaults()))
            .build();
    }
}
