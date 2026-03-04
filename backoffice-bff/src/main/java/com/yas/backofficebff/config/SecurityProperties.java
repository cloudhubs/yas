package com.yas.backofficebff.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;
import java.util.ArrayList;
import java.util.List;

@Component
@ConfigurationProperties(prefix = "security")
public class SecurityProperties {

    private List<String> permitAll = new ArrayList<>();
    private List<PathRole> pathRoles = new ArrayList<>();
    private List<String> anyExchangeRoles = new ArrayList<>();

    public List<String> getPermitAll() { return permitAll; }
    public void setPermitAll(List<String> permitAll) { this.permitAll = permitAll; }

    public List<PathRole> getPathRoles() { return pathRoles; }
    public void setPathRoles(List<PathRole> pathRoles) { this.pathRoles = pathRoles; }

    public List<String> getAnyExchangeRoles() { return anyExchangeRoles; }
    public void setAnyExchangeRoles(List<String> anyExchangeRoles) { this.anyExchangeRoles = anyExchangeRoles; }

    public static class PathRole {
        private String path;
        private List<String> roles = new ArrayList<>();

        public String getPath() { return path; }
        public void setPath(String path) { this.path = path; }

        public List<String> getRoles() { return roles; }
        public void setRoles(List<String> roles) { this.roles = roles; }
    }
}
