<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Response.aspx.cs" Inherits="SurveyTrial.Response" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Survey Responses</title>
     <link href="https://unpkg.com/survey-jquery/defaultV2.min.css" type="text/css" rel="stylesheet"/>

</head>
<body>
    <div>
    <input type="text" id="patientNameInput" placeholder="Enter Patient Name" />
    <button onclick="searchByPatient()">Search</button>
        <button onclick="Home()">Home</button>
     </div>

    <div id="surveyResponses"></div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>      
        
        function getSurveyResponses() {

            $.ajax({
                type: "GET",
                url: "api/Survey/GetSurveyResponses",
                contentType: "application/json; charset=utf-8",
                success: function (data) {

                    console.log(data);
                    displaySurveyResponses(data);

                },
                error: function () {
                    alert("Error fetching survey responses!");
                }
            });
        }
        function Home() {
            window.location.href = "HomePage.aspx";
        }
        function displaySurveyResponses(data) {
            var surveyResponsesElement = document.getElementById("surveyResponses");
            surveyResponsesElement.innerText = data;
        }
        getSurveyResponses();

        function searchByPatient() {
              var patientName = document.getElementById("patientNameInput").value;
            if (patientName.trim() === "") {
                alert("Please enter a valid patient name.");
            return;
              }

            $.ajax({
                type: "GET",
                url: "api/Survey/GetSurveyResponsesByPatient/" + encodeURIComponent(patientName),
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                     console.log(data);
                     displaySurveyResponses(data);
                 },
                error: function () {
                alert("Error fetching survey responses!");
                }

             });
          }

            function displaySurveyResponses(data) {
        var surveyResponsesElement = document.getElementById("surveyResponses");
            surveyResponsesElement.innerText = data;
    }
    </script>

</body>
</html>
