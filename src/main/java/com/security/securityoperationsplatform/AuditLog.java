package com.security.securityoperationsplatform;

public class AuditLog {

    private int id;
    private String username;
    private String action;
    private String description;
    private String sourceIp;
    private String createdAt;

    public AuditLog() {
    }

    public AuditLog(
            String username,
            String action,
            String description,
            String sourceIp) {

        this.username = username;
        this.action = action;
        this.description = description;
        this.sourceIp = sourceIp;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getSourceIp() {
        return sourceIp;
    }

    public void setSourceIp(String sourceIp) {
        this.sourceIp = sourceIp;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }
}