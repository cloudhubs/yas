package com.yas.inventory.config;

import java.util.Collection;
import java.util.Map;
import java.util.stream.Collectors;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.convert.converter.Converter;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationConverter;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http, SecurityProperties securityProps) throws Exception {

        return http
            .authorizeHttpRequests(auth -> {
                
                // 1. Map properties dynamically in exact YAML order
                for (SecurityProperties.Rule rule : securityProps.getRules()) {
                    String[] patternsArray = rule.getPatterns().toArray(new String[0]);
                    
                    if (rule.isPermitAll()) {
                        auth.requestMatchers(patternsArray).permitAll();
                    } else if (!rule.getRoles().isEmpty()) {
                        String[] rolesArray = rule.getRoles().toArray(new String[0]);
                        auth.requestMatchers(patternsArray).hasAnyRole(rolesArray);
                    }
                }

                // 2. Catch-all fallback
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
            
            // Safe null handling to prevent NullPointerExceptions
            if (realmAccess == null || !realmAccess.containsKey("roles")) {
                return java.util.Collections.emptyList(); 
            }
            
            Collection<String> roles = realmAccess.get("roles");
            return roles.stream()
                .map(role -> new SimpleGrantedAuthority("ROLE_" + role))
                .collect(Collectors.toList());
        };

        var jwtAuthenticationConverter = new JwtAuthenticationConverter();
        jwtAuthenticationConverter.setJwtGrantedAuthoritiesConverter(jwtGrantedAuthoritiesConverter);

        return jwtAuthenticationConverter;
    }
}
