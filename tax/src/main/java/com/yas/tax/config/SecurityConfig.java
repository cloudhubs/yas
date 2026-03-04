package com.yas.tax.config;

import java.util.*;
import java.util.stream.Collectors;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.convert.converter.Converter;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
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
            .authorizeHttpRequests(auth -> {
                for (SecurityProperties.Rule rule : securityProps.getRules()) {
                    var matcher = auth.requestMatchers(rule.getPatterns().toArray(String[]::new));
                    if (rule.isPermitAll()) matcher.permitAll();
                    else if (!rule.getRoles().isEmpty()) matcher.hasAnyRole(rule.getRoles().toArray(String[]::new));
                }
                auth.anyRequest().authenticated();
            })
            .oauth2ResourceServer(oauth -> oauth.jwt(
                jwt -> jwt.jwtAuthenticationConverter(jwtAuthenticationConverterForKeycloak())
            ))
            .build();
    }

    @Bean
    public JwtAuthenticationConverter jwtAuthenticationConverterForKeycloak() {
        Converter<Jwt, Collection<GrantedAuthority>> jwtGrantedAuthoritiesConverter = jwt -> {
            Map<String, Object> realmAccess = jwt.getClaim("realm_access");
            if (realmAccess == null || !realmAccess.containsKey("roles")) {
                return Collections.emptyList();
            }

            Collection<String> roles = (Collection<String>) realmAccess.get("roles");
            return roles.stream()
                .map(role -> new SimpleGrantedAuthority("ROLE_" + role))
                .collect(Collectors.toList());
        };

        var converter = new JwtAuthenticationConverter();
        converter.setJwtGrantedAuthoritiesConverter(jwtGrantedAuthoritiesConverter);
        return converter;
    }
}