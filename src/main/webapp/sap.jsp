<%@ page import="java.io.*" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SAP User Manual Files</title>
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,100..900;1,100..900&display=swap");
        body {
            font-family: "Montserrat", sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f4f4f4;
        }
        h1 {
            text-align: center;
            color: #333;
        }
        ul {
            list-style-type: none;
            padding: 0;
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
        }
        li {
            background-color: #fff;
            margin: 10px;
            padding: 10px;
            border-radius: 5px;
            box-shadow: 0 0 5px rgba(0,0,0,0.1);
            flex: 1 1 calc(40% - 20px); /* 40% width minus margins */
            box-sizing: border-box;
            text-align: center;
        }
        a {
            text-decoration: none;
            color: #8f5a98;
            font-weight: bold;
        }
        a:hover {
            text-decoration: underline;
        }
        @media (max-width: 600px) {
            li {
                flex: 1 1 100%;
            }
        }
    </style>
</head>
<body>
    <h1>User Manual Files</h1>
    <ul>
        <%
            Properties props = new Properties();
            try (InputStream input = getServletContext().getResourceAsStream("/WEB-INF/config.properties")) {
                props.load(input);
            } catch (IOException ex) {
                ex.printStackTrace();
            }
            String sapUploadDir = props.getProperty("sap.upload.dir");
            String dbUrl = props.getProperty("db.url");
            String dbUser = props.getProperty("db.user");
            String dbPassword = props.getProperty("db.password");

            // Display files from the directory
            File dir = new File(sapUploadDir);
            if (dir.exists() && dir.isDirectory()) {
                File[] files = dir.listFiles();
                if (files != null) {
                    Arrays.sort(files, Comparator.comparing(File::getName));
                    for (File file : files) {
                        if (file.isFile() && !file.getName().equals(".DS_Store") && !file.isHidden()) {
                            String fileName = file.getName();
                            String filePath = sapUploadDir + "/" + fileName;
                            out.println("<li><a href='download?file=" + filePath + "' target='_blank'>" + fileName + "</a></li>");
                        }
                    }
                } else {
                    out.println("<li>No files found in the directory.</li>");
                }
            } else {
                out.println("<li>Directory does not exist.</li>");
            }

            // Display links from the database
            try {
                Class.forName("org.postgresql.Driver");
                try (Connection con = DriverManager.getConnection(dbUrl, dbUser, dbPassword)) {
                    String query = "SELECT name FROM upload_files WHERE type = 'link'";
                    try (PreparedStatement ps = con.prepareStatement(query);
                         ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            String link = rs.getString("name");
                            out.println("<li><a href='" + link + "' target='_blank'>" + link + "</a></li>");
                        }
                    }
                }
            } catch (SQLException | ClassNotFoundException e) {
                e.printStackTrace();
                out.println("<li>Error retrieving links from the database.</li>");
            }
        %>
    </ul>
</body>
</html>
