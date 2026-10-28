
package com.security.securityoperationsplatform;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID;

@WebServlet("/credentials")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 10 * 1024 * 1024,
        maxRequestSize = 12 * 1024 * 1024
)
public class CredentialServlet extends HttpServlet {

    private CredentialDAO credentialDAO;
    private CredentialActivityDAO credentialActivityDAO;

    @Override
    public void init() {
        credentialDAO = new CredentialDAO();
        credentialActivityDAO = new CredentialActivityDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        String username = getUsername(session);
        String sourceIp = request.getRemoteAddr();

        String action = request.getParameter("action");

        // ==========================================
        // VIEW UPLOADED CREDENTIAL FILE
        // ==========================================
        if ("view".equals(action)) {

            String idParameter = request.getParameter("id");

            if (idParameter == null || idParameter.trim().isEmpty()) {
                response.sendRedirect("credentials?error=failed");
                return;
            }

            int id;

            try {
                id = Integer.parseInt(idParameter);
            } catch (NumberFormatException e) {
                response.sendRedirect("credentials?error=failed");
                return;
            }

            Credential credential = credentialDAO.getCredentialById(id);

            if (credential == null) {
                response.sendRedirect("credentials?error=failed");
                return;
            }

            if (credential.getUserId() != userId) {
                response.sendRedirect("credentials?error=failed");
                return;
            }

            if (credential.getFilePath() == null
                    || credential.getFilePath().trim().isEmpty()) {

                response.sendRedirect("credentials?error=nofile");
                return;
            }

            String uploadDirectory =
                    getServletContext().getRealPath("/uploads/credentials");

            if (uploadDirectory == null) {
                response.sendRedirect("credentials?error=filemissing");
                return;
            }

            Path filePath = Paths.get(uploadDirectory)
                    .resolve(
                            Paths.get(credential.getFilePath())
                                    .getFileName()
                                    .toString()
                    )
                    .normalize();

            if (!Files.exists(filePath)
                    || !Files.isRegularFile(filePath)) {

                response.sendRedirect("credentials?error=filemissing");
                return;
            }

            // ==========================================
            // LOG VIEW ACTIVITY
            // ==========================================

            credentialActivityDAO.addActivity(
                    credential.getId(),
                    userId,
                    username,
                    "VIEW",
                    "Credential viewed: "
                            + credential.getCredentialName(),
                    sourceIp,
                    "SUCCESS"
            );

            String contentType =
                    getServletContext().getMimeType(
                            filePath.getFileName().toString()
                    );

            if (contentType == null) {
                contentType = "application/octet-stream";
            }

            response.setContentType(contentType);

            if (contentType.startsWith("image/")
                    || contentType.equals("application/pdf")
                    || contentType.equals("text/plain")) {

                response.setHeader(
                        "Content-Disposition",
                        "inline; filename=\""
                                + credential.getFileName()
                                + "\""
                );

            } else {

                response.setHeader(
                        "Content-Disposition",
                        "attachment; filename=\""
                                + credential.getFileName()
                                + "\""
                );
            }

            response.setContentLengthLong(Files.size(filePath));

            try (InputStream inputStream =
                         Files.newInputStream(filePath)) {

                inputStream.transferTo(
                        response.getOutputStream()
                );

            } catch (IOException e) {
                e.printStackTrace();
            }

            return;
        }

        // ==========================================
        // NORMAL CREDENTIAL LIST
        // ==========================================

        List<Credential> credentials =
                credentialDAO.getCredentialsByUserId(userId);

        // GET CREDENTIAL ACTIVITY HISTORY
        List<CredentialActivity> activities =
                credentialActivityDAO.getActivitiesByUserId(userId);

        request.setAttribute("credentials", credentials);
        request.setAttribute("activities", activities);

        request.getRequestDispatcher("credential-center.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        String username = getUsername(session);
        String sourceIp = request.getRemoteAddr();

        String action = request.getParameter("action");

        // ==========================================
        // EDIT CREDENTIAL
        // ==========================================

        if ("edit".equals(action)) {

            String idParameter = request.getParameter("id");

            if (idParameter == null || idParameter.trim().isEmpty()) {
                response.sendRedirect("credentials?error=failed");
                return;
            }

            int id;

            try {
                id = Integer.parseInt(idParameter);
            } catch (NumberFormatException e) {
                response.sendRedirect("credentials?error=failed");
                return;
            }

            String credentialName =
                    request.getParameter("credentialName");

            String credentialType =
                    request.getParameter("credentialType");

            String description =
                    request.getParameter("description");

            if (credentialName == null
                    || credentialName.trim().isEmpty()
                    || credentialType == null
                    || credentialType.trim().isEmpty()) {

                response.sendRedirect("credentials?error=required");
                return;
            }

            boolean success =
                    credentialDAO.updateCredential(
                            id,
                            userId,
                            credentialName.trim(),
                            credentialType.trim(),
                            description
                    );

            // ==========================================
            // LOG EDIT ACTIVITY
            // ==========================================

            if (success) {

                credentialActivityDAO.addActivity(
                        id,
                        userId,
                        username,
                        "EDIT",
                        "Credential information updated: "
                                + credentialName.trim(),
                        sourceIp,
                        "SUCCESS"
                );

                response.sendRedirect(
                        "credentials?success=updated"
                );

            } else {

                credentialActivityDAO.addActivity(
                        id,
                        userId,
                        username,
                        "EDIT",
                        "Failed to update credential",
                        sourceIp,
                        "FAILED"
                );

                response.sendRedirect(
                        "credentials?error=failed"
                );
            }

            return;
        }

        // ==========================================
        // DELETE CREDENTIAL
        // ==========================================

        if ("delete".equals(action)) {

            String idParameter = request.getParameter("id");

            if (idParameter == null || idParameter.trim().isEmpty()) {
                response.sendRedirect("credentials?error=failed");
                return;
            }

            int id;

            try {
                id = Integer.parseInt(idParameter);
            } catch (NumberFormatException e) {
                response.sendRedirect("credentials?error=failed");
                return;
            }

            Credential credential =
                    credentialDAO.getCredentialById(id);

            String credentialName = "Unknown Credential";

            if (credential != null
                    && credential.getUserId() == userId) {

                credentialName =
                        credential.getCredentialName();
            }

            boolean success =
                    credentialDAO.deleteCredential(id, userId);

            // ==========================================
            // LOG DELETE ACTIVITY
            // ==========================================

            if (success) {

                credentialActivityDAO.addActivity(
                        id,
                        userId,
                        username,
                        "DELETE",
                        "Credential removed: "
                                + credentialName,
                        sourceIp,
                        "SUCCESS"
                );

                response.sendRedirect(
                        "credentials?success=deleted"
                );

            } else {

                credentialActivityDAO.addActivity(
                        id,
                        userId,
                        username,
                        "DELETE",
                        "Failed to remove credential",
                        sourceIp,
                        "FAILED"
                );

                response.sendRedirect(
                        "credentials?error=failed"
                );
            }

            return;
        }

        // ==========================================
        // ADD CREDENTIAL
        // ==========================================

        String credentialName =
                request.getParameter("credentialName");

        String credentialType =
                request.getParameter("credentialType");

        String description =
                request.getParameter("description");

        if (credentialName == null
                || credentialName.trim().isEmpty()
                || credentialType == null
                || credentialType.trim().isEmpty()) {

            response.sendRedirect("credentials?error=required");
            return;
        }

        Part filePart =
                request.getPart("credentialFile");

        String originalFileName = null;
        String relativeFilePath = null;
        Path savedFile = null;

        try {

            // ==========================================
            // FILE UPLOAD
            // ==========================================

            if (filePart != null
                    && filePart.getSize() > 0) {

                String submittedFileName =
                        filePart.getSubmittedFileName();

                if (submittedFileName != null
                        && !submittedFileName.trim().isEmpty()) {

                    originalFileName =
                            Paths.get(submittedFileName)
                                    .getFileName()
                                    .toString();

                    String extension = "";

                    int dotIndex =
                            originalFileName.lastIndexOf('.');

                    if (dotIndex > 0) {

                        extension =
                                originalFileName
                                        .substring(dotIndex)
                                        .toLowerCase();
                    }

                    String[] allowedExtensions = {
                        ".pdf",
                        ".doc",
                        ".docx",
                        ".xls",
                        ".xlsx",
                        ".ppt",
                        ".pptx",
                        ".jpg",
                        ".jpeg",
                        ".png",
                        ".gif",
                        ".webp",
                        ".txt"
                    };

                    boolean allowed = false;

                    for (String allowedExtension
                            : allowedExtensions) {

                        if (allowedExtension.equals(extension)) {
                            allowed = true;
                            break;
                        }
                    }

                    if (!allowed) {

                        response.sendRedirect(
                                "credentials?error=filetype"
                        );

                        return;
                    }

                    String uploadDirectory =
                            getServletContext().getRealPath(
                                    "/uploads/credentials"
                            );

                    if (uploadDirectory == null) {

                        response.sendRedirect(
                                "credentials?error=failed"
                        );

                        return;
                    }

                    Path uploadPath =
                            Paths.get(uploadDirectory);

                    Files.createDirectories(uploadPath);

                    String uniqueFileName =
                            UUID.randomUUID().toString()
                                    + extension;

                    savedFile =
                            uploadPath.resolve(
                                    uniqueFileName
                            );

                    try (InputStream inputStream =
                                 filePart.getInputStream()) {

                        Files.copy(
                                inputStream,
                                savedFile,
                                StandardCopyOption.REPLACE_EXISTING
                        );
                    }

                    relativeFilePath =
                            "uploads/credentials/"
                                    + uniqueFileName;
                }
            }

            // ==========================================
            // SAVE CREDENTIAL INFORMATION
            // ==========================================

            Credential credential =
                    new Credential(
                            userId,
                            credentialName.trim(),
                            credentialType.trim(),
                            description,
                            originalFileName,
                            relativeFilePath
                    );

            int credentialId =
                    credentialDAO.addCredential(credential);

            boolean success =
                    credentialId > 0;

            // ==========================================
            // LOG ADD ACTIVITY
            // ==========================================

            if (success) {

                credentialActivityDAO.addActivity(
                        credentialId,
                        userId,
                        username,
                        "ADD",
                        "Credential uploaded: "
                                + credential.getCredentialName(),
                        sourceIp,
                        "SUCCESS"
                );
            }

            if (!success && savedFile != null) {

                try {
                    Files.deleteIfExists(savedFile);

                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            if (success) {

                response.sendRedirect(
                        "credentials?success=added"
                );

            } else {

                response.sendRedirect(
                        "credentials?error=failed"
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            if (savedFile != null) {

                try {
                    Files.deleteIfExists(savedFile);

                } catch (IOException cleanupException) {
                    cleanupException.printStackTrace();
                }
            }

            response.sendRedirect(
                    "credentials?error=failed"
            );
        }
    }

    // ==========================================
    // GET USERNAME FROM SESSION
    // ==========================================

    private String getUsername(HttpSession session) {

        Object username =
                session.getAttribute("username");

        if (username != null) {
            return username.toString();
        }

        return "UNKNOWN";
    }
}
