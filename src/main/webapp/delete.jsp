<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete File</title>
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,100..900;1,100..900&display=swap");
        :root {
            --pc: #8f5a98; 
        }
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            font-family: 'Montserrat', Arial, sans-serif;
            background-color: #f0f0f0;
        }
        .logo {
            position: absolute;
            top: 20px;
            left: 20px;
        }
        .logo img {
            width: 70%;
        }
        .form-container {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 400px;
        }
        h2 {
            text-align: center;
            color: var(--pc);
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            color: #333;
        }
        input{
        	width: 94%;
            padding: 12px;
            margin-bottom: 26px;
            border-radius: 5px;
            border: 1px solid #ddd;
            font-size: 16px;
        }
        select, button {
            width: 100%;
            padding: 12px;
            margin-bottom: 16px;
            border-radius: 5px;
            border: 1px solid #ddd;
            font-size: 16px;
        }
         .btn-signin{
         	width: 94%;
            padding: 12px;
            margin-bottom: 16px;
            border-radius: 5px;
            border: 1px solid #ddd;
            font-size: 15px;
         }
        button, .btn-signin {
            background-color: var(--pc);
            color: white;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            border: 1.2px solid var(--pc);
            transition: 1s ease;
        }
        button:hover, .btn-signin:hover {
            background: none;
            color: var(--pc);
        }
        .btn-signin {
            display: block;
            margin-top: 10px;
        }
        /* Modal styles */
        .modal {
            display: none; 
            position: fixed; 
            z-index: 1; 
            padding-top: 100px; 
            left: 0;
            top: 0;
            width: 100%; 
            height: 100%; 
            overflow: auto; 
            background-color: rgba(0,0,0,0.4); 
        }
        .modal-content {
            background-color: #fefefe;
            margin: auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
            max-width: 500px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }
        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }
        .modal h2 {
            margin-top: 0;
        }
        .modal-buttons {
            display: flex;
            justify-content: space-between;
        }
        .modal-buttons button {
            width: 48%;
        }
    </style>
</head>
<body>
    <div class="logo">
        <img alt="AGCL Logo" src="images/AGCL.png">
    </div>
    <div class="form-container">
        <h2>DELETE FILE</h2>
        <form id="deleteForm">
            <label for="category">Select Category:</label>
            <select id="category" name="category" onchange="fetchFiles(this.value)">
                <option value="">Select a category</option>
                <option value="sap">SAP User Manual</option>
                <option value="agcl">AGCL Common Policies</option>
            </select>
            <label for="fileList">Select File:</label>
            <select id="fileList" name="fileList">
                <option value="">Select a file</option>
            </select>
            <label for="newName">New Name:</label>
            <input type="text" id="newName" name="newName" placeholder="Enter new file name">
            <button type="button" onclick="confirmDelete()">Delete</button>
            <a href="home.jsp" class="btn-signin">BACK</a>
        </form>
    </div>

    <!-- The Modal -->
    <div id="myModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h2 id="modalTitle"></h2>
            <p id="modalMessage"></p>
            <div class="modal-buttons" id="modalButtons">
                <button id="confirmYes" onclick="deleteFile()">Yes</button>
                <button id="confirmNo" onclick="closeModal()">No</button>
            </div>
        </div>
    </div>

    <script>
        function fetchFiles(category) {
            if (!category) return; 
            var xhr = new XMLHttpRequest(); 
            xhr.open('GET', 'fileOperations?action=fetch&category=' + category, true); 
            xhr.onreadystatechange = function() { 
                if (xhr.readyState === 4 && xhr.status === 200) { 
                    console.log(xhr.responseText);  
                    try {
                        var files = JSON.parse(xhr.responseText); 
                        var fileList = document.getElementById('fileList'); 
                        fileList.innerHTML = '<option value="">Select a file</option>'; 
                        files.forEach(function(file) {
                            var option = document.createElement('option'); 
                            option.value = file; 
                            option.text = file; 
                            fileList.add(option); 
                        });
                    } catch (e) {
                        console.error('Failed to parse JSON:', e); 
                    }
                }
            };
            xhr.send(); 
        }

        function confirmDelete() {
            var file = document.getElementById('fileList').value; 
            var category = document.getElementById('category').value; 
            var newName = document.getElementById('newName').value;

            if (!file || !category) return;

            var modal = document.getElementById("myModal");
            var modalTitle = document.getElementById("modalTitle");
            var modalMessage = document.getElementById("modalMessage");
            var modalButtons = document.getElementById("modalButtons");

            modalTitle.textContent = "Confirm Delete";
            modalMessage.textContent = "Are you sure you want to delete the file \"" + file + "\" and rename it to \"" + newName + "\"?";
            modalButtons.style.display = "flex";

            modal.style.display = "block";
        }

        function deleteFile() {
            var file = document.getElementById('fileList').value; 
            var category = document.getElementById('category').value; 
            var newName = document.getElementById('newName').value;

            if (!file || !category) return; 
            var xhr = new XMLHttpRequest(); 
            xhr.open('POST', 'fileOperations', true); 
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded'); 
            xhr.onreadystatechange = function() { 
                if (xhr.readyState === 4 && xhr.status === 200) { 
                    showModal(xhr.responseText); 
                    fetchFiles(category);  
                }
            };
            xhr.send('action=delete&category=' + category + '&file=' + encodeURIComponent(file) + '&newName=' + encodeURIComponent(newName)); 
            closeModal();
        }

        function showModal(message) {
            var modal = document.getElementById("myModal");
            var modalTitle = document.getElementById("modalTitle");
            var modalMessage = document.getElementById("modalMessage");
            var modalButtons = document.getElementById("modalButtons");

            modalTitle.textContent = "File Operation";
            modalMessage.textContent = message;

            // Hide the modal buttons
            modalButtons.style.display = "none";

            modal.style.display = "block";

            var span = document.getElementsByClassName("close")[0];
            span.onclick = function() {
                modal.style.display = "none";
            };

            window.onclick = function(event) {
                if (event.target == modal) {
                    modal.style.display = "none";
                }
            };
        }

        function closeModal() {
            var modal = document.getElementById("myModal");
            modal.style.display = "none";
        }
    </script>
</body>
</html>
