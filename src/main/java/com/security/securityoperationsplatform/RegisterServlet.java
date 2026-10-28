/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.security.securityoperationsplatform;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (username == null || email == null || password == null
                || username.isBlank()
                || email.isBlank()
                || password.isBlank()) {

            response.sendError(400, "All fields are required.");
            return;
        }

        User existingUser = userDAO.findByUsername(username);

        if (existingUser != null) {
            response.sendError(409, "Username already exists.");
            return;
        }

        String hashedPassword = PasswordUtil.hashPassword(password);

        User user = new User(username, email, hashedPassword);

        if (userDAO.createUser(user)) {
            response.sendRedirect("login.jsp");
        } else {
            response.sendError(500, "Unable to create user.");
        }
    }
}
