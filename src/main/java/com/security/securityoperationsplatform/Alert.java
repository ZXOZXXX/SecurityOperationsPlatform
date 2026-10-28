package com.security.securityoperationsplatform;

public class Alert {

    private int id;
    private String title;
    private String description;
    private String severity;
    private String sourceIp;
    private String status;
    private String createdAt;

    public Alert() {
    }

    public Alert(
            String title,
            String description,
            String severity,
            String sourceIp) {

        this.title = title;
        this.description = description;
        this.severity = severity;
        this.sourceIp = sourceIp;
        this.status = "OPEN";
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getSeverity() {
        return severity;
    }

    public void setSeverity(String severity) {
        this.severity = severity;
    }

    public String getSourceIp() {
        return sourceIp;
    }

    public void setSourceIp(String sourceIp) {
        this.sourceIp = sourceIp;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }
}