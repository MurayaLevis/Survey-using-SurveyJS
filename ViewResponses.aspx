!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Survey Responses</title>
    <link href="https://unpkg.com/survey-jquery/defaultV2.min.css" type="text/css" rel="stylesheet"/>
</head>
<body>
    <div>
        <input type="text" id="patientNameInput" placeholder="Enter Patient Name" />
        <button onclick="SearchByPatient()">Search</button>
        <button onclick="Home()">Home</button>
    </div>

    <div id="surveyResponses"></div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="Scripts/survey.jquery.min.js"></script>
    <script>
        var editMode = false; 
        var responsesData = {}; 

        function Home()
        {
            window.location.href = "HomePage.aspx";
        }

        function SearchByPatient()
        {
            var PatientName = document.getElementById("patientNameInput").value;
            if (PatientName.trim() === "")
            {
                alert("Please enter a valid patient name.");
                return;
            }

            $.ajax({
                type: "GET",
                url: "api/Survey/GetSurveyResponses/" + encodeURIComponent(PatientName),
                contentType: "application/json; charset=utf-8",
                success: function (data)
                {
                    console.log(data);
                    responsesData = JSON.parse(data);
                    DisplaySurveyResponses(responsesData);
                },
                error: function ()
                {
                    alert("Error fetching survey responses!");
                }
            });
        }

        function DisplaySurveyResponses(data)
        {
            var surveyResponsesElement = document.getElementById("surveyResponses");

            surveyResponsesElement.innerHTML = "";

            if (data.length > 0)
            {
                data.forEach(function (surveyItem)
                {
                    var patientNameHeading = document.createElement("h2");
                    patientNameHeading.innerHTML = "Patient Name: " + surveyItem.patientName;
                    surveyResponsesElement.appendChild(patientNameHeading);

                    var surveyTitleHeading = document.createElement("h3");
                    surveyTitleHeading.innerHTML = "Survey Title: " + surveyItem.title;
                    surveyResponsesElement.appendChild(surveyTitleHeading);

                    try
                    {
                        var responsesData = JSON.parse(surveyItem.responses);

                        var table = document.createElement("table");
                        table.border = "1";

                        var headers = ["Survey Question", "Response"];
                        var headerRow = document.createElement("tr");

                        for (var i = 0; i < headers.length; i++)
                        {
                            var headerCell = document.createElement("th");
                            headerCell.innerHTML = headers[i];
                            headerRow.appendChild(headerCell);
                        }

                        table.appendChild(headerRow);

                        for (var key in responsesData)
                        {
                            var row = document.createElement("tr");

                            var questionCell = document.createElement("td");
                            questionCell.innerHTML = key;
                            row.appendChild(questionCell);

                            var responseText = responsesData[key];
                            var responseCell = document.createElement("td");
                            responseCell.innerHTML = responseText;
                            row.appendChild(responseCell);

                            table.appendChild(row);
                        }

                        surveyResponsesElement.appendChild(table);
                    } catch (error)
                    {
                        console.error("Error parsing 'responses' property as JSON:", error);
                    }

                    var editButton = document.createElement("button");
                    editButton.innerHTML = "Edit";
                    editButton.onclick = function () {
                        if (!editMode)
                        {
                            editMode = true;
                            editButton.innerHTML = "Save";
                            EnableEditInputs();
                        } else
                        {
                            editMode = false;
                            editButton.innerHTML = "Edit";
                            let responsesData = DisableEditInputs();

                            SaveSurveyResponsesToDatabase(surveyItem.patientName, surveyItem.title, responsesData);
                           
                        }
                    };

                    surveyResponsesElement.appendChild(editButton);
                });
            } else {
                console.error("Data contains no survey items.");
            }
        }

        var responsesData = {};

        function EnableEditInputs() {
            var responseCells = document.querySelectorAll("#surveyResponses table td:nth-child(2)");
            responseCells.forEach(function (cell) {
                var responseText = cell.innerHTML;
                var editInput = document.createElement("input");

                editInput.type = "text";
               // editInput.value = "";
                editInput.value = responseText;

                cell.innerHTML = "";
                cell.appendChild(editInput);
            });
        }

        function DisableEditInputs() {
            var responseCells = document.querySelectorAll("#surveyResponses table td:nth-child(2) input");
            var responsesData = {}; 
            responseCells.forEach(function (input) {
                console.log(input.value);
                var responseText = input.value;
                var cell = input.parentElement;
                var questionCell = cell.previousElementSibling;
                var question = questionCell.innerHTML.trim();

                responsesData[question] = responseText;
            });


            return JSON.stringify(responsesData);

            
        }



        function SaveSurveyResponsesToDatabase(patientName, surveyTitle, responsesData) {
            var updatedData =
            {
                SurveyTitle: surveyTitle,
                SurveyResponses: JSON.parse(responsesData), 
                PatientName: patientName
            };
            console.log(updatedData)
            $.ajax({
                type: "POST",
                url: "api/Survey/UpdateSavedResponses/" + encodeURIComponent(patientName),
                data: JSON.stringify(updatedData),
                contentType: "application/json; charset=utf-8",
                success: function (data)
                {
                    alert("Survey responses updated successfully!");
                    window.close();
                    window.location.href = "HomePage.aspx";
                },
                error: function (error)
                {
                    alert("Error updating survey responses:", +error);
                }
            });
        }

    </script>
</body>
</html>
