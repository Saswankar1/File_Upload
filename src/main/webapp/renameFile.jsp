<!DOCTYPE html>
<html>
<head>
    <title>Rename File</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,100..900;1,100..900&display=swap");
        :root {
            --pc: #8f5a98; 
        }
        body {
            font-family: 'Montserrat', sans-serif;
            background-color: #f0f0f0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .container {
            background-color: #fff;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            text-align: center;
            width: 90%;
            max-width: 500px;
        }

        .container h2 {
            color: var(--pc);
            margin-bottom: 20px;
        }

        .container label {
            display: block;
            margin: 10px 0 5px;
        }

        .container select {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
		.container input[type="text"]{
			width: 95%;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
		}
        .container button, .btn1, .btn{
            background-color: var(--pc);
            color: white;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            border: 1.2px solid var(--pc);
            transition: 1s ease;
            width: 94%;
            padding: 12px;
            margin-bottom: 16px;
            border-radius: 5px;
            font-size: 15px;
        }
        .btn1{
			display: block;
			width: 89%;
           	margin-left: 14px; 
		}
        .btn {
            width: 40%;
           
        }
        .container button:hover, .btn:hover, .btn1:hover {
            background: none;
            color: var(--pc);
        }

        .logo img {
            max-width: 100px;
            margin-bottom: 20px;
        }

        /* Modal styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.4);
        }

        .modal-content {
            background-color: #fff;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
            max-width: 500px;
            text-align: center;
            border-radius: 10px;
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

        .btn-container {
            margin-top: 10px;
        }

    </style>
    <script>
        $(document).ready(function() {
            $('#category').change(function() {
                var category = $(this).val();
                if (category !== '') {
                    fetchFiles(category);
                }
            });

            function fetchFiles(category) {
                $.ajax({
                    url: 'fileRename',
                    method: 'GET',
                    data: { action: 'fetch', category: category },
                    success: function(response) {
                        var files = response.split('\n').filter(function(file) {
                            return file.trim() !== '';
                        });
                        var fileList = $('#files');
                        fileList.empty().append('<option value="">Select a file</option>');
                        files.forEach(function(file) {
                            var option = $('<option></option>').val(file).text(file);
                            fileList.append(option);
                        });
                    },
                    error: function() {
                        alert('Failed to fetch files');
                    }
                });
            }

            $('#renameForm').submit(function(event) {
                event.preventDefault();
                var category = $('#category').val();
                var file = $('#files').val();
                var newName = $('#newName').val();

                if (!category || !file || !newName) {
                    alert('Please select category, file, and enter a new name.');
                    return;
                }

                $('#confirmModal').show();
                $('#confirmMessage').text('Are you sure you want to rename ' + file + ' to ' + newName + '?');
            });

            $('#confirmYes').click(function() {
                var category = $('#category').val();
                var file = $('#files').val();
                var newName = $('#newName').val();

                $.ajax({
                    url: 'fileRename',
                    method: 'POST',
                    data: { action: 'rename', category: category, file: file, newName: newName },
                    success: function(response) {
                        $('#successMessage').text(response);
                        $('#successModal').show();
                        fetchFiles(category);
                    },
                    error: function() {
                        alert('Failed to rename file.');
                    }
                });

                $('#confirmModal').hide();
            });

            $('.close, #confirmNo').click(function() {
                $('.modal').hide();
            });

            $(window).click(function(event) {
                if (event.target == document.getElementById('successModal') ||
                    event.target == document.getElementById('confirmModal')) {
                    $('.modal').hide();
                }
            });
        });
    </script>
</head>
<body>
    <div class="container">
        <h2>Rename File</h2>
        <form id="renameForm">
            <label for="category">Select Category:</label>
            <select id="category" name="category">
                <option value="" selected>Select a category</option>
                <option value="SAP">SAP</option>
                <option value="AGCL">AGCL</option>
            </select><br><br>

            <label for="files">Select File:</label>
            <select id="files" name="files"></select><br><br>

            <label for="newName">New Name:</label>
            <input type="text" id="newName" name="newName"><br><br>

            <button type="submit">Rename File</button>
             <a href="home.jsp" class="btn1">BACK</a>
        </form>
    </div>

    <!-- Confirmation Modal -->
    <div id="confirmModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <p id="confirmMessage"></p>
            <div class="btn-container">
                <button id="confirmYes" class="btn">Yes</button>
                <button id="confirmNo" class="btn">No</button>
            </div>
        </div>
    </div>

    <!-- Success Modal -->
    <div id="successModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <p id="successMessage"></p>
        </div>
    </div>
</body>
</html>
