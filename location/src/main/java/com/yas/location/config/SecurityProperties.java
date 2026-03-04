package com.yas.location.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;
import java.util.ArrayList;
import java.util.List;

@Component
@ConfigurationProperties(prefix = "app.security")
public class SecurityProperties {

    private List<Rule> rules = new ArrayList<>();

    public List<Rule> getRules() { return rules; }
    public void setRules(List<Rule> rules) { this.rules = rules; }

    public static class Rule {
        private List<String> patterns = new ArrayList<>();
        private List<String> methods = new ArrayList<>(); // <-- NEW FIELD
        private List<String> roles = new ArrayList<>();
        private boolean permitAll = false;

        public List<String> getPatterns() { return patterns; }
        public void setPatterns(List<String> patterns) { this.patterns = patterns; }

        public List<String> getMethods() { return methods; }
        public void setMethods(List<String> methods) { this.methods = methods; }

        public List<String> getRoles() { return roles; }
        public void setRoles(List<String> roles) { this.roles = roles; }

        public boolean isPermitAll() { return permitAll; }
        public void setPermitAll(boolean permitAll) { this.permitAll = permitAll; }
    }
}
