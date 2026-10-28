package com.security.securityoperationsplatform;

public class IOC {

    private int id;
    private String iocType;
    private String iocValue;
    private String threatLevel;
    private String status;
    private String source;
    private String description;
    private String createdAt;

    public IOC() {
    }

    public IOC(
            String iocType,
            String iocValue,
            String threatLevel,
            String source,
            String description) {

        this.iocType = iocType;
        this.iocValue = iocValue;
        this.threatLevel = threatLevel;
        this.status = "ACTIVE";
        this.source = source;
        this.description = description;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getIocType() {
        return iocType;
    }

    public void setIocType(String iocType) {
        this.iocType = iocType;
    }

    public String getIocValue() {
        return iocValue;
    }

    public void setIocValue(String iocValue) {
        this.iocValue = iocValue;
    }

    public String getThreatLevel() {
        return threatLevel;
    }

    public void setThreatLevel(String threatLevel) {
        this.threatLevel = threatLevel;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }
}