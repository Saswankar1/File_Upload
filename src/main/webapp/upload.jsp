<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upload Form</title>
    <link rel="stylesheet" type="text/css" href="styles/upload1.css">
    <style type="text/css">
    	input{
          width: 92%;
		  padding: 10px;
		  margin-bottom: 30px;
		  border: 1.2px solid #ccc;
		  border-radius: 4px;
    	}
    </style>
</head>
<body>
    <img src="images/AGCL.png" class="logo"> 
    <div class="container">
        <div class="header">
            <img src="images/paper-plane.png" alt="Paper Plane" width="70">
            <div>Send us your Files!</div>
        </div>
        <form id="uploadForm" action="FileUploadServlet" method="post" enctype="multipart/form-data">
            <label for="fileType">Select your file type</label>
            <select id="fileType" name="fileType" required>
                <option value="">Please Select</option>
                <option value="pdf">PDF</option>
                <option value="doc">DOC</option>
                <option value="link">Link</option>
            </select>
            <label for="category">Select the category</label>
            <select id="category" name="category" required>
                <option value="">Please Select</option>
                <option value="SAP User Manual">SAP User Manual</option>
                <option value="AGCL common policies">AGCL Common Policies</option>
            </select>
            <div id="sapOptions" style="display: none;">
                <label for="sapType">SAP Options</label>
                <select id="sapType" name="sapType">
                    <option value="">Please Select</option>
                    <option value="file">File</option>
                    <option value="link">Link</option>
                </select>
                <div id="linkInput" style="display: none;">
                    <label for="link">Enter Link</label>
                    <input type="url" id="link" name="link">
                </div>
            </div>
            <div id="fileUpload" class="file-upload">
                <label for="file" class="custom-file-upload">
                    <img class="upload_img" src="upload-3-xl.webp" alt="">
                    BROWSE
                </label>
                <input type="file" id="file" name="file" required>
            </div>
            <button type="submit">UPLOAD</button>
        </form>
    </div>

    <script>
        // Elements
        const fileTypeSelect = document.getElementById('fileType');
        const categorySelect = document.getElementById('category');
        const sapOptions = document.getElementById('sapOptions');
        const sapTypeSelect = document.getElementById('sapType');
        const linkInput = document.getElementById('linkInput');
        const fileUpload = document.getElementById('fileUpload');
        const fileInput = document.getElementById('file');
        const customFileUpload = document.querySelector('.custom-file-upload');

        // Event listeners
        categorySelect.addEventListener('change', function() {
            if (categorySelect.value === 'SAP User Manual') {
                sapOptions.style.display = 'block';
            } else {
                sapOptions.style.display = 'none';
                sapTypeSelect.value = '';
                linkInput.style.display = 'none';
                fileUpload.style.display = 'block';
                fileInput.required = true;
            }
        });

        sapTypeSelect.addEventListener('change', function() {
            if (sapTypeSelect.value === 'link') {
                linkInput.style.display = 'block';
                fileUpload.style.display = 'none';
                fileInput.required = false;
            } else {
                linkInput.style.display = 'none';
                fileUpload.style.display = 'block';
                fileInput.required = true;
            }
        });

        fileTypeSelect.addEventListener('change', function() {
            if (fileTypeSelect.value === 'link') {
                categorySelect.value = 'SAP User Manual';
                sapOptions.style.display = 'block';
                sapTypeSelect.value = 'link';
                linkInput.style.display = 'block';
                fileUpload.style.display = 'none';
                fileInput.required = false;
            } else {
                categorySelect.value = '';
                sapOptions.style.display = 'none';
                sapTypeSelect.value = '';
                linkInput.style.display = 'none';
                fileUpload.style.display = 'block';
                fileInput.required = true;
            }
        });

        // File input change event
        fileInput.addEventListener('change', function() {
            if (fileInput.files.length > 0) {
                customFileUpload.style.backgroundColor = '#fff';  
                customFileUpload.style.color = '#383368';  
                customFileUpload.textContent = 'File selected'; 
            } else {
                customFileUpload.style.backgroundColor = '#383368';  
                customFileUpload.style.color = 'white';  
                customFileUpload.textContent = 'Click to upload';  
            }
        });
    </script>
</body>
</html>
