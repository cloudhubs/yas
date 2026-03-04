package com.yas.storefrontbff.config;

import java.util.*;
import java.util.stream.Collectors;
import org.springframework.http.HttpMethod;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.reactive.EnableWebFluxSecurity;
import org.springframework.security.config.web.server.ServerHttpSecurity;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.authority.mapping.GrantedAuthoritiesMapper;
import org.springframework.security.oauth2.client.oidc.web.server.logout.OidcClientInitiatedServerLogoutSuccessHandler;
import org.springframework.security.oauth2.client.registration.ReactiveClientRegistrationRepository;
import org.springframework.security.oauth2.core.oidc.user.OidcUserAuthority;
import org.springframework.security.oauth2.core.user.OAuth2UserAuthority;
import org.springframework.security.web.server.SecurityWebFilterChain;
import org.springframework.security.web.server.authentication.logout.ServerLogoutSuccessHandler;

@Configuration
@EnableWebFluxSecurity
public class SecurityConfig {
    private static final String REALM_ACCESS_CLAIM = "realm_access";
    private static final String ROLES_CLAIM = "roles";

    private final ReactiveClientRegistrationRepository clientRegistrationRepository;

    public SecurityConfig(ReactiveClientRegistrationRepository clientRegistrationRepository) {
        this.clientRegistrationRepository = clientRegistrationRepository;
    }

    @Bean
    public SecurityWebFilterChain springSecurityFilterChain(ServerHttpSecurity http, SecurityProperties securityProps) {
        
        http.authorizeExchange(auth -> {
            for (SecurityProperties.Rule rule : securityProps.getRules()) {
                String[] patternsArray = rule.getPatterns().toArray(new String[0]);
                
                if (rule.getMethods() != null && !rule.getMethods().isEmpty()) {
                    for (String method : rule.getMethods()) {
                        HttpMethod httpMethod = HttpMethod.valueOf(method.toUpperCase());
                        if (rule.isPermitAll()) {
                            auth.pathMatchers(httpMethod, patternsArray).permitAll();
                        } else if (rule.isAuthenticated()) {
                            auth.pathMatchers(httpMethod, patternsArray).authenticated();
                        } else if (!rule.getRoles().isEmpty()) {
                            String[] rolesArray = rule.getRoles().toArray(new String[0]);
                            auth.pathMatchers(httpMethod, patternsArray).hasAnyRole(rolesArray);
                        }
                    }
                } else {
                    if (rule.isPermitAll()) {
                        auth.pathMatchers(patternsArray).permitAll();
                    } else if (rule.isAuthenticated()) {
                        auth.pathMatchers(patternsArray).authenticated();
                    } else if (!rule.getRoles().isEmpty()) {
                        String[] rolesArray = rule.getRoles().toArray(new String[0]);
                        auth.pathMatchers(patternsArray).hasAnyRole(rolesArray);
                    }
                }
            }
            auth.anyExchange().permitAll();
        });

        return http
            .oauth2Login(Customizer.withDefaults())
            .httpBasic(ServerHttpSecurity.HttpBasicSpec::disable)
            .formLogin(ServerHttpSecurity.FormLoginSpec::disable)
            .csrf(ServerHttpSecurity.CsrfSpec::disable)
            .logout(logout -> logout.logoutSuccessHandler(oidcLogoutSuccessHandler()))
            .build();
    }

    private ServerLogoutSuccessHandler oidcLogoutSuccessHandler() {
        OidcClientInitiatedServerLogoutSuccessHandler oidcLogoutSuccessHandler =
            new OidcClientInitiatedServerLogoutSuccessHandler(this.clientRegistrationRepository);
        oidcLogoutSuccessHandler.setPostLogoutRedirectUri("{baseUrl}");
        return oidcLogoutSuccessHandler;
    }

    @Bean
    @SuppressWarnings("unchecked")
    public GrantedAuthoritiesMapper userAuthoritiesMapperForKeycloak() {
        return authorities -> {
            Set<GrantedAuthority> mappedAuthorities = new HashSet<>();
            if (authorities.isEmpty()) return mappedAuthorities;
            
            var authority = authorities.iterator().next();
            boolean isOidc = authority instanceof OidcUserAuthority;

            if (isOidc) {
                var oidcUserAuthority = (OidcUserAuthority) authority;
                var userInfo = oidcUserAuthority.getUserInfo();

                if (userInfo.hasClaim(REALM_ACCESS_CLAIM)) {
                    var realmAccess = userInfo.getClaimAsMap(REALM_ACCESS_CLAIM);
                    var roles = (Collection<String>) realmAccess.get(ROLES_CLAIM);
                    mappedAuthorities.addAll(generateAuthoritiesFromClaim(roles));
                }
            } else if (authority instanceof OAuth2UserAuthority) {
                var oauth2UserAuthority = (OAuth2UserAuthority) authority;
                Map<String, Object> userAttributes = oauth2UserAuthority.getAttributes();

                if (userAttributes.containsKey(REALM_ACCESS_CLAIM)) {
                    var realmAccess = (Map<String, Object>) userAttributes.get(REALM_ACCESS_CLAIM);
                    var roles = (Collection<String>) realmAccess.get(ROLES_CLAIM);
                    mappedAuthorities.addAll(generateAuthoritiesFromClaim(roles));
                }
            }

            return mappedAuthorities;
        };
    }

    Collection<GrantedAuthority> generateAuthoritiesFromClaim(Collection<String> roles) {
        if (roles == null) return Collections.emptyList(); 
        return roles.stream()
            .map(role -> new SimpleGrantedAuthority("ROLE_" + role))
            .collect(Collectors.toList());
    }
}
