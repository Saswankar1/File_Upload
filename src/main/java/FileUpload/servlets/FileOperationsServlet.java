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
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

@WebServlet("/fileOperations")
public class FileOperationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String category = request.getParameter("category");

        Properties properties = new Properties();
        properties.load(new FileInputStream(getServletContext().getRealPath("/WEB-INF/config.properties")));

        String dirPath = "";
        if ("sap".equals(category)) {
            dirPath = properties.getProperty("sap.upload.dir");
        } else if ("agcl".equals(category)) {
            dirPath = properties.getProperty("policies.upload.dir");
        }

        if ("fetch".equals(action)) {
            File dir = new File(dirPath);
            List<String> files = new ArrayList<>();

            if (dir.exists() && dir.isDirectory()) {
                for (File file : dir.listFiles()) {
                    if (file.isFile() && !file.getName().startsWith(".")) {
                        files.add(file.getName());
                    }
                }
            }

            StringBuilder json = new StringBuilder();
            json.append("[");
            for (int i = 0; i < files.size(); i++) {
                json.append("\"").append(files.get(i)).append("\"");
                if (i < files.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]");

            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print(json.toString());
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
        String deleteDirPath = "";
        if ("sap".equals(category)) {
            dirPath = properties.getProperty("sap.upload.dir");
            deleteDirPath = properties.getProperty("sap.upload.dir") + "/delete";
        } else if ("agcl".equals(category)) {
            dirPath = properties.getProperty("policies.upload.dir");
            deleteDirPath = properties.getProperty("policies.upload.dir") + "/delete";
        }

        if ("delete".equals(action)) {
            File file = new File(dirPath + File.separator + fileName);
            File deleteDir = new File(deleteDirPath);

            if (!deleteDir.exists()) {
                deleteDir.mkdirs();
            }

            File newFile = new File(deleteDir + File.separator + newName);
            boolean success = file.renameTo(newFile);

            response.setContentType("text/plain");
            PrintWriter out = response.getWriter();
            if (success) {
                out.print("File moved to delete directory and renamed successfully.");
            } else {
                out.print("Failed to move and rename the file.");
            }
            out.flush();
        }
    }
}
