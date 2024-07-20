package FileUpload.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;

@WebServlet("/fileRename")
public class FileRenameServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String category = request.getParameter("category");

        Properties properties = new Properties();
        properties.load(new FileInputStream(getServletContext().getRealPath("/WEB-INF/config.properties")));

        String dirPath = "";
        if ("SAP".equals(category)) {
            dirPath = properties.getProperty("sap.upload.dir");
        } else if ("AGCL".equals(category)) {
            dirPath = properties.getProperty("policies.upload.dir");
        }

        if ("fetch".equals(action)) {
            File dir = new File(dirPath);
            StringBuilder files = new StringBuilder();

            if (dir.exists() && dir.isDirectory()) {
                for (File file : dir.listFiles()) {
                    if (file.isFile() && !file.getName().startsWith(".")) {
                        files.append(file.getName()).append("\n");
                    }
                }
            }

            response.setContentType("text/plain");
            PrintWriter out = response.getWriter();
            out.print(files.toString());
            out.flush();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String category = request.getParameter("category");
        String fileName = request.getParameter("file");
        String newName = request.getParameter("newName");

        Properties properties = new Properties();
        properties.load(new FileInputStream(getServletContext().getRealPath("/WEB-INF/config.properties")));

        String dirPath = "";
        if ("SAP".equals(category)) {
            dirPath = properties.getProperty("sap.upload.dir");
        } else if ("AGCL".equals(category)) {
            dirPath = properties.getProperty("policies.upload.dir");
        }

        if ("rename".equals(action)) {
            File file = new File(dirPath + File.separator + fileName);
            File newFile = new File(dirPath + File.separator + newName);
            boolean success = file.renameTo(newFile);

            response.setContentType("text/plain");
            PrintWriter out = response.getWriter();
            if (success) {
                out.print("File renamed successfully.");
            } else {
                out.print("Failed to rename the file.");
            }
            out.flush();
        }
    }
}
