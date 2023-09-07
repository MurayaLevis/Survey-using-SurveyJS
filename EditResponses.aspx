<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditResponses.aspx.cs" Inherits="SurveyTrial.EditResponses" %>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Survey Responses</title>
    <link href="https://unpkg.com/survey-jquery/defaultV2.min.css" type="text/css" rel="stylesheet">
</head>
<body>
    <div id="surveyContainer"></div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="Scripts/survey.jquery.min.js"></script>
<select id="surveyDropdown">
</select>
<input type="text" id="patientNameInput" placeholder="Enter Patient's Name">
<button type="button" id="fetchResponsesButton">Fetch Responses</button>
     <button onclick="Home()">Home</button>

<div id="editSurveyContainer"></div>

<script>
    function Home() {
        window.location.href = "HomePage.aspx";
    }
    $(document).ready(function () {
        var editSurveyContainer = $("#editSurveyContainer");
        $.ajax({
            type: "GET",
            url: "api/Survey/GetSurveyTitles",
            success: function (surveyTitles) {
                var surveyDropdown = $("#surveyDropdown");
                surveyDropdown.empty(); 

                surveyTitles.forEach(function (title) {
                    surveyDropdown.append("<option value='" + title + "'>" + title + "</option>");
                });
            },
            error: function (xhr, status, error) {
                console.error(xhr.responseText);
                alert("Error fetching survey titles: " + error);
            }
        });

        $("#fetchResponsesButton").on("click", function () {
            var surveyTitle = $("#surveyDropdown").val();
            var patientName = $("#patientNameInput").val().trim();

            if (surveyTitle !== "" && patientName !== "") {
                $.ajax({
                    type: "GET",
                    url: "api/Survey/GetSurveyByTitles/" + encodeURIComponent(surveyTitle),
                    success: function (surveyData) {
                        var surveyJson = surveyData.SurveyJSON;
                        console.log(surveyData);
                        $.ajax({
                            type: "GET",
                            url: "api/Survey/GetSavedResponses/" + encodeURIComponent(patientName),
                            success: function (data) {
                                var savedResponses = data;
                                console.log(savedResponses);
                                var mergedData = $.extend({}, surveyJson, savedResponses);
                                var survey = new Survey.Model(surveyJson);
                                survey.data = mergedData;
                                editSurveyContainer.Survey({ model: survey });
                            },
                            error: function (xhr, status, error) {
                                console.error(xhr.responseText);
                                alert("Error fetching saved responses: " + error);
                            }
                        });
                    },
                    error: function (xhr, status, error) {
                        console.error(xhr.responseText);
                        alert("Error fetching survey: " + error);
                    }
                });
            } else {
                alert("Please select a survey and enter a patient's name.");
            }
        });
    });
</script>

</body>
</html>



