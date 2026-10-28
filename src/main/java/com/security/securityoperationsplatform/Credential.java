package com.security.securityoperationsplatform;

public class Credential {

    private int id;
    private int userId;
    private String credentialName;
    private String credentialType;
    private String description;
    private String fileName;
    private String filePath;
    private String uploadedAt;
    private String status;

    public Credential() {
    }

    public Credential(int userId, String credentialName,
                      String credentialType, String description,
                      String fileName, String filePath) {

        this.userId = userId;
        this.credentialName = credentialName;
        this.credentialType = credentialType;
        this.description = description;
        this.fileName = fileName;
        this.filePath = filePath;
        this.status = "ACTIVE";
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getCredentialName() {
        return credentialName;
    }

    public void setCredentialName(String credentialName) {
        this.credentialName = credentialName;
    }

    public String getCredentialType() {
        return credentialType;
    }

    public void setCredentialType(String credentialType) {
        this.credentialType = credentialType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(String uploadedAt) {
        this.uploadedAt = uploadedAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}