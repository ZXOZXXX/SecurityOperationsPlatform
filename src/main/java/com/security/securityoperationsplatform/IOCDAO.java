package com.security.securityoperationsplatform;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class IOCDAO {

    public boolean createIOC(IOC ioc) {

        String sql = """
                INSERT INTO iocs
                (ioc_type, ioc_value, threat_level, status,
                 source, description)
                VALUES (?, ?, ?, ?, ?, ?)
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, ioc.getIocType());
            statement.setString(2, ioc.getIocValue());
            statement.setString(3, ioc.getThreatLevel());
            statement.setString(4, ioc.getStatus());
            statement.setString(5, ioc.getSource());
            statement.setString(6, ioc.getDescription());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
            return false;
        }
    }

    public IOC findByValue(String iocValue) {

        String sql = """
                SELECT *
                FROM iocs
                WHERE ioc_value = ?
                AND status = 'ACTIVE'
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, iocValue);

            ResultSet result = statement.executeQuery();

            if (result.next()) {

                IOC ioc = new IOC();

                ioc.setId(result.getInt("id"));
                ioc.setIocType(result.getString("ioc_type"));
                ioc.setIocValue(result.getString("ioc_value"));
                ioc.setThreatLevel(result.getString("threat_level"));
                ioc.setStatus(result.getString("status"));
                ioc.setSource(result.getString("source"));
                ioc.setDescription(result.getString("description"));

                return ioc;
            }
         
        } catch (SQLException e) {

            e.printStackTrace();
        }

        return null;
    }
    
    public List<IOC> getAllIOCs() {

    List<IOC> iocs = new ArrayList<>();

    String sql = """
            SELECT *
            FROM iocs
            ORDER BY id DESC
            """;

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement statement =
                 connection.prepareStatement(sql);
         ResultSet result = statement.executeQuery()) {

        while (result.next()) {

            IOC ioc = new IOC();

            ioc.setId(result.getInt("id"));
            ioc.setIocType(result.getString("ioc_type"));
            ioc.setIocValue(result.getString("ioc_value"));
            ioc.setThreatLevel(result.getString("threat_level"));
            ioc.setStatus(result.getString("status"));
            ioc.setSource(result.getString("source"));
            ioc.setDescription(result.getString("description"));

            iocs.add(ioc);
        }

    } catch (SQLException e) {

        e.printStackTrace();
    }

    return iocs;
}
}