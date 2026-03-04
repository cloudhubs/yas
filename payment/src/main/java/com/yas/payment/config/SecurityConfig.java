package com.yas.payment.config;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Map;
import java.util.stream.Collectors;
import org.springframework.http.HttpMethod;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.convert.converter.Converter;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationConverter;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http, SecurityProperties securityProps) throws Exception {

        return http
            // Explicitly disable CSRF as requested
            .csrf(AbstractHttpConfigurer::disable)
            .authorizeHttpRequests(auth -> {
                
                // 1. Map rules dynamically from YAML
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
            .oauth2ResourceServer(oauth2 -> oauth2
                .jwt(jwt -> jwt.jwtAuthenticationConverter(jwtAuthenticationConverterForKeycloak()))
            )
            .build();
    }

    @Bean
    public JwtAuthenticationConverter jwtAuthenticationConverterForKeycloak() {
        Converter<Jwt, Collection<GrantedAuthority>> jwtGrantedAuthoritiesConverter = jwt -> {
            Map<String, Collection<String>> realmAccess = jwt.getClaim("realm_access");
            
            // Safe null handling
            if (realmAccess == null || !realmAccess.containsKey("roles")) {
                return java.util.Collections.emptyList(); 
            }
            
            Collection<String> roles = realmAccess.get("roles");
            return roles.stream()
                .map(role -> new SimpleGrantedAuthority("ROLE_" + role))
                .collect(Collectors.toCollection(ArrayList::new)); 
        };

        var jwtAuthenticationConverter = new JwtAuthenticationConverter();
        jwtAuthenticationConverter.setJwtGrantedAuthoritiesConverter(jwtGrantedAuthoritiesConverter);

        return jwtAuthenticationConverter;
    }
}
